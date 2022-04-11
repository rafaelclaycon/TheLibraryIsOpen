import Foundation
import Alamofire

class DataManager {

    private var database: LocalDatabase?

    var podcasts: [Podcast]?

    init(database injectedDatabase: LocalDatabase?) {
        guard injectedDatabase != nil else {
            return
        }

        database = injectedDatabase
    }

//    private func fetchRemoteFile(_ episode: Episode) {
//        FeedHelper.fetchEpisodeFile(streamURL: episode.remoteUrl, podcastID: episode.podcastId, episodeID: episode.id) { [weak self] filePath, error in
//            guard let strongSelf = self else {
//                return
//            }
//            guard error == nil else {
//                fatalError(error!.localizedDescription)
//            }
//            guard filePath != nil else {
//                fatalError()
//            }
//            guard let url = URL(string: filePath!) else {
//                fatalError()
//            }
//
//            // Seizes the opportunity to save the local file path onto the episode.
//            do {
//                try strongSelf.updateLocalFilePath(forEpisode: episode, with: url.lastPathComponent)
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//        }
//    }
    
    func cleanUpDatabase() {
        do {
            try database?.deleteAllEpisodes()
            try database?.deleteAllPodcasts()
            try database?.deleteAllHistoryRecords()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func persist(podcast: Podcast, withEpisodes episodes: [Episode]) throws {
        guard try database?.exists(podcastId: podcast.id) == false else {
            throw DataManagerError.podcastAlreadyExists
        }
        try database?.insert(podcast: podcast)
        try episodes.forEach {
            try database?.insert(episode: $0)
        }
        try database?.insert(record: PodcastHistoryRecord(podcastId: podcast.id,
                                                          type: HistoryRecordType.podcastArchived.rawValue,
                                                          value1: "\(episodes.count)"))
    }
    
    func addHistoryRecord(for podcastId: Int, with recordType: HistoryRecordType, value1: String, value2: String? = nil) throws {
        try database?.insert(record: PodcastHistoryRecord(podcastId: podcastId,
                                                          type: recordType.rawValue,
                                                          value1: value1,
                                                          value2: value2))
    }
    
    func updateEpisodesLocalFilepathAndOfflineStatus(_ episodes: [Episode]) {
        episodes.forEach {
            database?.updateLocalFilepath(forEpisode: $0.id, with: $0.localFilepath ?? .empty, and: $0.offlineStatus)
        }
    }
    
    func exists(podcastId: Int) throws -> Bool {
        guard let database = database else {
            throw DataManagerError.localDatabaseNotInstanced
        }
        return try database.exists(podcastId: podcastId)
    }
    
    func getPodcasts() throws -> [Podcast]? {
        guard var obtainedPodcasts = try database?.getAllPodcasts(), obtainedPodcasts.count > 0 else {
            return nil
        }
        for i in 0...(obtainedPodcasts.count - 1) {
            if let episodes = try database?.getAllEpisodes(forID: obtainedPodcasts[i].id) {
                obtainedPodcasts[i].episodes = episodes
                let downloadedEpisodes = obtainedPodcasts[i].episodes?.filter {
                    $0.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
                }
                if downloadedEpisodes != nil {
                    obtainedPodcasts[i].totalSize = Utils.getSizeInBytesOf(downloadedEpisodes!)
                }
            }
        }
        var records: [PodcastHistoryRecord]?
        for i in 0...(obtainedPodcasts.count - 1) {
            records = try database?.getAllHistoryRecords(forID: obtainedPodcasts[i].id)
            if let unwrappedRecords = records {
                let exportedTypeRecords = unwrappedRecords.filter {
                    $0.type == HistoryRecordType.archiveExported.rawValue
                }
                if exportedTypeRecords.count > 0 {
                    obtainedPodcasts[i].exportedIn = exportedTypeRecords[0].dateTime
                    obtainedPodcasts[i].lastExportedEpisodeCount = Int(exportedTypeRecords[0].value1)
                }
            }
        }
        return obtainedPodcasts
    }

    func addEpisodes(_ episodes: [Episode], podcastID: Int) throws {
        guard podcasts != nil else {
            throw DataManagerError.podcastArrayIsUninitialized
        }
        guard let podcastIndex = podcasts?.firstIndex(where: { $0.id == podcastID }) else {
            throw DataManagerError.podcastIDNotFound
        }

        if podcasts![podcastIndex].episodes == nil {
            podcasts![podcastIndex].episodes = [Episode]()
        }
        podcasts![podcastIndex].episodes!.append(contentsOf: episodes)

        for episode in episodes {
            try database?.insert(episode: episode)
        }
    }
    
    func getEpisodes(forPodcastID podcastID: Int, feedURL: String, completionHandler: @escaping ([Episode]?, FeedHelperError?) -> Void) {
        guard let podcast = podcasts?.first(where: { $0.id == podcastID }) else {
            return
        }

        // 1. First tries to get the episodes from memory.
        if let episodes = podcast.episodes, episodes.count > 0 {
            print("IN-MEMORY FETCH: podcast \(podcastID)")
            completionHandler(episodes, nil)
            return
        }

        do {
            let localEpisodes = try database!.getAllEpisodes(forID: podcastID)

            // 2. If there are no episodes in memory, tries the local DB.
            if localEpisodes.count > 0 {
                print("LOCAL FETCH: podcast \(podcastID)")
                completionHandler(localEpisodes, nil)
                do {
                    try addEpisodes(localEpisodes, podcastID: podcastID)
                } catch {
                    print(error.localizedDescription)
                }

                // 3. If that fails, tries to get them from the podcast's hosting server.
            } else {
                print("REMOTE FETCH: podcast \(podcastID)")

                FeedHelper.fetchPodcast(feedURL: feedURL) { [weak self] result, error in
                    guard let strongSelf = self else {
                        return
                    }

                    guard error == nil else {
                        fatalError(error!.localizedDescription)
                    }

                    switch result {
                    case let .success(feed):
                        guard let feed = feed.rssFeed else {
                            return completionHandler(nil, FeedHelperError.notAnRSSFeed)
                        }
                        guard let items = feed.items else {
                            return completionHandler(nil, FeedHelperError.emptyFeed)
                        }

                        var episodes = [Episode]()

                        for item in items {
                            episodes.append(FeedHelper.getEpisodeFrom(rssFeedItem: item, podcastID: podcastID))
                        }

                        do {
                            try strongSelf.addEpisodes(episodes, podcastID: podcastID)
                        } catch {
                            fatalError(error.localizedDescription)
                        }

                        completionHandler(episodes, nil)

                    case let .failure(error):
                        print(error.localizedDescription)
                    case .none:
                        fatalError("None")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateLocalFilePath(forEpisode episode: Episode, with filePath: String) throws {
        // Update it on the in-memory array.
        try updateInMemoryEpisodeLocalFilePath(podcastID: episode.podcastId, episodeID: episode.id, filePath: filePath)
        // Update it on the database.
        database!.updateLocalFilepath(forEpisode: episode.id, with: filePath, and: EpisodeOfflineStatus.availableOffline.rawValue)
    }

    private func updateInMemoryEpisodeLocalFilePath(podcastID: Int, episodeID: String, filePath: String) throws {
        guard podcasts != nil else {
            throw DataManagerError.podcastArrayIsUninitialized
        }
        guard let podcastIndex = podcasts?.firstIndex(where: { $0.id == podcastID }) else {
            throw DataManagerError.podcastIDNotFound
        }
        guard podcasts![podcastIndex].episodes != nil else {
            throw DataManagerError.episodeArrayIsUninitialized
        }
        guard let episodeIndex = podcasts![podcastIndex].episodes!.firstIndex(where: { $0.id == episodeID }) else {
            throw DataManagerError.episodeIDNotFound
        }
        podcasts![podcastIndex].episodes![episodeIndex].localFilepath = filePath
    }
    
    func downloadiTunesJSON(link: String, podcastID: Int, completionHandler: @escaping (String?, DataManagerError?) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            let tempURL = FileManager.default.temporaryDirectory
            let fileURL = tempURL.appendingPathComponent("iTunesAPIRequest_\(podcastID).json")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(link, to: destination).response { response in
            debugPrint(response)

            guard response.error == nil else {
                return completionHandler(nil, .downloadError)
            }
            guard let filePath = response.fileURL?.path else {
                return completionHandler(nil, .failedToProvideLocalFileURL)
            }

            completionHandler(filePath, nil)
        }
    }
    
    func getFeedDetails(fromLink podcastLink: String, completionHandler: @escaping (FeedDetail?, DataManagerError?) -> Void) throws {
        let podcastId = try LinkWizard.getIdFrom(url: podcastLink)
        
        let linkConsulta = "https://itunes.apple.com/lookup?id=\(podcastId)&entity=podcast"
        
        downloadiTunesJSON(link: linkConsulta, podcastID: podcastId) { [weak self] filePath, error in
            guard self != nil else {
                return
            }
            guard error == nil else {
                return completionHandler(nil, .downloadError)
            }
            guard filePath != nil else {
                return completionHandler(nil, .filePathCameEmpty)
            }
            
            let url = URL(fileURLWithPath: filePath!)
            let data = try! Data(contentsOf: url)
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    guard let resultCount = json["resultCount"] as? Int else {
                        return completionHandler(nil, .iTunesQueryReturnedNoResults)
                    }
                    guard resultCount == 1 else {
                        return completionHandler(nil, .iTunesQueryReturnedNoResults)
                    }
                    guard let results = json["results"] as? [[String: Any]] else {
                        return completionHandler(nil, .naoFoiPossivelInterpretarResultadoiTunes)
                    }
                    let podcast = results[0]
                    
                    guard let feedUrl = podcast["feedUrl"] as? String else {
                        return completionHandler(nil, .resultadoiTunesInesperado)
                    }
                    
                    // Ajusta o URL do feed para sempre tentar carregar de uma conexão segura.
                    // Esse ajuste é necessário para conseguir usar o feed do Wanda, por exemplo.
                    var feedUrlAjustado = String.empty
                    if feedUrl.contains("https:") {
                        feedUrlAjustado = feedUrl
                    } else {
                        feedUrlAjustado = try LinkWizard.fixURLfromHTTPToHTTPS(feedUrl)
                    }
                    
                    completionHandler(FeedDetail(feedUrl: feedUrlAjustado, podcastId: podcastId), nil)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completionHandler(nil, .failedToLoadJSON)
            }
        }
    }
    
    func getPodcast(from userProvidedLink: String, completionHandler: @escaping (Podcast?, Error?) -> Void) throws {
        try getFeedDetails(fromLink: userProvidedLink) { feedDetails, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let feedDetails = feedDetails else {
                fatalError()
            }
            FeedHelper.fetchPodcast(feedURL: feedDetails.feedUrl) { result, error in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }

                switch result {
                case let .success(feed):
                    guard let feed = feed.rssFeed else {
                        return completionHandler(nil, FeedHelperError.notAnRSSFeed)
                    }
                    guard let items = feed.items else {
                        return completionHandler(nil, FeedHelperError.emptyFeed)
                    }

                    var podcast = Podcast(id: feedDetails.podcastId)
                    podcast.title = feed.title ?? LocalizableStrings.unknownTitle
                    podcast.author = feed.iTunes?.iTunesAuthor ?? LocalizableStrings.unknownAuthor
                    podcast.feedUrl = feedDetails.feedUrl
                    podcast.artworkUrl = feed.iTunes?.iTunesImage?.attributes?.href ?? feed.image?.url ?? .empty
                    
                    if podcast.artworkUrl.isEmpty == false, podcast.artworkUrl.contains("https") == false {
                        do {
                            podcast.artworkUrl = try LinkWizard.fixURLfromHTTPToHTTPS(podcast.artworkUrl)
                        } catch {
                            print("Failed to correct artwork link for \(podcast.title). URL: \(podcast.artworkUrl) Error: \(error.localizedDescription)")
                        }
                    }
                    
                    podcast.lastCheckDate = Date()
                    podcast.episodes = [Episode]()

                    for item in items {
                        podcast.episodes!.append(FeedHelper.getEpisodeFrom(rssFeedItem: item, podcastID: feedDetails.podcastId))
                    }
                    
                    if podcast.episodes != nil {
                        let downloadedEpisodes = podcast.episodes!.filter {
                            $0.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
                        }
                        podcast.totalSize = Utils.getSizeInBytesOf(downloadedEpisodes)
                    }

                    completionHandler(podcast, nil)

                case .failure(_):
                    completionHandler(nil, FeedHelperError.unableToAccessRSSFeed)
                    
                case .none:
                    fatalError("None")
                }
            }
        }
    }
    
    func download(episodeArray: [Episode],
                  podcastId: Int,
                  progressCallback: @escaping (String, Double) -> Void,
                  completionHandler: @escaping (Bool) -> Void) {
        var array = episodeArray
        
        if let episodio = array.popLast() {
            guard !episodio.remoteUrl.isEmpty else {
                fatalError("URL vazio.")
            }
            guard let url = URL(string: episodio.remoteUrl) else {
                fatalError("Não foi possível gerar URL a partir da string.")
            }
            
            let destino: DownloadRequest.Destination = { _, _ in
                let cachesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = cachesURL.appendingPathComponent("Podcasts/\(podcastId)/\(url.lastPathComponent)")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            AF.download(episodio.remoteUrl, to: destino)
                .downloadProgress(closure: { progress in
                    progressCallback(episodio.id, progress.fractionCompleted)
                })
                .response { response in
                    /*guard response.error == nil else {
                        return completionHandler(nil, .downloadError)
                    }
                    guard let filePath = response.fileURL?.path else {
                        return completionHandler(nil, .failedToProvideLocalFileURL)
                    }*/
                
                    self.download(episodeArray: array, podcastId: podcastId, progressCallback: progressCallback, completionHandler: completionHandler)
                }
        } else {
            completionHandler(true)
        }
    }
    
    func deletePodcastFromArchive(withId podcastId: Int) throws {
        try database?.deleteAllEpisodes(fromPodcast: podcastId)
        try database?.deletePodcast(withId: podcastId)
    }
    
    func getPodcastHistory(from podcastId: Int) throws -> [PodcastHistoryRecord] {
        guard let db = database else {
            throw DataManagerError.localDatabaseNotInstanced
        }
        return try db.getAllHistoryRecords(forID: podcastId)
    }

}

enum DataManagerError: Error {

    case podcastAlreadyExists
    case localDatabaseNotInstanced
    case podcastIDNotFound
    case episodeIDNotFound
    case podcastArrayIsUninitialized
    case episodeArrayIsUninitialized
    case podcastHasNoEpisodes
    case naoPodeObterPodcastID
    case linkInvalido
    case downloadError
    case failedToProvideLocalFileURL
    case urlVazia
    case naoLinkApplePodcasts
    case idNaoEncontrado
    case erroObtendoIdAPartirDaURL
    case failedToLoadJSON
    case filePathCameEmpty
    case couldNotCreateURLFromFilePath
    case iTunesQueryReturnedNoResults
    case naoFoiPossivelInterpretarResultadoiTunes
    case urlNaoEHTTP
    case resultadoiTunesInesperado
    case noPodcasts

}
