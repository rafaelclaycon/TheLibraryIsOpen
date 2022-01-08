import Combine

class MainViewViewModel: ObservableObject {

    @Published var exibindoSheetNovoPodcast = false
    @Published var podcasts = [Podcast]()
    @Published var displayPodcastList: Bool = false

}
