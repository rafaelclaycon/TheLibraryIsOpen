import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewViewModel()
    @State var showingNewPodcastSheet = false
    @State var podcastToAutoOpenAfterAdd: Int? = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.displayPodcastList {
                    List(viewModel.podcasts) { podcast in
                        NavigationLink(destination: ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: podcast)), tag: podcast.id, selection: $podcastToAutoOpenAfterAdd, label: {
                            PodcastRow(podcast: podcast)
                        })
                    }
                } else {
                    Image("PodcastsEmptyState")
                        .resizable()
                        .frame(width: 350, height: 200)
                    
                    Text("No Archived Podcasts")
                        .font(.title2)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text("To archive a new podcast, tap the Add Podcast button at the top of the screen.")
                        .font(.body)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle(Text("My Archive"))
            .navigationBarItems(trailing:
                Button(action: {
                    showingNewPodcastSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Podcast")
                    }
                }
            )
            .sheet(isPresented: $showingNewPodcastSheet) {
                InstructionsAView(isShowingModal: $showingNewPodcastSheet, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
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
