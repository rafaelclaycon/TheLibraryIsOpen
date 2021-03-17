//
//  EpisodeRow.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import SwiftUI

struct EpisodeRow: View {
    @ObservedObject var viewModel: EpisodeRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.pubDate)
                    .foregroundColor(.gray)
                    .bold()
                    .font(.footnote)

                Text(viewModel.title)
                    .padding(.top, 0.1)

                Text(viewModel.duration)
                    .foregroundColor(.gray)
                    .bold()
                    .font(.footnote)
                    .padding(.top, 0.1)
            }
            .padding(.leading)

            Spacer()
        }
    }
}

struct EpisodeRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episodio(id: "1", idPodcast: 123, titulo: "Flat-Side Promoter", dataPublicacao: Date(), duracao: 300, urlRemoto: "")))
            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episodio(id: "2", idPodcast: 456, titulo: "With Four Hands Tied Behind Its Back", dataPublicacao: Date(), duracao: 3600, urlRemoto: "")))
        }
        .previewLayout(.fixed(width: 350, height: 70))
    }
}
