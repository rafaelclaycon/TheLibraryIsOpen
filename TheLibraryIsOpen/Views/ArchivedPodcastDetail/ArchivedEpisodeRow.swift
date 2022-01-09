import SwiftUI

struct ArchivedEpisodeRow: View {
    
    @StateObject var viewModel: ArchivedEpisodeRowViewModel
    @State var showLoadingIndicator: Bool = true
    //@Binding var offlineStatus: EpisodeOfflineStatus
    
    @Binding var downloadingItems: Set<String>
    @Binding var downloadedItems: Set<String>
    @Binding var downloadErrorItems: Set<String>
    var offlineStatus: EpisodeOfflineStatus {
        if downloadingItems.contains(viewModel.episodeID) {
            return .downloading
        } else if downloadedItems.contains(viewModel.episodeID) {
            return .availableOffline
        } else if downloadErrorItems.contains(viewModel.episodeID) {
            return .downloadError
        }
        return .downloadNotStarted
    }
    
    let circleSize: CGFloat

    var body: some View {
        HStack {
            if offlineStatus == .downloadNotStarted {
                FileWaitingForDownloadSymbol()
                    .padding(.leading, 18)
            } else if offlineStatus == .downloading {
                GrowingArcIndicatorView(color: .pink, lineWidth: 2)
                    .frame(width: circleSize, height: circleSize)
                    .padding(.leading, 18)
            } else if offlineStatus == .availableOffline {
                FileAvailableOfflineSymbol()
                    .padding(.leading, 18)
            } else if offlineStatus == .downloadError {
                FileDownloadErrorSymbol()
                    .padding(.leading, 18)
            }
            
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.title)
                    .lineLimit(1)

                Text(viewModel.subtitle)
                    .foregroundColor(.gray)
                    .bold()
                    .font(.footnote)
                
                if offlineStatus == .downloading {
                    Text("Downloading episode...")
                        .foregroundColor(.gray)
                        .font(.footnote)
                } else if offlineStatus == .availableOffline {
                    Text("Available offline")
                        .foregroundColor(.pink)
                        .font(.footnote)
                }
            }
            .padding(.leading, 10)

            Spacer()
        }
    }

}

struct ArchivedEpisodeRow_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant(Set<String>()),
                               downloadedItems: .constant(Set<String>()),
                               downloadErrorItems: .constant(Set<String>()),
                               circleSize: 30.0)
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant(Set<String>()),
                               downloadedItems: .constant(Set<String>()),
                               downloadErrorItems: .constant(Set<String>()),
                               circleSize: 30.0)
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant(Set<String>()),
                               downloadedItems: .constant(Set<String>()),
                               downloadErrorItems: .constant(Set<String>()),
                               circleSize: 30.0)
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant(Set<String>()),
                               downloadedItems: .constant(Set<String>()),
                               downloadErrorItems: .constant(Set<String>()),
                               circleSize: 30.0)
        }
        .previewLayout(.fixed(width: 375, height: 100))
    }

}
