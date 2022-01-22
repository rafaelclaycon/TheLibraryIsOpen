import Foundation

class Utils {

    static func getPodcastSubtitle(episodes: [Episode]) -> String {
        let firstEpisodePubYear = episodes[episodes.count - 1].pubDate!.get(.year)
        let lastEpisodePubYear = episodes[0].pubDate!.get(.year)
        
        var yearText = ""
        if firstEpisodePubYear == lastEpisodePubYear {
            yearText = "\(firstEpisodePubYear)"
        } else {
            yearText = "\(firstEpisodePubYear)-\(lastEpisodePubYear)"
        }
        
        var episodiosText = ""
        if episodes.count == 1 {
            episodiosText = LocalizableStrings.episode
        } else {
            episodiosText = LocalizableStrings.episodes
        }
        
        return "\(episodes.count) \(episodiosText) · \(yearText)"
    }
    
    static func getEpisodesGroupedByYear(from episodes: [Episode]) -> [EpisodeGroup] {
        var groups = [EpisodeGroup]()
        let dic = Dictionary(grouping: episodes, by: { $0.pubDate!.get(.year) })
        for group in dic {
            groups.append(EpisodeGroup(title: group.key, value: "\(group.value.count) episodes", episodes: group.value))
        }
        groups.sort(by: { $0.title < $1.title })
        return groups
    }
    
    static func getSizeInBytesOf(_ episodes: [Episode]) -> Int64 {
        guard episodes.count > 0 else {
            return 0
        }
        var totalSize = 0
        for episode in episodes {
            totalSize += episode.filesize
        }
        return Int64(totalSize)
    }
    
    static func getSizeOf(episodes: [Episode], withSpaceAndParenteses: Bool = true) -> String {
        guard episodes.count > 0 else {
            return ""
        }
        var totalSize = 0
        for episode in episodes {
            totalSize += episode.filesize
        }
        // Only episodes with the wrong reported size will have less than a MB.
        guard (totalSize / episodes.count) > 999999 else {
            return ""
        }
        if withSpaceAndParenteses {
            return " (\(ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file)))"
        }
        return "\(ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file))"
    }
    
    static func getFormattedFileSize(of number: Int64) -> String {
        return "\(ByteCountFormatter.string(fromByteCount: number, countStyle: .file))"
    }

}
