import SwiftUI

struct PodcastHistoryRecordRow: View {
    
    var record: PodcastHistoryRecord

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: record.symbol == nil ? "questionmark.app.dashed" : record.symbol!)
                    .resizable()
                    .frame(width: 34, height: 40)
                    .foregroundColor(.yellow)
                    .padding()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(record.title)
                        .bold()
                    
                    if record.description != nil {
                        Text(record.description!)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text(record.dateTime.asShortString())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }

}

struct PodcastHistoryRecordRow_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PodcastHistoryRecordRow(record: PodcastHistoryRecord(symbol: HistoryRecordSymbol.podcastArchived.rawValue, title: "Podcast archived!", description: "38 episodes added."))
            PodcastHistoryRecordRow(record: PodcastHistoryRecord(symbol: HistoryRecordSymbol.exportedToFiles.rawValue, title: "5 episodes exported to Files"))
        }
        .previewLayout(.fixed(width: 375, height: 70))
    }

}
