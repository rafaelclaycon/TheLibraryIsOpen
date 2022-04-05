import Foundation

class Utils {

    static func getPodcastSubtitle(episodes: [Episode]) -> String {
        guard let firstEpisodePubDate = episodes[episodes.count - 1].pubDate,
              let lastEpisodePubDate = episodes[0].pubDate else {
            var episodiosText = String.empty
            if episodes.count == 1 {
                episodiosText = LocalizableStrings.episode
            } else {
                episodiosText = LocalizableStrings.episodes
            }

            return "\(episodes.count) \(episodiosText)"
        }
        
        let firstEpisodePubYear = firstEpisodePubDate.get(.year)
        let lastEpisodePubYear = lastEpisodePubDate.get(.year)
        
        var yearText = String.empty
        if firstEpisodePubYear == lastEpisodePubYear {
            yearText = "\(firstEpisodePubYear)"
        } else {
            yearText = "\(firstEpisodePubYear)-\(lastEpisodePubYear)"
        }
        
        var episodiosText = String.empty
        if episodes.count == 1 {
            episodiosText = LocalizableStrings.episode
        } else {
            episodiosText = LocalizableStrings.episodes
        }
        
        return "\(episodes.count) \(episodiosText) · \(yearText)"
    }
    
    static func getEpisodesGroupedByYear(from episodes: [Episode]) -> [EpisodeGroup]? {
        let nilDateEpisodes = episodes.filter {
            $0.pubDate == nil
        }
        guard nilDateEpisodes.count == 0 else {
            return nil
        }
        
        var groups = [EpisodeGroup]()
        let dic = Dictionary(grouping: episodes, by: { $0.pubDate!.get(.year) })
        for group in dic {
            groups.append(EpisodeGroup(title: group.key, value: "\(group.value.count) episodes", episodes: group.value))
        }
        groups.sort(by: { $0.title < $1.title })
        
        return groups
    }
    
    static func getSizeInBytesOf(_ episodes: [Episode]) -> Int {
        guard episodes.count > 0 else {
            return 0
        }
        var totalSize = 0
        for episode in episodes {
            totalSize += episode.filesize
        }
        return totalSize
    }
    
    static func getSizeOf(episodes: [Episode], withSpaceAndParenteses: Bool = true) -> String {
        guard episodes.count > 0 else {
            return .empty
        }
        var totalSize = 0
        for episode in episodes {
            totalSize += episode.filesize
        }
        // Only episodes with the wrong reported size will have less than a MB.
        guard (totalSize / episodes.count) > 999999 else {
            return .empty
        }
        if withSpaceAndParenteses {
            return " (\(ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file)))"
        }
        return "\(ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file))"
    }
    
    static func getFormattedFileSize(of number: Int) -> String {
        return "\(ByteCountFormatter.string(fromByteCount: Int64(number), countStyle: .file))"
    }
    
    static func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

}
