import Foundation

class LinkAssistant {
    
    private static func isSpotifyLink(_ link: String) -> Bool {
        return link.contains("spotify.com")
    }
    
    private static func isApplePodcastsLink(_ link: String) -> Bool {
        return link.contains("podcasts.apple.com")
    }
    
    private static func isPocketCastsLink(_ link: String) -> Bool {
        return link.contains("pca.st")
    }
    
    static func getIdFrom(url: String) throws -> Int {
        guard !url.isEmpty else {
            throw LinkAssistantError.emptyURL
        }
        guard isSpotifyLink(url) == false else {
            throw LinkAssistantError.spotifyLink
        }
        guard isApplePodcastsLink(url) || isPocketCastsLink(url) else {
            throw LinkAssistantError.notAValidURL
        }
        
//        if isPocketCastsLink(url) {
//            guard let myURL = URL(string: url) else {
//                throw LinkAssistantError.notAValidURL
//            }
//
//            do {
//                let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//                print("HTML : \(myHTMLString)")
//                // regex
//                let range = NSRange(location: 0, length: myHTMLString.utf16.count)
//                let regex = try! NSRegularExpression(pattern: "rss_button\"><a href=\"[A-Za-z0-9]\" target=")
//                print(regex.firstMatch(in: myHTMLString, options: [], range: range))
//            } catch let error {
//                print("Error: \(error)")
//            }
//        }
        
        guard let index = url.index(of: "/id") else {
            throw LinkAssistantError.idNotFound
        }
        let start = url.index(index, offsetBy: 3) // Offset by 3 to jump to "/id"
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        guard let id = Int(url[range]) else {
            throw LinkAssistantError.unableToGetIdFromUrl
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
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        return "https:" + url[range]
    }
    
}

enum LinkAssistantError: Error {

    case emptyURL
    case spotifyLink
    case notAValidURL
    case idNotFound
    case unableToGetIdFromUrl
    case urlIsNotHttp

}
