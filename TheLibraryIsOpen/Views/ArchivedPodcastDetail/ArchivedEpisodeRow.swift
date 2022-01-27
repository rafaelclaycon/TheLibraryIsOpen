import SwiftUI

struct ArchivedEpisodeRow: View {
    
    @StateObject var viewModel: ArchivedEpisodeRowViewModel
    @State var showLoadingIndicator: Bool = true
    //@Binding var offlineStatus: EpisodeOfflineStatus
    
    @Binding var downloadingItems: [String: Double]
    @Binding var downloadedItems: Set<String>
    @Binding var downloadErrorItems: Set<String>
    var offlineStatus: EpisodeOfflineStatus {
        if downloadingItems[viewModel.episodeID] != nil {
            return .downloading
        } else if downloadedItems.contains(viewModel.episodeID) {
            return .availableOffline
        } else if downloadErrorItems.contains(viewModel.episodeID) {
            return .downloadError
        }
        return .downloadNotStarted
    }

    var body: some View {
        HStack {
            if offlineStatus == .downloadNotStarted {
                FileWaitingForDownloadSymbol()
                    .padding(.leading, 18)
            } else if offlineStatus == .downloading {
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .padding(.leading, 20)
                    .padding(.trailing, 3)
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
                    Text(String(format: LocalizableStrings.ArchivedPodcastDetail.EpisodeRow.downloadingEpisode, downloadingItems[viewModel.episodeID] ?? 0))
                        .foregroundColor(.gray)
                        .font(.footnote)
                } else if offlineStatus == .availableOffline {
                    Text(LocalizableStrings.ArchivedPodcastDetail.EpisodeRow.availableOffline)
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
        let downloadedItems: Set = ["456"]
        
        Group {
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(id: "123",
                                                                                       title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant(["123":50.0]),
                               downloadedItems: .constant(Set<String>()),
                               downloadErrorItems: .constant(Set<String>()))
            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(id: "456",
                                                                                       title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
                                                                                       pubDate: Date(),
                                                                                       duration: 4260.0,
                                                                                       filesize: 68600000)),
                               downloadingItems: .constant([:]),
                               downloadedItems: .constant(downloadedItems),
                               downloadErrorItems: .constant(Set<String>()))
//            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
//                                                                                       pubDate: Date(),
//                                                                                       duration: 4260.0,
//                                                                                       filesize: 68600000)),
//                               downloadingItems: .constant([:]),
//                               downloadedItems: .constant(Set<String>()),
//                               downloadErrorItems: .constant(Set<String>()))
//            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: Episode(title: "Everything Apple is Expected to Announce in 2022 ft. Mark Gurman",
//                                                                                       pubDate: Date(),
//                                                                                       duration: 4260.0,
//                                                                                       filesize: 68600000)),
//                               downloadingItems: .constant([:]),
//                               downloadedItems: .constant(Set<String>()),
//                               downloadErrorItems: .constant(Set<String>()))
        }
        .previewLayout(.fixed(width: 375, height: 100))
    }

}
