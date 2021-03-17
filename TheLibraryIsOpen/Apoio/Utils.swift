//
//  Utils.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 10/03/21.
//

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
}
