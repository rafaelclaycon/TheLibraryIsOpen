import SwiftUI

struct MainView: View {
    
    enum MainViewSubviewToOpen {
        case addPodcast, guide
    }

    @StateObject var viewModel = MainViewViewModel()
    @State var showingModalView = false
    @State var showingSettingsScreen = false
    @State var podcastToAutoOpenAfterAdd: Int? = 0
    @State private var subviewToOpen: MainViewSubviewToOpen = .addPodcast
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsView(), isActive: $showingSettingsScreen) { EmptyView() }
                
                if viewModel.displayPodcastList {
                    List(viewModel.podcasts) { podcast in
                        NavigationLink(destination: ArchivedPodcastDetailView(viewModel: ArchivedPodcastDetailViewViewModel(podcast: podcast)),
                                       tag: podcast.id,
                                       selection: $podcastToAutoOpenAfterAdd,
                                       label: {
                                           PodcastRow(viewModel: PodcastRowViewModel(podcast: podcast), subtitleInfoOption: $viewModel.viewOption)
                                       })
                            .swipeActions {
                                Button {
                                    viewModel.alertAuxiliaryInfo = podcast.id
                                    viewModel.showPodcastDeletionConfirmation()
                                } label: {
                                    VStack {
                                        Image(systemName: "trash")
                                        Text(LocalizableStrings.MainView.PodcastRow.deletePodcastSwipeActionLabel)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                    
                    Text(viewModel.totalSize)
                        .padding(.bottom, Utils.deviceHasTopNotch() ? 0 : 10)
                } else {
                    Image("PodcastsEmptyState")
                        .resizable()
                        .frame(width: 350, height: 200)
                    
                    Text(LocalizableStrings.MainView.EmptyStateView.title)
                        .font(.title2)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text(LocalizableStrings.MainView.EmptyStateView.description)
                        .font(.body)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    Button {
                        subviewToOpen = .guide
                        showingModalView = true
                    } label: {
                        Text(LocalizableStrings.MainView.EmptyStateView.howDoesThisWorkButtonLabel)
                    }
                    .tint(.accentColor)
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .padding()
                }
            }
            .navigationBarTitle(Text(LocalizableStrings.MainView.title))
            .navigationBarItems(leading:
                HStack {
                    Button(action: {
                        showingSettingsScreen = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                
                    if viewModel.displayPodcastList {
                        Menu {
                            Section {
                                Picker(selection: $viewModel.sortOption, label: Text("Sorting options")) {
                                    Text(LocalizableStrings.MainView.ListOptions.sortByTitle)
                                        .tag(0)
                                    
                                    Text(LocalizableStrings.MainView.ListOptions.sortByTotalSize)
                                        .tag(1)
                                }
                            }
                            
//                            Section {
//                                Picker(selection: $viewModel.viewOption, label: Text("View options")) {
//                                    Text(LocalizableStrings.MainView.ListOptions.showEpisodeCount)
//                                        .tag(0)
//                                    
//                                    Text(LocalizableStrings.MainView.ListOptions.showTotalSize)
//                                        .tag(1)
//                                }
//                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(.primary)
                        }
                    }
                }
            )
            .navigationBarItems(trailing:
                Button(action: {
                    subviewToOpen = .addPodcast
                    showingModalView = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text(LocalizableStrings.MainView.addPodcastButtonLabel)
                    }
                }
            )
            .sheet(isPresented: $showingModalView) {
                switch subviewToOpen {
                case .addPodcast:
                    if UserSettings.getSkipGetLinkInstructions() {
                        GetLinkView(isBeingShown: $showingModalView, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    } else {
                        PlayerPickerView(isShowingModal: $showingModalView, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    }
                case .guide:
                    GuideView(isShowingModal: $showingModalView)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                switch viewModel.alertType {
                case .singleOption:
                    return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(LocalizableStrings.ok)))
                default:
                    return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), primaryButton: Alert.Button.cancel(), secondaryButton: Alert.Button.destructive(Text(LocalizableStrings.MainView.PodcastRow.deletePodcastSwipeActionLabel), action: {
                        guard let podcastId = viewModel.alertAuxiliaryInfo else {
                            return
                        }
                        viewModel.removePodcast(withId: podcastId)
                    }))
                }
            }
            .onChange(of: showingModalView) {
                if subviewToOpen == .addPodcast, $0 == false {
                    viewModel.updateList()
                }
            }
            .onChange(of: viewModel.viewOption) { newValue in
                if newValue == 0 {
                    viewModel.sortPodcastsByTitleAscending()
                } else {
                    viewModel.sortPodcastsByTotalSizeDescending()
                }
                UserSettings.setArchiveSortOption(to: newValue)
            }
            .onChange(of: viewModel.viewOption) { newValue in
                UserSettings.setArchiveRowAdditionalInfoToShowOption(to: newValue)
            }
        }
    }

}

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView(viewModel: MainViewViewModel(podcasts: [Podcast(id: 1,
                                                                 title: "Um Milkshake Chamado Wanda",
                                                                 author: "Papel Pop",
                                                                 episodes: nil,
                                                                 feedUrl: .empty,
                                                                 artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")]),
                 showingModalView: false)
    }

}
