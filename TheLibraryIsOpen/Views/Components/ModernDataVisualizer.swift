import SwiftUI

struct ModernDataVisualizer: View {
    
    let title: String
    let imageName: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
                .bold()
            
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
        }
    }

}

struct ModernDataVisualizer_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ModernDataVisualizer(title: LocalizableStrings.episodes, imageName: "play.circle", value: "8")
                .previewLayout(.fixed(width: 200, height: 100))
            ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.Info.totalSize, imageName: "tray.full", value: "768,6 MB")
                .previewLayout(.fixed(width: 200, height: 100))
            ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.Info.lastChecked, imageName: "calendar", value: "22/01/2022")
                .previewLayout(.fixed(width: 200, height: 100))
        }
    }

}
