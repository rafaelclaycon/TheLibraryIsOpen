import Combine

class PodcastHistoryViewViewModel: ObservableObject {

    @Published var records: [PodcastHistoryRecord]?
    @Published var showList: Bool
    
    init(podcastId: Int) {
        do {
            records = try dataManager.getPodcastHistory(from: podcastId)
            showList = true
        } catch {
            records = nil
            showList = false
            print(error.localizedDescription)
        }
    }

}
