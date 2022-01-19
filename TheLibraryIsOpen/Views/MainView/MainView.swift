import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewViewModel()
    @State var showingNewPodcastSheet = false
    @State var showingSettingsScreen = false
    @State var podcastToAutoOpenAfterAdd: Int? = 0
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SettingsView(), isActive: $showingSettingsScreen) { EmptyView() }
                
                if viewModel.displayPodcastList {
                    List(viewModel.podcasts) { podcast in
                        NavigationLink(destination: ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: podcast)), tag: podcast.id, selection: $podcastToAutoOpenAfterAdd, label: {
                            PodcastRow(viewModel: PodcastRowViewModel(podcast: podcast))
                        })
                    }
                } else {
                    Image("PodcastsEmptyState")
                        .resizable()
                        .frame(width: 350, height: 200)
                    
                    Text(LocalizableStrings.MainView.emptyStateTitle)
                        .font(.title2)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text(LocalizableStrings.MainView.emptyStateDescription)
                        .font(.body)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle(Text(LocalizableStrings.MainView.title))
            .navigationBarItems(leading:
                Button(action: {
                    showingSettingsScreen = true
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.gray)
                }
            )
            .navigationBarItems(trailing:
                Button(action: {
                    showingNewPodcastSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text(LocalizableStrings.MainView.addPodcastButtonLabel)
                    }
                }
            )
            .sheet(isPresented: $showingNewPodcastSheet) {
                /*InstructionsAView(isShowingModal: $showingNewPodcastSheet, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    .interactiveDismissDisabled(true)*/
                PlayerPickerView(isShowingModal: $showingNewPodcastSheet, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    .interactiveDismissDisabled(true)
            }
            .onChange(of: showingNewPodcastSheet) {
                if $0 == false {
                    viewModel.updateList()
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
                 showingNewPodcastSheet: false)
    }

}
