import Kingfisher
import SwiftUI

struct PodcastPreview: View {

    @StateObject var viewModel: PodcastPreviewViewModel
    @State private var selectedList = PodcastPreviewListType.episodeList.rawValue
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
            // Header
            if selectedList == PodcastPreviewListType.episodeList.rawValue {
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
            } else {
                Text(viewModel.title)
                    .font(.title3)
                    .bold()
            }
            
            if viewModel.yearGroups.count > 0 {
                Picker(selection: $selectedList, label: Text("Grouped by")) {
                    Text(LocalizableStrings.PodcastPreview.episodeList).tag(0)
                    Text(LocalizableStrings.PodcastPreview.groupedByYear).tag(1)
                }
                .disabled(viewModel.showLists == false)
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 25)
                .padding(.top, 7)
                .onChange(of: selectedList) { newValue in
                    if newValue == PodcastPreviewListType.episodeList.rawValue {
                        viewModel.updateDownloadAreaBasedOn(selectedIDs: Array(viewModel.episodeList_selectionKeeper), listType: .episodeList)
                    } else {
                        viewModel.updateDownloadAreaBasedOn(selectedIDs: Array(viewModel.yearGroupList_selectionKeeper), listType: .yearGroupList)
                    }
                }
            }
            
            if viewModel.showLists {
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
                            Image(systemName: viewModel.episodeList_allEpisodesSelected ? "circle.dotted" : "checkmark.circle")
                            Text(viewModel.episodeList_allEpisodesSelected ? unselectAllText : selectAllText)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
            Divider()

            // List
            if viewModel.showLists {
                if selectedList == PodcastPreviewListType.episodeList.rawValue {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode), selectedItems: $viewModel.episodeList_selectionKeeper)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    .onChange(of: viewModel.episodeList_selectionKeeper) { value in
                        viewModel.updateDownloadAreaBasedOn(selectedIDs: Array(viewModel.episodeList_selectionKeeper), listType: .episodeList)
                    }
                } else if selectedList == PodcastPreviewListType.yearGroupList.rawValue {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(viewModel.yearGroups, id: \.id) { group in
                                EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: group), selectedItems: $viewModel.yearGroupList_selectionKeeper)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    .onChange(of: viewModel.yearGroupList_selectionKeeper) { value in
                        viewModel.updateDownloadAreaBasedOn(selectedIDs: Array(viewModel.yearGroupList_selectionKeeper), listType: .yearGroupList)
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
            
            // MARK: - Download Area (Button + Text)
            
            Button(action: {
                viewModel.checkIfMeetsAllRequirementsToContinue(selectedList: selectedList)
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
                        if viewModel.persistPodcastLocally() {
                            podcastToAutoOpenAfterAdd = viewModel.podcast.id
                            isShowingAddPodcastModal = false
                        }
                    }))
                }
            }
            .padding(.vertical, 5)
            .disabled(!viewModel.downloadButtonIsActive)
            
            Text(viewModel.remainingStorageLabel)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
                .padding(.bottom)
        }
        .navigationBarTitle(String.empty, displayMode: .inline)
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
        PodcastPreview(viewModel: PodcastPreviewViewModel(podcast: Podcast(id: 1, title: "Um Milkshake Chamado Wanda", author: "PAPELPOP", episodes: [Episode(id: UUID().uuidString, podcastId: 1, title: "Teste", pubDate: Date(), duration: 2.0, remoteUrl: .empty, filesize: 13000)], feedUrl: .empty, artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")), isShowingAddPodcastModal: .constant(true), podcastToAutoOpenAfterAdd: .constant(0))
    }

}
