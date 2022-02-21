import Foundation
import FeedKit
import Alamofire

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

    static func getEpisodeFrom(rssFeedItem item: RSSFeedItem, podcastID: Int) -> Episode {
        let episode = Episode(id: item.guid?.value ?? UUID().uuidString,
                              podcastId: podcastID,
                              title: item.title ?? "UNTITLED EPISODE",
                              pubDate: item.pubDate,
                              duration: item.iTunes?.iTunesDuration ?? 0,
                              remoteUrl: item.enclosure?.attributes?.url ?? "",
                              filesize: Int(item.enclosure?.attributes?.length ?? 0))
        return episode
    }

//    static func fetchEpisodeFile(streamURL: String, podcastID: Int, episodeID _: String, completionHandler: @escaping (String?, FeedHelperError?) -> Void) {
//        guard !streamURL.isEmpty else {
//            return completionHandler(nil, .emptyURL)
//        }
//        guard let url = URL(string: streamURL) else {
//            return completionHandler(nil, .invalidStreamURL)
//        }
//
//        let destination: DownloadRequest.Destination = { _, _ in
//            let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsDirURL.appendingPathComponent("Podcasts/\(podcastID)/" + UUID().uuidString + "_" + url.lastPathComponent)
//
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//
//        AF.download(streamURL, to: destination).response { response in
//            debugPrint(response)
//
//            guard response.error == nil else {
//                return completionHandler(nil, .downloadError)
//            }
//            guard let filePath = response.fileURL?.path else {
//                return completionHandler(nil, .failedToProvideLocalFileURL)
//            }
//
//            print("Arquivo '\(filePath)' baixado.")
//
//            completionHandler(filePath, nil)
//        }
//    }

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
