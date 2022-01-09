import Foundation

class Download {
    
    var episode: Episode
    var url: URL?
//    var callback: (Float) -> ()
//    
//    var progress: Float = 0.0 {
//        didSet {
//            self.callback(progress)
//        }
//    }
    
    init(episode: Episode) {
        self.episode = episode
        url = URL(string: episode.remoteUrl)
    }
    
}
