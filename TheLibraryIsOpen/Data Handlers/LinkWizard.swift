import Foundation

class LinkWizard {

    private static func isApplePodcastsLink(_ link: String) -> Bool {
        return link.contains("podcasts.apple.com") || link.contains("itunes.apple.com")
    }
    
    private static func isCastroLink(_ link: String) -> Bool {
        return link.contains("castro.fm")
    }
    
    private static func isPocketCastsLink(_ link: String) -> Bool {
        return link.contains("pca.st")
    }
    
    private static func isSpotifyLink(_ link: String) -> Bool {
        return link.contains("spotify.com")
    }
    
    static func getIdFrom(url: String) throws -> Int {
        guard !url.isEmpty else {
            throw LinkAssistantError.emptyURL
        }
        guard isSpotifyLink(url) == false else {
            throw LinkAssistantError.spotifyLink
        }
        guard isApplePodcastsLink(url) || isCastroLink(url) || isPocketCastsLink(url) else {
            throw LinkAssistantError.notAValidURL
        }
        
        if isCastroLink(url) {
            guard let myURL = URL(string: url) else {
                throw LinkAssistantError.notAValidURL
            }
            var myHTMLString = ""
            do {
                myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            } catch {
                throw LinkAssistantError.failedToTransformWebsiteLinkToString
            }
            //print(myHTMLString)
            // Pocket Casts part
            guard let preStart = myHTMLString.index(of: "Or Listen Elsewhere"), let end = myHTMLString.index(of: "\"><img alt=\"Listen On Apple Podcasts") else {
                throw LinkAssistantError.pocketCasts_applePodcastsLinkNotFound
            }
            let start = myHTMLString.index(preStart, offsetBy: 77)
            let range = start..<end
            //print(myHTMLString[range])
            return try getIdFrom(url: String(myHTMLString[range]))
        }
        
        if isPocketCastsLink(url) {
            guard let myURL = URL(string: url) else {
                throw LinkAssistantError.notAValidURL
            }
            var myHTMLString = ""
            do {
                myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            } catch {
                throw LinkAssistantError.failedToTransformWebsiteLinkToString
            }
            // Pocket Casts part
            guard let preStart = myHTMLString.index(of: "<div class=\"button itunes_button\"><a href=\""), let end = myHTMLString.index(of: "\" target=\"_blank\">Apple Podcasts</a></div>") else {
                throw LinkAssistantError.pocketCasts_applePodcastsLinkNotFound
            }
            let start = myHTMLString.index(preStart, offsetBy: 43)
            let range = start..<end
            return try getIdFrom(url: String(myHTMLString[range]))
        }
        
        // Apple Podcasts part
        guard let index = url.index(of: "/id") else {
            throw LinkAssistantError.applePodcastsLink_idNotFound
        }
        let start = url.index(index, offsetBy: 3) // Offset by 3 to jump to "/id"
        
        var end: String.Index
        if let indexOfQueryParameters = url.index(of: "?") {
            end = indexOfQueryParameters
        } else {
            end = url.endIndex
        }
        
        let range = start..<end
        guard let id = Int(url[range]) else {
            throw LinkAssistantError.applePodcasts_unableToGetIdFromUrl
        }
        return id
    }
    
    static func fixURLfromHTTPToHTTPS(_ url: String) throws -> String {
        guard !url.isEmpty else {
            throw LinkAssistantError.emptyURL
        }
        guard let index = url.index(of: "http:") else {
            throw LinkAssistantError.urlIsNotHttp
        }
        let start = url.index(index, offsetBy: 5)
        let end = url.endIndex
        let range = start..<end
        return "https:" + url[range]
    }
    
}

enum LinkAssistantError: Error {

    case emptyURL
    case spotifyLink
    case notAValidURL
    case applePodcastsLink_idNotFound
    case applePodcasts_unableToGetIdFromUrl
    case pocketCasts_applePodcastsLinkNotFound
    case pocketCasts_idNotFound
    case pocketCasts_unableToGetIdFromUrl
    case urlIsNotHttp
    case failedToTransformWebsiteLinkToString

}
