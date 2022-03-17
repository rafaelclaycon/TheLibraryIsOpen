import Foundation

enum LinkWizardVariables {

    struct StartingString {
        static let castro = "Or Listen Elsewhere"
        static let overcast = "/img/badge-overcast-or-wherever.svg"
        static let pocketCasts = "<div class=\"button itunes_button\"><a href=\""
    }
    
    struct EndingString {
        static let castro = "\"><img alt=\"Listen On Apple Podcasts"
        static let overcast = "><img src=\"/img/badge-apple.svg"
        static let pocketCasts = "\" target=\"_blank\">Apple Podcasts</a></div>"
    }
    
    struct StartOffset {
        static let castro = 77
        static let overcast = 83
        static let pocketCasts = 43
    }
    
    struct EndOffset {
        static let castro = 0
        static let overcast = -18
        static let pocketCasts = 0
    }

}

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
            
            getApplePodcastsLinkFrom(url: castroURL,
                                     between: LinkWizardVariables.StartingString.castro,
                                     and: LinkWizardVariables.EndingString.castro,
                                     startOffset: LinkWizardVariables.StartOffset.castro,
                                     endOffset: LinkWizardVariables.EndOffset.castro) { result, error in
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
            
            getApplePodcastsLinkFrom(url: overcastURL,
                                     between: LinkWizardVariables.StartingString.overcast,
                                     and: LinkWizardVariables.EndingString.overcast,
                                     startOffset: LinkWizardVariables.StartOffset.overcast,
                                     endOffset: LinkWizardVariables.EndOffset.overcast) { result, error in
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
            
            getApplePodcastsLinkFrom(url: pocketCastsURL,
                                     between: LinkWizardVariables.StartingString.pocketCasts,
                                     and: LinkWizardVariables.EndingString.pocketCasts,
                                     startOffset: LinkWizardVariables.StartOffset.pocketCasts,
                                     endOffset: LinkWizardVariables.EndOffset.pocketCasts) { result, error in
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
    
    static private func getApplePodcastsLinkFrom(url: URL,
                                                 between startingString: String,
                                                 and endingString: String,
                                                 startOffset: Int,
                                                 endOffset: Int,
                                                 completionHandler: @escaping (String?, LinkWizardError?) -> Void) {
        var htmlString = String.empty
        do {
            htmlString = try String(contentsOf: url, encoding: .ascii)
        } catch {
            completionHandler(nil, LinkWizardError.pocketCastsLink_failedToTransformWebsiteLinkToString)
        }
        guard let preStart = htmlString.index(of: startingString), let preEnd = htmlString.index(of: endingString) else {
            return completionHandler(nil, LinkWizardError.pocketCastsLink_innerApplePodcastsLinkNotFound)
        }
        let start = htmlString.index(preStart, offsetBy: startOffset)
        let end = htmlString.index(preEnd, offsetBy: endOffset)
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
