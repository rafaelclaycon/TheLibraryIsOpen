import SwiftUI

struct PodcastHistoryView: View {
    
    @StateObject var viewModel: PodcastHistoryViewViewModel

    var body: some View {
        NavigationView {
            if viewModel.showList {
                List(viewModel.records!) { record in
                    PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: record))
                }
            }
        }
        .navigationTitle("Histórico")
    }

}

struct PodcastHistoryView_Previews: PreviewProvider {

    static var previews: some View {
        PodcastHistoryView(viewModel: PodcastHistoryViewViewModel(podcastId: 1))
    }

}
