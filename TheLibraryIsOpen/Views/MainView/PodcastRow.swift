import SwiftUI
import Kingfisher

struct PodcastRow: View {

    @StateObject var viewModel = PodcastRowViewModel()
    @Binding var subtitleInfoOption: Int
    private let artworkSize: CGFloat = 90
    private let placeholderSize: CGFloat = 50

    var body: some View {
        HStack {
            KFImage(URL(string: viewModel.artworkUrl))
                .placeholder {
                    Image(systemName: "headphones")
                        .resizable()
                        .frame(width: placeholderSize, height: placeholderSize)
                        .foregroundColor(.gray)
                }
                .resizable()
                .frame(maxWidth: artworkSize, maxHeight: artworkSize)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.podcastTitle)
                    .font(.body)
                    .bold()
                
                Text(viewModel.episodeCountText + "  ·  " + viewModel.totalSizeText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Tag(text: viewModel.wasExportedLine, color: viewModel.wasExported ? .green : .gray)
                    .padding(.top, 2)
            }
            .padding(.leading, 10)
        }
    }

}

struct PodcastCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 1, title: "Praia dos Ossos", author: "Rádio Novelo", episodes: nil, feedUrl: .empty, artworkUrl: .empty)), subtitleInfoOption: .constant(0))
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", episodes: nil, feedUrl: .empty, artworkUrl: .empty)), subtitleInfoOption: .constant(1))
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", exportedIn: Date().addingTimeInterval(-1 * 24 * 60 * 60))), subtitleInfoOption: .constant(1))
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", exportedIn: Date().addingTimeInterval(-4 * 24 * 60 * 60))), subtitleInfoOption: .constant(1))
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", exportedIn: Date().addingTimeInterval(-30 * 24 * 60 * 60))), subtitleInfoOption: .constant(1))
        }
        .previewLayout(.fixed(width: 380, height: 100))
    }

}
