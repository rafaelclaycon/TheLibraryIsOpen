import Alamofire
import FeedKit
import Foundation

class FeedHelper {

    static func fetchPodcast(feedURL: String, completionHandler: @escaping (Result<Feed, ParserError>?, FeedHelperError?) -> Void) {
        guard !feedURL.isEmpty else {
            return completionHandler(nil, .emptyURL)
        }

        let url = URL(string: feedURL)!
        let parser = FeedParser(URL: url)

        parser.parseAsync { result in
            completionHandler(result, nil)
        }
    }

    static func getEpisodeFrom(rssFeedItem item: RSSFeedItem, podcastID: Int) -> Episodio {
        let episode = Episodio(id: item.guid?.value ?? UUID().uuidString,
                               idPodcast: podcastID, titulo: item.title ?? "UNTITLED EPISODE",
                               dataPublicacao: item.pubDate,
                               duracao: item.iTunes?.iTunesDuration ?? 0,
                               urlRemoto: item.enclosure?.attributes?.url ?? "",
                               tamanho: Int(item.enclosure?.attributes?.length ?? 0))
        return episode
    }

    static func fetchEpisodeFile(streamURL: String, podcastID: Int, episodeID _: String, completionHandler: @escaping (String?, FeedHelperError?) -> Void) {
        guard !streamURL.isEmpty else {
            return completionHandler(nil, .emptyURL)
        }
        guard let url = URL(string: streamURL) else {
            return completionHandler(nil, .invalidStreamURL)
        }

        let destination: DownloadRequest.Destination = { _, _ in
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = cachesURL.appendingPathComponent("Podcasts/\(podcastID)/\(url.lastPathComponent)")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(streamURL, to: destination).response { response in
            debugPrint(response)

            guard response.error == nil else {
                return completionHandler(nil, .downloadError)
            }
            guard let filePath = response.fileURL?.path else {
                return completionHandler(nil, .failedToProvideLocalFileURL)
            }
            
            print("Arquivo '\(filePath)' baixado.")

            completionHandler(filePath, nil)
        }
    }

}

enum FeedHelperError: Error {

    case emptyURL
    case parsingError
    case notAnRSSFeed
    case emptyFeed
    case noImage
    case invalidStreamURL
    case downloadError
    case failedToProvideLocalFileURL

}
