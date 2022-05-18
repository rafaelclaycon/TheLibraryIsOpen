import SwiftUI

struct MainView: View {
    
    enum MainViewSubviewToOpen {
        case addPodcast, guide
    }

    @ObservedObject var viewModel = MainViewViewModel()
    @State var showingModalView = false
    @State var showingPrivateFolderScreen = false
    @State var showingSettingsScreen = false
    @State var podcastToAutoOpenAfterAdd: Int? = 0
    @State private var subviewToOpen: MainViewSubviewToOpen = .addPodcast
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsView(), isActive: $showingSettingsScreen) { EmptyView() }
                NavigationLink(destination: PrivateFolderView(), isActive: $showingPrivateFolderScreen) { EmptyView() }
                
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
                                    viewModel.showPodcastDeletionConfirmation(podcastTitle: podcast.title)
                                } label: {
                                    VStack {
                                        Image(systemName: "trash")
                                        Text(LocalizableStrings.MainView.PodcastRow.deletePodcastSwipeActionLabel)
                                    }
                                }
                                .tint(.red)
                            }
                    }
                    
                    Button {
//                        viewModel.alertType = .twoOptions
//                        viewModel.alertTitle = "Welcome to Private Folder"
//                        viewModel.alertMessage = "This is a place to keep feeds you might not want anyone with access to your unlocked phone to see."
//                        viewModel.showAlert = true
                        
                        viewModel.authSidekick.authenticated(reasonToAuthenticate: "Access secured podcasts in your Private Folder.") { result in
                            if result {
                                showingPrivateFolderScreen = true
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Private Folder (Empty)")
                        }
                    }
                    .tint(.accentColor)
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle)
                    .padding(.vertical, 5)
                    
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
                        GetLinkFromPasteboardView(isBeingShown: $showingModalView, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
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
