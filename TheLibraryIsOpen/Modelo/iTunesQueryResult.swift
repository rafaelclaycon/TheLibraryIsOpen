//
//  iTunesQueryResult.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 07/03/21.
//

import Foundation

struct iTunesQueryResult: Hashable, Codable {
    var wrapperType: String
    var kind: String
    var collectionId: Int // This is the ID
    var trackId: Int
    var artistName: String
    var collectionName: String
    var trackName: String
    var collectionCensoredName: String
    var trackCensoredName: String
    var collectionViewUrl: String
    var feedUrl: String
    var trackViewUrl: String
    var artworkUrl30: String
    var artworkUrl60: String
    var artworkUrl100: String
    var collectionPrice: Double
    var trackPrice: Double
    var trackRentalPrice: Double
    var collectionHdPrice: Double
    var trackHdPrice: Double
    var trackHdRentalPrice: Double
    var releaseDate: String
    var collectionExplicitness: String
    var trackExplicitness: String
    var trackCount: Int
    var country: String
    var currency: String
    var primaryGenreName: String
    var contentAdvisoryRating: String
    var artworkUrl600: String
    var genreIds: [String]
    var genres: [String]
}
