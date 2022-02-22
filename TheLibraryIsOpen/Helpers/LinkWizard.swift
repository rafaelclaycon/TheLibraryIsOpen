import Foundation

class LinkWizard {

    private static func isApplePodcastsLink(_ link: String) -> Bool {
        return link.contains("podcasts.apple.com") || link.contains("itunes.apple.com")
    }
    
    private static func isCastroLink(_ link: String) -> Bool {
        return link.contains("castro.fm")
    }
    
    private static func isOvercastLink(_ link: String) -> Bool {
        return link.contains("overcast.fm")
    }
    
    private static func isPocketCastsLink(_ link: String) -> Bool {
        return link.contains("pca.st")
    }
    
    private static func isSpotifyLink(_ link: String) -> Bool {
        return link.contains("spotify.com")
    }
    
    static func getIdFrom(url: String) throws -> Int {
        guard !url.isEmpty else {
            throw LinkWizardError.emptyURL
        }
        guard isSpotifyLink(url) == false else {
            throw LinkWizardError.spotifyLink
        }
        guard isApplePodcastsLink(url) || isCastroLink(url) || isOvercastLink(url) || isPocketCastsLink(url) else {
            throw LinkWizardError.notAValidURL
        }
        
        if isCastroLink(url) {
            guard let myURL = URL(string: url) else {
                throw LinkWizardError.notAValidURL
            }
            var htmlString = String.empty
            do {
                htmlString = try String(contentsOf: myURL, encoding: .ascii)
            } catch {
                throw LinkWizardError.castroLink_failedToTransformWebsiteLinkToString
            }
            guard let preStart = htmlString.index(of: "Or Listen Elsewhere"), let end = htmlString.index(of: "\"><img alt=\"Listen On Apple Podcasts") else {
                throw LinkWizardError.castroLink_innerApplePodcastsLinkNotFound
            }
            let start = htmlString.index(preStart, offsetBy: 77)
            let range = start..<end
            return try getIdFrom(url: String(htmlString[range]))
        }
        
        if isOvercastLink(url) {
            guard let myURL = URL(string: url) else {
                throw LinkWizardError.notAValidURL
            }
            var htmlString = String.empty
            do {
                htmlString = try String(contentsOf: myURL, encoding: .ascii)
            } catch {
                throw LinkWizardError.overcastLink_failedToTransformWebsiteLinkToString
            }
            guard let preStart = htmlString.index(of: "/img/badge-overcast-or-wherever.svg"), let preEnd = htmlString.index(of: "><img src=\"/img/badge-apple.svg") else {
                throw LinkWizardError.overcastLink_innerApplePodcastsLinkNotFound
            }
            let start = htmlString.index(preStart, offsetBy: 83)
            let end = htmlString.index(preEnd, offsetBy: -18)
            let range = start..<end
            return try getIdFrom(url: String(htmlString[range]))
        }
        
        if isPocketCastsLink(url) {
            guard let myURL = URL(string: url) else {
                throw LinkWizardError.notAValidURL
            }
            var htmlString = String.empty
            do {
                htmlString = try String(contentsOf: myURL, encoding: .ascii)
            } catch {
                throw LinkWizardError.pocketCastsLink_failedToTransformWebsiteLinkToString
            }
            guard let preStart = htmlString.index(of: "<div class=\"button itunes_button\"><a href=\""), let end = htmlString.index(of: "\" target=\"_blank\">Apple Podcasts</a></div>") else {
                throw LinkWizardError.pocketCastsLink_innerApplePodcastsLinkNotFound
            }
            let start = htmlString.index(preStart, offsetBy: 43)
            let range = start..<end
            let extractedLink = String(htmlString[range])
            guard isApplePodcastsLink(extractedLink) else {
                throw LinkWizardError.pocketCastsLink_innerApplePodcastsLinkIsInvalid
            }
            return try getIdFrom(url: extractedLink)
        }
        
        // Apple Podcasts part
        guard let index = url.index(of: "/id") else {
            throw LinkWizardError.applePodcastsLink_idNotFound
        }
        let start = url.index(index, offsetBy: 3) // Offset by 3 to jump the "/id"
        
        var end: String.Index
        if let indexOfQueryParameters = url.index(of: "?") {
            end = indexOfQueryParameters
        } else {
            end = url.endIndex
        }
        
        let range = start..<end
        guard let id = Int(url[range]) else {
            throw LinkWizardError.applePodcastsLink_unableToGetIdFromUrl
        }
        return id
    }
    
    static func fixURLfromHTTPToHTTPS(_ url: String) throws -> String {
        guard !url.isEmpty else {
            throw LinkWizardError.emptyURL
        }
        guard let index = url.index(of: "http:") else {
            throw LinkWizardError.urlIsNotHttp
        }
        let start = url.index(index, offsetBy: 5)
        let end = url.endIndex
        let range = start..<end
        return "https:" + url[range]
    }
    
}

enum LinkWizardError: Error {

    case emptyURL
    case notAValidURL
    case urlIsNotHttp
    
    case applePodcastsLink_idNotFound
    case applePodcastsLink_unableToGetIdFromUrl
    
    case castroLink_failedToTransformWebsiteLinkToString
    case castroLink_innerApplePodcastsLinkNotFound
    
    case overcastLink_failedToTransformWebsiteLinkToString
    case overcastLink_innerApplePodcastsLinkNotFound
    
    case pocketCastsLink_failedToTransformWebsiteLinkToString
    case pocketCastsLink_innerApplePodcastsLinkNotFound
    case pocketCastsLink_innerApplePodcastsLinkIsInvalid
    
    case spotifyLink

}
