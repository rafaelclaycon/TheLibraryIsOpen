//
//  Utils.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 10/03/21.
//

import Foundation

class Utils {
    static func getSubtituloPodcast(episodes: [Episode]) -> String {
        print(episodes.count)
        print(episodes[0].title)
        
        return "\(episodes.count) episódios · "
    }
}
