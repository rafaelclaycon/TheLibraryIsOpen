import SwiftUI

struct PodcastHistoryRecordRow: View {
    
    @StateObject var viewModel: PodcastHistoryRecordRowViewModel

    var body: some View {
        HStack(alignment: .center) {
            if viewModel.sfSymbolName.isEmpty == false {
                Image(systemName: viewModel.sfSymbolName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: viewModel.symbolHeight)
                    .foregroundColor(viewModel.symbolColor)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.title)
                    .bold()
                
                Text(viewModel.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(viewModel.dateTime)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.gray)
        }
        .padding(.all, 5)
    }

}

struct PodcastHistoryRecordRow_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            // None
            //PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: 23, value1: .empty)))
            
            // Podcast Archived
            PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: HistoryRecordType.podcastArchived.rawValue, value1: "38")))
            
            // Archive Exported
            PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: HistoryRecordType.archiveExported.rawValue, value1: "5", value2: "Files")))
            
            // Checked For New Episodes
            //PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: HistoryRecordType.checkedForNewEpisodes.rawValue, value1: "0", value2: "https://feeds.soundcloud.com/users/soundcloud:users:110149054/sounds.rss")))
            //PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: HistoryRecordType.checkedForNewEpisodes.rawValue, value1: "5")))
            
            // New Episodes Downloaded
            //PodcastHistoryRecordRow(viewModel: PodcastHistoryRecordRowViewModel(record: PodcastHistoryRecord(type: HistoryRecordType.newEpisodesDownloaded.rawValue, value1: "5")))
        }
        .previewLayout(.fixed(width: 375, height: 90))
    }

}
