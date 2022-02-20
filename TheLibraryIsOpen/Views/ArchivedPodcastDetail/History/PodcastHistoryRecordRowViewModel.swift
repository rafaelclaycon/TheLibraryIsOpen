import Combine
import SwiftUI

class PodcastHistoryRecordRowViewModel: ObservableObject {

    @Published var sfSymbolName: String
    @Published var symbolHeight: CGFloat
    @Published var symbolColor: Color
    @Published var title: String
    @Published var description: String
    @Published var dateTime: String
    
    init(record: PodcastHistoryRecord) {
        switch HistoryRecordType(rawValue: record.type) {
        
        case .podcastArchived:
            sfSymbolName = "sparkles"
            symbolHeight = 40
            symbolColor = .yellow
            title = LocalizableStrings.PodcastHistoryRecord.PodcastArchived.title
            let value1 = Int(record.value1) ?? 0
            if value1 == 1 {
                description = LocalizableStrings.PodcastHistoryRecord.PodcastArchived.singleEpisodeDescription
            } else {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.PodcastArchived.multipleEpisodesDescription, record.value1)
            }
            self.dateTime = record.dateTime.asShortDateAndShortTimeString()
        
        case .archiveExported:
            sfSymbolName = "folder.fill" // doc.zipper
            symbolHeight = 40
            symbolColor = .blue
            title = LocalizableStrings.PodcastHistoryRecord.ArchiveExported.title
            let value1 = Int(record.value1) ?? 0
            let value2 = Int(record.value2 ?? "0") ?? 0
            
            let exportedToOption = ExportedToOption(rawValue: value2)
            var exportedToText = ""
            
            switch exportedToOption {
            case .icloudFiles:
                exportedToText = LocalizableStrings.PodcastHistoryRecord.ArchiveExported.exportedToFiles
            case .thirdPartyService:
                exportedToText = LocalizableStrings.PodcastHistoryRecord.ArchiveExported.exportedToThirdPartyService
            default:
                exportedToText = LocalizableStrings.PodcastHistoryRecord.ArchiveExported.exportedToUnknown
            }
            
            if value1 == 1 {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.ArchiveExported.singleEpisodeDescription, exportedToText)
            } else {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.ArchiveExported.multipleEpisodesDescription, arguments: ["\(value1)", exportedToText])
            }
            self.dateTime = record.dateTime.asShortDateAndShortTimeString()
            
        case .checkedForNewEpisodes:
            sfSymbolName = "arrow.clockwise"
            symbolHeight = 38
            symbolColor = .gray
            title = LocalizableStrings.PodcastHistoryRecord.CheckedForNewEpisodes.title
            let value1 = Int(record.value1) ?? 0
            if value1 == 0 {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.CheckedForNewEpisodes.noNewEpisodesDescription, record.value2 ?? "Unavailable")
            } else if value1 == 1 {
                description = LocalizableStrings.PodcastHistoryRecord.CheckedForNewEpisodes.singleNewEpisodeDescription
            } else {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.CheckedForNewEpisodes.multipleNewEpisodesDescription, record.value1)
            }
            self.dateTime = record.dateTime.asShortDateAndShortTimeString()
            
        case .newEpisodesDownloaded:
            sfSymbolName = "arrow.down.circle.fill"
            symbolHeight = 38
            symbolColor = .green
            title = LocalizableStrings.PodcastHistoryRecord.NewEpisodesDownloaded.title
            let value1 = Int(record.value1) ?? 0
            if value1 == 1 {
                description = LocalizableStrings.PodcastHistoryRecord.NewEpisodesDownloaded.singleAddedEpisodeDescription
            } else {
                description = String(format: LocalizableStrings.PodcastHistoryRecord.NewEpisodesDownloaded.multipleAddedEpisodesDescription, record.value1)
            }
            self.dateTime = record.dateTime.asShortDateAndShortTimeString()
            
        default:
            sfSymbolName = "exclamationmark.triangle.fill"
            symbolHeight = 38
            symbolColor = .orange
            title = LocalizableStrings.PodcastHistoryRecord.None.title
            description = LocalizableStrings.PodcastHistoryRecord.None.description
            dateTime = ""
        }
    }

}
