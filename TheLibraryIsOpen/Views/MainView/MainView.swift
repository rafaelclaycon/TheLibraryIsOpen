import SwiftUI

struct MainView: View {
    
    enum MainViewSubviewToOpen {
        case addPodcast, guide
    }

    @StateObject var viewModel = MainViewViewModel()
    @State var showingModalView = false
    @State var showingSettingsScreen = false
    @State var podcastToAutoOpenAfterAdd: Int? = 0
    @State private var sort: Int = 0
    @State private var subviewToOpen: MainViewSubviewToOpen = .addPodcast
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsView(), isActive: $showingSettingsScreen) { EmptyView() }
                
                if viewModel.displayPodcastList {
                    List(viewModel.podcasts) { podcast in
                        NavigationLink(destination: ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: podcast)),
                                       tag: podcast.id,
                                       selection: $podcastToAutoOpenAfterAdd,
                                       label: {
                                           PodcastRow(viewModel: PodcastRowViewModel(podcast: podcast))
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
                            .bold()
                    }
                    .tint(.accentColor)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
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
                    Menu {
                        Picker(selection: $sort, label: Text("Sorting options")) {
                            Text("Sort by Title").tag(0)
                            Text("Sort by Total Size").tag(1)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.primary)
                    }
                    .disabled(viewModel.displayPodcastList == false)
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
                        PasteLinkView(estaSendoExibido: $showingModalView, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    } else {
                        PlayerPickerView(isShowingModal: $showingModalView, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    }
                case .guide:
                    GuideView(isShowingModal: $showingModalView)
                }
            }
            .onChange(of: showingModalView) {
                if subviewToOpen == .addPodcast, $0 == false {
                    viewModel.updateList()
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
        }
    }

}

struct MainView_Previews: PreviewProvider {

    static var previews: some View {
        MainView(viewModel: MainViewViewModel(podcasts: [Podcast(id: 1,
                                                                 title: "Um Milkshake Chamado Wanda",
                                                                 author: "Papel Pop",
                                                                 episodes: nil,
                                                                 feedUrl: "",
                                                                 artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")]),
                 showingModalView: false)
    }

}
