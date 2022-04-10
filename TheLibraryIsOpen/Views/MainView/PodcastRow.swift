import SwiftUI
import KingfisherSwiftUI

struct PodcastRow: View {

    @StateObject var viewModel = PodcastRowViewModel()
    @Binding var subtitleInfoOption: Int
    private let artworkSize: CGFloat = 75

    var body: some View {
        HStack {
            KFImage(URL(string: viewModel.artworkUrl))
                .placeholder {
                    Image(systemName: "headphones")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.gray)
                }
                .resizable()
                .frame(width: artworkSize, height: artworkSize)

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.podcastTitle)
                    .font(.body)
                    .bold()
                    .padding(.leading, 15)
                
                Text(subtitleInfoOption == 0 ? viewModel.episodeCountText : viewModel.totalSizeText)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                if viewModel.wasExported {
                    Tag(text: viewModel.wasExportedLine, color: .green)
                        .padding(.leading, 15)
                } else {
                    Tag(text: viewModel.wasExportedLine, color: .gray)
                        .padding(.leading, 15)
                }
            }

            Spacer()
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
