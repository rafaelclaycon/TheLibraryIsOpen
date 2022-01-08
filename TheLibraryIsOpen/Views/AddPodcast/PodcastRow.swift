import SwiftUI
import KingfisherSwiftUI

struct PodcastRow: View {

    var podcast: Podcast

    var body: some View {
        HStack {
            KFImage(URL(string: podcast.urlCapa))
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

            VStack(alignment: .leading) {
                Text(podcast.titulo)
                    .font(.body)
                    .bold()
                    .padding(.leading, 15)
                    .padding(.bottom, 2)
                Text(podcast.autor)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .font(.footnote)
            }

            Spacer()
        }
    }

}

struct PodcastCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            PodcastRow(podcast: Podcast(id: 1, titulo: "Praia dos Ossos", autor: "Rádio Novelo", episodios: nil, urlFeed: "", urlCapa: ""))
            PodcastRow(podcast: Podcast(id: 2, titulo: "Accidental Tech Podcast", autor: "Marco Arment, Casey Liss, John Siracusa", episodios: nil, urlFeed: "", urlCapa: ""))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }

}
