import SwiftUI

struct EpisodeCell: View {

    @ObservedObject var viewModel: EpisodeCellViewModel

    var body: some View {
        HStack {            
            RoundCheckbox(selected: $viewModel.isSelected, showAsHollowButton: false)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.title)
                    .lineLimit(1)

                Text(viewModel.subtitle)
                    .foregroundColor(.gray)
                    .bold()
                    .font(.footnote)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .padding(.vertical, 10)
        .onTapGesture {
            viewModel.isSelected.toggle()
        }
    }

}

struct EpisodeCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            EpisodeCell(viewModel: EpisodeCellViewModel(episode: Episodio(id: "1", idPodcast: 123, titulo: "Flat-Side Promoter", dataPublicacao: Date(), duracao: 300, urlRemoto: "", tamanho: 0)))
            EpisodeCell(viewModel: EpisodeCellViewModel(episode: Episodio(id: "2", idPodcast: 456, titulo: "With Four Hands Tied Behind Its Back", dataPublicacao: Date(), duracao: 3600, urlRemoto: "", tamanho: 13080400), selected: true))
        }
        .previewLayout(.fixed(width: 350, height: 100))
    }

}
