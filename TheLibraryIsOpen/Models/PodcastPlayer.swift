import Foundation

struct PodcastPlayer: Hashable, Identifiable {
    
    var id: Int
    var name: String
    var iconName: String
    var type: PodcastPlayerType
    
}

enum PodcastPlayerType {

    case amazonMusic, applePodcasts, castbox, castro, deezer, googlePodcasts, orelo, overcast, pocketCasts, soundCloud, spotify, stitcher

}

class PodcastPlayerFactory {

    static func getPlayers() -> [PodcastPlayer] {
        var players = [PodcastPlayer]()
        players.append(PodcastPlayer(id: 0, name: "Amazon Music", iconName: "amazon_music_icon", type: .amazonMusic))
        players.append(PodcastPlayer(id: 1, name: "Apple Podcasts", iconName: "apple_podcasts_icon", type: .applePodcasts))
        players.append(PodcastPlayer(id: 2, name: "Castbox", iconName: "castbox_icon", type: .castbox))
        players.append(PodcastPlayer(id: 3, name: "Castro", iconName: "castro_icon", type: .castro))
        players.append(PodcastPlayer(id: 4, name: "Deezer", iconName: "deezer_icon", type: .deezer))
        players.append(PodcastPlayer(id: 5, name: "Google Podcasts", iconName: "google_podcasts_icon", type: .googlePodcasts))
        players.append(PodcastPlayer(id: 6, name: "Orelo", iconName: "orelo_icon", type: .orelo))
        players.append(PodcastPlayer(id: 7, name: "Overcast", iconName: "overcast_icon", type: .overcast))
        players.append(PodcastPlayer(id: 8, name: "Pocket Casts", iconName: "pocket_casts_icon", type: .pocketCasts))
        players.append(PodcastPlayer(id: 9, name: "SoundCloud", iconName: "soundcloud_icon", type: .soundCloud))
        players.append(PodcastPlayer(id: 10, name: "Spotify", iconName: "spotify_icon", type: .spotify))
        players.append(PodcastPlayer(id: 11, name: "Stitcher", iconName: "stitcher_icon", type: .stitcher))
        return players
    }

}
