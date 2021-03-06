//
//  DataManager.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 28/11/20.
//

import Foundation
import Alamofire

class DataManager {
    typealias PodcastFetchMethod = () -> [Podcast]

    private var storage: LocalStorage?

    var podcasts: [Podcast]?

    init(storage injectedStorage: LocalStorage?, fetchMethod: PodcastFetchMethod) {
        guard injectedStorage != nil else {
            return
        }

        storage = injectedStorage

        do {
            if try storage?.getPodcastCount() == 0 {
                let podcasts = fetchMethod()
                for podcast in podcasts {
                    do {
                        try storage?.insert(podcast: podcast)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }

            podcasts = try storage?.getAllPodcasts()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func playLocalFile(_: Episode) {
//        print("Local file path name: \(episode.localFilePath!)")

//        do {
//            let documentsFolderString = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).absoluteString
//            print(documentsFolderString)
//            let newString = documentsFolderString.replacingOccurrences(of: "file://", with: "")
//            print(newString)
//            let documentsFolderURL = URL(string: newString)
//            let episodeURL = documentsFolderURL!.appendingPathComponent("Podcasts/\(episode.podcastID)/").appendingPathComponent(episode.localFilePath!)

        let path = Bundle.main.path(forResource: "PodcastPraiadosOssosTrailer.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)

        print(url)

        player = Player(url: url, update: { state in
            print(state?.activity as Any)
        })

//        } catch {
//            print(error.localizedDescription)
//        }
    }

    private func fetchRemoteFile(_ episode: Episode) {
        FeedHelper.fetchEpisodeFile(streamURL: episode.remoteURL, podcastID: episode.podcastID, episodeID: episode.id) { [weak self] filePath, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            guard filePath != nil else {
                fatalError()
            }
            guard let url = URL(string: filePath!) else {
                fatalError()
            }

            // Seizes the opportunity to save the local file path onto the episode.
            do {
                try strongSelf.updateLocalFilePath(forEpisode: episode, with: url.lastPathComponent)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private func play(episode: Episode) {
        if episode.localFilePath != nil {
            playLocalFile(episode)
        } else {
            fetchRemoteFile(episode)
        }
    }
    
    private func download(episode: Episode) {
        if episode.localFilePath == nil {
            fetchRemoteFile(episode)
        }
    }

    func playEpisode(byID episodeID: String, podcastID: Int) throws {
        guard let podcast = podcasts?.first(where: { $0.id == podcastID }) else {
            throw DataManagerError.podcastIDNotFound
        }
        guard let episode = podcast.episodes?.first(where: { $0.id == episodeID }) else {
            throw DataManagerError.episodeIDNotFound
        }
        play(episode: episode)
    }
    
    func downloadAllEpisodes(from podcastID: Int) throws {
        guard let podcast = podcasts?.first(where: { $0.id == podcastID }) else {
            throw DataManagerError.podcastIDNotFound
        }
        guard podcast.episodes != nil else {
            throw DataManagerError.podcastHasNoEpisodes
        }
        
        podcast.episodes!.forEach({ episode in
            download(episode: episode)
        })
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
            try storage?.insert(episode: episode)
        }
    }
    
    func ajustar_URL_HTTP_Para_HTTPS(_ url: String) throws -> String {
        guard !url.isEmpty else {
            throw DataManagerError.urlVazia
        }
        guard let index = url.index(of: "http:") else {
            throw DataManagerError.urlNaoEHTTP
        }
        let start = url.index(index, offsetBy: 5)
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        return "https:" + url[range]
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
            let localEpisodes = try storage!.getAllEpisodes(forID: podcastID)

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
        try updateInMemoryEpisodeLocalFilePath(podcastID: episode.podcastID, episodeID: episode.id, filePath: filePath)
        // Update it on the database.
        storage!.updateLocalFilePath(forEpisode: episode.id, with: filePath)
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
        podcasts![podcastIndex].episodes![episodeIndex].localFilePath = filePath
    }
    
    func downloadiTunesJSON(link: String, podcastID: Int, completionHandler: @escaping (String?, DataManagerError?) -> Void) {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("Podcasts/\(podcastID)/ConsultaiTunes.json")

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
    
    func getIDFromURL(_ url: String) throws -> Int {
        guard !url.isEmpty else {
            throw DataManagerError.urlVazia
        }
        guard url.contains("https://podcasts.apple.com") else {
            throw DataManagerError.naoLinkApplePodcasts
        }
        guard let index = url.index(of: "/id") else {
            throw DataManagerError.idNaoEncontrado
        }
        let start = url.index(index, offsetBy: 3) // Offset by 3 para pular p "/id"
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        guard let id = Int(url[range]) else {
            throw DataManagerError.erroObtendoIdAPartirDaURL
        }
        return id
    }
    
    func getFeedDetails(applePodcastsURL: String, completionHandler: @escaping (FeedDetail?, DataManagerError?) -> Void) throws {
        let podcastId = try getIDFromURL(applePodcastsURL)
        
        let linkConsulta = "https://itunes.apple.com/lookup?id=\(podcastId)&entity=podcast"
        
        downloadiTunesJSON(link: linkConsulta, podcastID: podcastId) { [weak self] filePath, error in
            guard let strongSelf = self else {
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
                        return completionHandler(nil, .queryiTunesSemResultados)
                    }
                    guard resultCount == 1 else {
                        return completionHandler(nil, .queryiTunesSemResultados)
                    }
                    guard let results = json["results"] as? [[String: Any]] else {
                        return completionHandler(nil, .naoFoiPossivelInterpretarResultadoiTunes)
                    }
                    let podcast = results[0]
                    
                    guard let feedUrl = podcast["feedUrl"] as? String else {
                        return completionHandler(nil, .resultadoiTunesInesperado)
                    }
                    
                    // Ajusta o URL do feed para sempre tentar carregar de uma conex??o segura.
                    // Esse ajuste ?? necess??rio para conseguir usar o feed do Wanda, por exemplo.
                    var feedUrlAjustado = ""
                    if feedUrl.contains("https:") {
                        feedUrlAjustado = feedUrl
                    } else {
                        feedUrlAjustado = try strongSelf.ajustar_URL_HTTP_Para_HTTPS(feedUrl)
                    }
                    
                    completionHandler(FeedDetail(feedUrl: feedUrlAjustado, podcastId: podcastId), nil)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completionHandler(nil, .failedToLoadJSON)
            }
        }
    }
    
    func obterPodcast(applePodcastsURL: String, completionHandler: @escaping (Podcast?, FeedHelperError?) -> Void) throws {
        try getFeedDetails(applePodcastsURL: applePodcastsURL) { feedDetails, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
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
                    podcast.title = feed.title ?? "Sem T??tulo"
                    podcast.author = feed.iTunes?.iTunesAuthor ?? "Sem Autor"
                    podcast.feedURL = feedDetails.feedUrl
                    podcast.artworkURL = feed.image?.link ?? ""

                    for item in items {
                        podcast.episodes!.append(FeedHelper.getEpisodeFrom(rssFeedItem: item, podcastID: feedDetails.podcastId))
                    }

                    completionHandler(podcast, nil)

                case let .failure(error):
                    print(error.localizedDescription)
                case .none:
                    fatalError("None")
                }
            }
        }
    }
}

enum DataManagerError: Error {
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
    case queryiTunesSemResultados
    case naoFoiPossivelInterpretarResultadoiTunes
    case urlNaoEHTTP
    case resultadoiTunesInesperado
}
