import Foundation
import SQLite

class LocalStorage {

    private var db: Connection
    private var podcast = Table("podcast")
    private var episode = Table("episode")
    private var podcastHistoryRecord = Table("podcasthistoryrecord")

    // MARK: - Init

    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory, .userDomainMask, true
        ).first!

        do {
            db = try Connection("\(path)/tlio_db.sqlite3")
            try createPodcastTable()
            try createEpisodeTable()
            try createPodcastHistoryRecordTable()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func createPodcastTable() throws {
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        let author = Expression<String>("author")
        let feed_url = Expression<String>("feedUrl")
        let artwork_url = Expression<String>("artworkUrl")
        let last_check_date = Expression<Date?>("lastCheckDate")

        try db.run(podcast.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(title)
            t.column(author)
            t.column(feed_url)
            t.column(artwork_url)
            t.column(last_check_date)
        })
    }

    private func createEpisodeTable() throws {
        let id = Expression<String>("id")
        let podcast_id = Expression<Int64>("podcastId")
        let title = Expression<String>("title")
        let pub_date = Expression<Date?>("pubDate")
        let duration = Expression<Double>("duration")
        let remote_url = Expression<String>("remoteUrl")
        let local_filepath = Expression<String?>("localFilepath")
        let filesize = Expression<Int64>("filesize")
        let offline_status = Expression<Int>("offlineStatus")

        try db.run(episode.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(podcast_id)
            t.column(title)
            t.column(pub_date)
            t.column(duration)
            t.column(remote_url)
            t.column(local_filepath)
            t.column(filesize)
            t.column(offline_status)
        })
    }
    
    private func createPodcastHistoryRecordTable() throws {
        let id = Expression<String>("id")
        let podcast_id = Expression<Int>("podcastId")
        let symbol = Expression<String?>("symbol")
        let title = Expression<String>("title")
        let description = Expression<String?>("description")
        let date_time = Expression<Date>("dateTime")

        try db.run(podcastHistoryRecord.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(podcast_id)
            t.column(symbol)
            t.column(title)
            t.column(description)
            t.column(date_time)
        })
    }

    // MARK: - Podcast

    func getPodcastCount() throws -> Int {
        try db.scalar(podcast.count)
    }

    func insert(podcast newPodcast: Podcast) throws {
        let insert = try podcast.insert(newPodcast)
        try db.run(insert)
    }

    func getAllPodcasts() throws -> [Podcast] {
        var queriedPodcasts = [Podcast]()

        for queriedPodcast in try db.prepare(podcast) {
            queriedPodcasts.append(try queriedPodcast.decode())
        }
        return queriedPodcasts
    }

    func deleteAllPodcasts() throws {
        try db.run(podcast.delete())
    }
    
    func exists(podcastId: Int) throws -> Bool {
        var queriedPodcasts = [Podcast]()

        let id = Expression<Int>("id")
        let query = podcast.filter(id == podcastId)

        for queriedPodcast in try db.prepare(query) {
            queriedPodcasts.append(try queriedPodcast.decode())
        }
        return queriedPodcasts.count > 0
    }

    // MARK: - Episode

    func getEpisodeCount() throws -> Int {
        try db.scalar(episode.count)
    }

    func insert(episode newEpisode: Episode) throws {
        let insert = try episode.insert(newEpisode)
        try db.run(insert)
    }

    func getAllEpisodes(forID podcastId: Int) throws -> [Episode] {
        var queriedEpisodes = [Episode]()

        let podcast_id = Expression<Int>("podcastId")
        let query = episode.filter(podcast_id == podcastId)

        for queriedEpisode in try db.prepare(query) {
            queriedEpisodes.append(try queriedEpisode.decode())
        }
        return queriedEpisodes
    }

    func deleteAllEpisodes() throws {
        try db.run(episode.delete())
    }

    func updateLocalFilePath(forEpisode idEpisodio: String, with caminho: String) {
        let id = Expression<String>("id")
        let episodio = episode.filter(id == idEpisodio)
        let caminho_local = Expression<String?>("localFilepath")
        do {
            if try db.run(episodio.update(caminho_local <- caminho)) > 0 {
                print("Episódio \(idEpisodio) atualizado com o caminho: \(caminho)")
            } else {
                print("Episódio \(idEpisodio) não encontrado.")
            }
        } catch {
            print("falha ao tentar atualizar: \(error)")
        }
    }
    
    // MARK: - Podcast History Record

    func getHistoryRecordCount() throws -> Int {
        try db.scalar(podcastHistoryRecord.count)
    }

    func insert(record newRecord: PodcastHistoryRecord) throws {
        let insert = try podcastHistoryRecord.insert(newRecord)
        try db.run(insert)
    }

    func getAllHistoryRecords(forID podcastId: Int) throws -> [PodcastHistoryRecord] {
        var queriedRecords = [PodcastHistoryRecord]()

        let podcast_id = Expression<Int>("podcastId")
        let query = podcastHistoryRecord.filter(podcast_id == podcastId)

        for queriedRecord in try db.prepare(query) {
            queriedRecords.append(try queriedRecord.decode())
        }
        return queriedRecords
    }

    func deleteAllHistoryRecords() throws {
        try db.run(podcastHistoryRecord.delete())
    }

}
