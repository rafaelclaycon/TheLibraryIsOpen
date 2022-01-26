import KingfisherSwiftUI
import SwiftUI

struct PodcastPreview: View {

    @StateObject var viewModel: PodcastPreviewViewModel
    @State private var indicePagina = 0
    @Binding var isShowingAddPodcastModal: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    
    // Private properties
    private let artworkSize: CGFloat = 64.0
    private let selectAllText = LocalizableStrings.PodcastPreview.selectAll
    private let unselectAllText = LocalizableStrings.PodcastPreview.unselectAll
    private let recentsFirstText = LocalizableStrings.mostRecentFirst
    private let oldestFirstText = LocalizableStrings.oldestFirst
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack(spacing: 15) {                
                KFImage(URL(string: viewModel.artworkURL))
                    .placeholder {
                        Image(systemName: "headphones")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }
                    .resizable()
                    .frame(width: artworkSize, height: artworkSize)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.title)
                        .font(.title3)
                        .bold()
                    Text(viewModel.details)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
            }
            .padding(.top, 5)
            .padding(.leading, 5)
            .padding(.trailing, 15)
            
            Picker(selection: $indicePagina, label: Text("Grouped by")) {
                Text(LocalizableStrings.PodcastPreview.episodeList).tag(0)
                Text(LocalizableStrings.PodcastPreview.groupedByYear).tag(1)
            }
            .disabled(viewModel.displayEpisodeList == false)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
            .padding(.top, 7)
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.toggleEpisodeListSorting()
                }) {
                    HStack {
                        Image(systemName: viewModel.episodeListSorting == .fromNewToOld ? "chevron.down.circle" : "chevron.up.circle")
                        Text(viewModel.episodeListSorting == .fromNewToOld ? recentsFirstText : oldestFirstText)
                    }
                }
                .onChange(of: viewModel.episodeListSorting) { newValue in
                    if newValue == .fromNewToOld {
                        viewModel.sortEpisodesByPubDateDescending()
                    } else {
                        viewModel.sortEpisodesByPubDateAscending()
                    }
                }
                
                Button(action: {
                    viewModel.toggleSelectAll()
                }) {
                    HStack {
                        Image(systemName: viewModel.allEpisodesSelected ? "circle.dotted" : "checkmark.circle")
                        Text(viewModel.allEpisodesSelected ? unselectAllText : selectAllText)
                    }
                }
            }
            .padding(.vertical, 10)
            
            Divider()

            // List
            if viewModel.displayEpisodeList {
                if indicePagina == 0 {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode), selectedItems: $viewModel.selectionKeeper)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    .onChange(of: viewModel.selectionKeeper) { value in
                        viewModel.updateDownloadButton(selectedIDs: Array(viewModel.selectionKeeper))
                        // TODO: Update remaining storage label.
                    }
                } else if indicePagina == 1 {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(viewModel.groups, id: \.id) { group in
                                EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(year: group.title, episodeCount: group.value))
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("No Episodes")
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            Divider()
                .padding(.bottom, 5)
            
            Button(action: {
                var episodesToDownload: [Episode]
                if viewModel.selectionKeeper.isEmpty {
                    episodesToDownload = viewModel.episodes
                } else {
                    episodesToDownload = viewModel.episodes.filter {
                        viewModel.selectionKeeper.contains($0.id)
                    }
                }
                
                let remainingSpace = InternalStorage.getDeviceFreeStorage() - Utils.getSizeInBytesOf(episodesToDownload)
                
                guard remainingSpace > 2000000000 else {
                    return viewModel.showLowStorageWarning()
                }
                
                viewModel.showPodcastAddingConfirmation(numberOfEpisodes: viewModel.selectionKeeper.count,
                                                        podcastName: viewModel.podcast.title)
                
                if viewModel.download(episodeIDs: viewModel.selectionKeeper) {
                    viewModel.alertType = .twoOptions
                    viewModel.displayAlert = true
                }
            }) {
                Text(viewModel.downloadAllButtonTitle)
                    .bold()
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(30)
            .alert(isPresented: $viewModel.displayAlert) {
                switch viewModel.alertType {
                case .singleOption:
                    return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(LocalizableStrings.ok)))
                default:
                    return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.default(Text(LocalizableStrings.PodcastPreview.Messages.continueButtonLabel), action: {
                        podcastToAutoOpenAfterAdd = viewModel.podcast.id
                        isShowingAddPodcastModal = false
                    }))
                }
            }
            .padding(.vertical, 5)
            
            Text("48 GB restantes no iPhone.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.isShowingAddPodcastModal = false
            }) {
                Text(LocalizableStrings.cancel)
            }
        )
    }

}

struct PodcastPreview_Previews: PreviewProvider {

    static var previews: some View {
        PodcastPreview(viewModel: PodcastPreviewViewModel(podcast: Podcast(id: 1, title: "Um Milkshake Chamado Wanda", author: "PAPELPOP", episodes: [Episode(id: UUID().uuidString, podcastId: 1, title: "Teste", pubDate: Date(), duration: 2.0, remoteUrl: "", filesize: 13000)], feedUrl: "", artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")), isShowingAddPodcastModal: .constant(true), podcastToAutoOpenAfterAdd: .constant(0))
    }

}
