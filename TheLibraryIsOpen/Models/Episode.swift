import Foundation

struct Episode: Hashable, Codable, Identifiable {

    var id: String
    var podcastId: Int
    var title: String
    var pubDate: Date?
    var duration: Double
    var remoteUrl: String
    var localFilepath: String?
    var filesize: Int
    
    init(id: String, podcastId: Int, title: String, pubDate: Date?, duration: Double, remoteUrl: String, filesize: Int) {
        self.id = id
        self.podcastId = podcastId
        self.title = title
        self.pubDate = pubDate
        self.duration = duration
        self.remoteUrl = remoteUrl
        self.localFilepath = nil
        self.filesize = filesize
    }
    
    init(id: String, title: String, pubDate: Date) {
        self.id = id
        podcastId = 0
        self.title = title
        self.pubDate = pubDate
        duration = 0
        remoteUrl = ""
        localFilepath = nil
        filesize = 0
    }
    
    init(remoteUrl: String) {
        id = "0"
        podcastId = 0
        title = ""
        pubDate = Date()
        duration = 0
        self.remoteUrl = remoteUrl
        localFilepath = nil
        filesize = 0
    }
    
    init(filesize: Int) {
        self.init(id: UUID().uuidString,
                  podcastId: 0,
                  title: "",
                  pubDate: nil,
                  duration: 0,
                  remoteUrl: "",
                  filesize: filesize)
    }

}
