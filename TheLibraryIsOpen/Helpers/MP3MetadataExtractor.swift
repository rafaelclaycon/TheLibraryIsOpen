import Foundation
import AVFoundation
import ID3TagEditor

class MP3MetadataExtractor {

    static func getEpisodeArtwork(from filepath: String) -> Data? {
        guard filepath.isEmpty == false else {
            return nil
        }
        
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
    
    static func getEpisodeDescription(from filepath: String) -> String? {
        guard filepath.isEmpty == false else {
            return nil
        }
        
        let id3TagEditor = ID3TagEditor()
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sourceURL = documentsDirURL.appendingPathComponent(filepath)
         
        let path = sourceURL.relativePath
        print(path)
         
        do {
            if let id3Tag = try id3TagEditor.read(from: path) {
                let frameName = FrameName.comment(ID3FrameContentLanguage(rawValue: "eng")!)
                if let comments = id3Tag.frames[frameName] {
                    return (comments as? ID3FrameWithStringContent)?.content ?? .empty
                /*} else {
                    internalGetEpisodeDescription(from: path)*/
                }
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
    // TODO: Implement description extraction from non-ID3-comment-tag-using episodes
    /*static func internalGetEpisodeDescription(from filepath: String) -> String? {
        guard filepath.isEmpty == false else {
            return nil
        }
        
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sourceURL = documentsDirURL.appendingPathComponent(filepath)
        let playerItem = AVPlayerItem(url: sourceURL)
        let metadataList = playerItem.asset.metadata
        
        for item in metadataList {
            guard let key = item.commonKey?.rawValue, let value = item.value else {
                continue
            }
            print("HERMIONE: \(key)")
//            switch key {
//            case "artwork" where value is Data:
//                return value as? Data
//            default:
//                continue
//            }
        }
        
        return nil
    }*/

}
