import Foundation

class Utils {

    static func getSubtituloPodcast(episodes: [Episodio]) -> String {
        let firstEpisodePubYear = episodes[episodes.count - 1].dataPublicacao!.get(.year)
        let lastEpisodePubYear = episodes[0].dataPublicacao!.get(.year)
        
        var yearText = ""
        if firstEpisodePubYear == lastEpisodePubYear {
            yearText = "\(firstEpisodePubYear)"
        } else {
            yearText = "\(firstEpisodePubYear)-\(lastEpisodePubYear)"
        }
        
        var episodiosText = ""
        if episodes.count == 1 {
            episodiosText = "episódio"
        } else {
            episodiosText = "episódios"
        }
        
        return "\(episodes.count) \(episodiosText) · \(yearText)"
    }
    
    static func getEpisodesGroupedByYear(from episodes: [Episodio]) -> [EpisodeGroup] {
        var groups = [EpisodeGroup]()
        let dic = Dictionary(grouping: episodes, by: { $0.dataPublicacao!.get(.year) })
        for group in dic {
            groups.append(EpisodeGroup(title: group.key, value: "\(group.value.count) episódios", episodes: group.value))
        }
        groups.sort(by: { $0.title < $1.title })
        return groups
    }
    
    func getSize(ofEpisodes episodes: [Episodio]) -> String {
        guard episodes.count > 0 else {
            return ""
        }
        var size = 0
        for episode in episodes {
            size += episode.tamanho
        }
        guard size > 0 else {
            return ""
        }
        return " (\(ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)))"
    }

}
