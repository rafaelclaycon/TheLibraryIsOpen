import SwiftUI

struct PodcastHistoryRecordRow: View {
    
    var record: PodcastHistoryRecord

    var body: some View {
        VStack {
            HStack(spacing: 50) {
//                Image(systemName: record.symbol == nil ? "questionmark.app.dashed" : record.symbol!)
//                    .resizable()
//                    .frame(width: 34, height: 40)
//                    .foregroundColor(.yellow)
//                    .padding()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(record.title)
                        .bold()
                    
                    if record.description != nil {
                        Text(record.description!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(record.dateTime.asShortDateAndShortTimeString())
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.gray)
                    //.padding()
            }
        }
    }

}

struct PodcastHistoryRecordRow_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PodcastHistoryRecordRow(record: PodcastHistoryRecord(symbol: HistoryRecordSymbol.podcastArchived.rawValue, title: "Podcast archived!", description: "38 episodes added."))
            PodcastHistoryRecordRow(record: PodcastHistoryRecord(symbol: HistoryRecordSymbol.exportedToFiles.rawValue, title: "5 episodes exported", description: "Exported to Files"))
        }
        .previewLayout(.fixed(width: 375, height: 70))
    }

}
