import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewViewModel()
    @State var showingNewPodcastSheet = false
    @State var podcastToAutoOpenAfterAdd: Int = 0
    @State private var action: Int? = 0
    
    var body: some View {
        let navBarItemSize: CGFloat = 36
        
        NavigationView {
            VStack {
                if viewModel.displayPodcastList {
                    List(viewModel.podcasts) { podcast in
                        NavigationLink(destination: ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: podcast)), tag: podcast.id, selection: $action, label: {
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
                    
                    Text("To archive a new podcast, tap the + button at the top of the screen.")
                        .font(.body)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
            }
            .navigationBarTitle(Text("Archive"))
            .navigationBarItems(trailing:
                HStack(spacing: 30) {
//                    Button(action: {
//                        viewModel.updateList()
//                    }) {
//                        Image(systemName: "arrow.triangle.2.circlepath")
//                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
//                            .frame(width: 30, height: 25, alignment: .center)
//                            .foregroundColor(Color.primary)
//                    }
//                    .frame(width: navBarItemSize, height: navBarItemSize, alignment: .center)
                
                    Button(action: {
                        showingNewPodcastSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    .frame(width: navBarItemSize, height: navBarItemSize, alignment: .center)
                }
                .padding(.trailing, 10)
            )
            .sheet(isPresented: $showingNewPodcastSheet) {
                InstructionsAView(isShowingModal: $showingNewPodcastSheet, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd)
                    .interactiveDismissDisabled(true)
            }
            .onChange(of: showingNewPodcastSheet) {
                if $0 == false {
                    viewModel.updateList()
                    
                    if podcastToAutoOpenAfterAdd > 0 {
                        print("HERMIONE - PodcastId: \(podcastToAutoOpenAfterAdd)")
                        action = podcastToAutoOpenAfterAdd
                    }
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
