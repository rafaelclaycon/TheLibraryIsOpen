import SwiftUI
import KingfisherSwiftUI

struct PodcastRow: View {

    var podcast: Podcast

    var body: some View {
        HStack {
            KFImage(URL(string: podcast.artworkUrl))
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
                Text(podcast.title)
                    .font(.body)
                    .bold()
                    .padding(.leading, 15)
                
                Text("\(podcast.episodes?.count ?? 0) archived episodes")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                    
                Text("Not exported yet")
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
            PodcastRow(podcast: Podcast(id: 1, title: "Praia dos Ossos", author: "Rádio Novelo", episodes: nil, feedUrl: "", artworkUrl: ""))
            PodcastRow(podcast: Podcast(id: 2, title: "Accidental Tech Podcast", author: "Marco Arment, Casey Liss, John Siracusa", episodes: nil, feedUrl: "", artworkUrl: ""))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }

}
