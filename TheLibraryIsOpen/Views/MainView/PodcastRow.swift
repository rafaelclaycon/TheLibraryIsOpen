import SwiftUI
import KingfisherSwiftUI

struct PodcastRow: View {

    @StateObject var viewModel = PodcastRowViewModel()

    var body: some View {
        HStack {
            KFImage(URL(string: viewModel.artworkUrl))
                .onSuccess { r in
                    print("success: \(r)")
                }
                .onFailure { e in
                    print("failure: \(e)")
                }
                .placeholder {
                    ZStack {
                        Rectangle() 
                            .fill(Color.gray)
                            .frame(width: 70, height: 70)
                            .opacity(0.6)

                        Image(systemName: "waveform")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                }
                .resizable()
                .frame(width: 70, height: 70)

            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.podcastTitle)
                    .font(.body)
                    .bold()
                    .padding(.leading, 15)
                
                Text(viewModel.subtitleLine)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                    
                Text(viewModel.wasExportedLine)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
            }

            Spacer()
        }
    }

}

struct PodcastCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 1, title: "Praia dos Ossos", author: "Rádio Novelo", episodes: nil, feedUrl: "", artworkUrl: "")))
            PodcastRow(viewModel: PodcastRowViewModel(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", episodes: nil, feedUrl: "", artworkUrl: "")))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }

}
