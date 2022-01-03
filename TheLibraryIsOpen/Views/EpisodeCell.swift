import SwiftUI

struct EpisodeCell: View {

    @ObservedObject var viewModel: EpisodeCellViewModel

    var body: some View {
        HStack {            
            RoundCheckbox(selected: $viewModel.isSelected, showAsHollowButton: false)
                .padding(.leading)
            
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
            .padding(.leading, 8)

            Spacer()
        }
        .onTapGesture {
            viewModel.isSelected.toggle()
        }
    }

}

struct EpisodeCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            EpisodeCell(viewModel: EpisodeCellViewModel(episode: Episodio(id: "1", idPodcast: 123, titulo: "Flat-Side Promoter", dataPublicacao: Date(), duracao: 300, urlRemoto: "", tamanho: 0)))
            EpisodeCell(viewModel: EpisodeCellViewModel(episode: Episodio(id: "2", idPodcast: 456, titulo: "With Four Hands Tied Behind Its Back", dataPublicacao: Date(), duracao: 3600, urlRemoto: "", tamanho: 0), selected: true))
        }
        .previewLayout(.fixed(width: 350, height: 100))
    }

}
