import SwiftUI
import ID3TagEditor

class MP3ArtworkExtractor {
    
    // TODO: Get artwork from MP3 ID3 tag
    static func getEpisodeArtwork(from filepath: String) -> Image? {
//        let id3TagEditor = ID3TagEditor()
//        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let sourceURL = documentsDirURL.appendingPathComponent(strongSelf.episodes[i].localFilepath!)
//
//        let path = sourceURL.relativePath
//        print(path)
//
//        do {
//            if let id3Tag = try id3TagEditor.read(from: path) {
//                print(id3Tag)
//                let frameName = FrameName.attachedPicture(.frontCover)
//                if let frontCover = id3Tag.frames[frameName] {
//                    print(frontCover)
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        return Image(systemName: "photo.artframe")
    }
    
}
