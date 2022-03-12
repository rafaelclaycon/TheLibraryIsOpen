import Foundation

class LinkWizard {
    
    static private let castroStartingString = "Or Listen Elsewhere"
    static private let castroEndingString = "\"><img alt=\"Listen On Apple Podcasts"
    
    static private let overcastStartingString = "/img/badge-overcast-or-wherever.svg"
    static private let overcastEndingString = "><img src=\"/img/badge-apple.svg"
    
    static private let pocketCastsStartingString = "<div class=\"button itunes_button\"><a href=\""
    static private let pocketCastsEndingString = "\" target=\"_blank\">Apple Podcasts</a></div>"

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
    
    static func getIdFrom(url: String, completionHandler: @escaping (Int?, LinkWizardError?) -> Void) {
        guard !url.isEmpty else {
            return completionHandler(nil, LinkWizardError.emptyURL)
        }
        guard isSpotifyLink(url) == false else {
            return completionHandler(nil, LinkWizardError.spotifyLink)
        }
        guard isApplePodcastsLink(url) || isCastroLink(url) || isOvercastLink(url) || isPocketCastsLink(url) else {
            return completionHandler(nil, LinkWizardError.notAValidURL)
        }
        
        if isCastroLink(url) {
            guard let castroURL = URL(string: url) else {
                return completionHandler(nil, LinkWizardError.notAValidURL)
            }
            
            getApplePodcastsLinkFrom(url: castroURL, between: castroStartingString, and: castroEndingString) { result, error in
                guard error == nil else {
                    return completionHandler(nil, error)
                }
                guard let result = result else {
                    return
                }
                guard isApplePodcastsLink(result) else {
                    return completionHandler(nil, LinkWizardError.castroLink_innerApplePodcastsLinkIsInvalid)
                }
                do {
                    let result = try getIdFromApplePodcasts(url: result)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, error as? LinkWizardError)
                }
            }
        } else if isOvercastLink(url) {
            guard let overcastURL = URL(string: url) else {
                return completionHandler(nil, LinkWizardError.notAValidURL)
            }
            
            getApplePodcastsLinkFrom(url: overcastURL, between: overcastStartingString, and: overcastEndingString) { result, error in
                guard error == nil else {
                    return completionHandler(nil, error)
                }
                guard let result = result else {
                    return
                }
                guard isApplePodcastsLink(result) else {
                    return completionHandler(nil, LinkWizardError.overcastLink_innerApplePodcastsLinkIsInvalid)
                }
                do {
                    let result = try getIdFromApplePodcasts(url: result)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, error as? LinkWizardError)
                }
            }
        } else if isPocketCastsLink(url) {
            guard let pocketCastsURL = URL(string: url) else {
                return completionHandler(nil, LinkWizardError.notAValidURL)
            }
            
            getApplePodcastsLinkFrom(url: pocketCastsURL, between: pocketCastsStartingString, and: pocketCastsEndingString) { result, error in
                guard error == nil else {
                    return completionHandler(nil, error)
                }
                guard let result = result else {
                    return
                }
                guard isApplePodcastsLink(result) else {
                    return completionHandler(nil, LinkWizardError.pocketCastsLink_innerApplePodcastsLinkIsInvalid)
                }
                do {
                    let result = try getIdFromApplePodcasts(url: result)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, error as? LinkWizardError)
                }
            }
        } else {
            // Apple Podcasts part
            do {
                let result = try getIdFromApplePodcasts(url: url)
                completionHandler(result, nil)
            } catch {
                completionHandler(nil, error as? LinkWizardError)
            }
        }
    }
    
    static private func getIdFromApplePodcasts(url: String) throws -> Int {
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
    
    static func getApplePodcastsLinkFrom(url: URL, between startingString: String, and endingString: String, completionHandler: @escaping (String?, LinkWizardError?) -> Void) {
        var htmlString = String.empty
        do {
            htmlString = try String(contentsOf: url, encoding: .ascii)
        } catch {
            completionHandler(nil, LinkWizardError.pocketCastsLink_failedToTransformWebsiteLinkToString)
        }
        guard let preStart = htmlString.index(of: startingString), let end = htmlString.index(of: endingString) else {
            return completionHandler(nil, LinkWizardError.pocketCastsLink_innerApplePodcastsLinkNotFound)
        }
        let start = htmlString.index(preStart, offsetBy: 43)
        let range = start..<end
        
        completionHandler(String(htmlString[range]), nil)
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
    case castroLink_innerApplePodcastsLinkIsInvalid
    
    case overcastLink_failedToTransformWebsiteLinkToString
    case overcastLink_innerApplePodcastsLinkNotFound
    case overcastLink_innerApplePodcastsLinkIsInvalid
    
    case pocketCastsLink_failedToTransformWebsiteLinkToString
    case pocketCastsLink_innerApplePodcastsLinkNotFound
    case pocketCastsLink_innerApplePodcastsLinkIsInvalid
    
    case spotifyLink

}
