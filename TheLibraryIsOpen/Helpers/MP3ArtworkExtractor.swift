import Foundation
import AVFoundation

class MP3ArtworkExtractor {

    static func getEpisodeArtwork(from filepath: String) -> Data? {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sourceURL = documentsDirURL.appendingPathComponent(filepath)
        let playerItem = AVPlayerItem(url: sourceURL)
        let metadataList = playerItem.asset.metadata
        
        for item in metadataList {
            guard let key = item.commonKey?.rawValue, let value = item.value else {
                continue
            }
            switch key {
            case "artwork" where value is Data:
                return value as? Data
            default:
                continue
            }
        }
        
        return nil
    }

}
