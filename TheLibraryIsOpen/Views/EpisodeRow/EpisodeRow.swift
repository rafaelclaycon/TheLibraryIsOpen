import SwiftUI

struct EpisodeRow: View {

    @StateObject var viewModel: EpisodeRowViewModel
    
    @Binding var selectedItems: Set<String>
    var isSelected: Bool {
        selectedItems.contains(viewModel.episodeID)
    }

    var body: some View {
        HStack {            
//            RoundCheckbox(selected: $isSelected, showAsHollowButton: false)
//                .padding(.leading)
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.title)
                    .lineLimit(2)

                Text(viewModel.subtitle)
                    .foregroundColor(.gray)
                    .bold()
                    .font(.footnote)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .onTapGesture {
            if isSelected {
                selectedItems.remove(viewModel.episodeID)
            } else {
                selectedItems.insert(viewModel.episodeID)
            }
        }
    }

}

//struct EpisodeCell_Previews: PreviewProvider {
//
//    static var previews: some View {
//        Group {
//            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episode(id: "1", idPodcast: 123, titulo: "Flat-Side Promoter", pubDate: Date(), duracao: 300, remoteUrl: "", tamanho: 0)), isSelected: .constant(false))
//            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episode(id: "2", idPodcast: 456, titulo: "With Four Hands Tied Behind Its Back", dataPublicacao: Date(), duracao: 3600, urlRemoto: "", tamanho: 13080400), selected: true), isSelected: .constant(true))
//        }
//        .previewLayout(.fixed(width: 350, height: 100))
//    }
//
//}
