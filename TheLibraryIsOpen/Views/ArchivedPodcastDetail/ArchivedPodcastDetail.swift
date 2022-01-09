import KingfisherSwiftUI
import SwiftUI

struct ArchivedPodcastDetail: View {

    @StateObject var viewModel: ArchivedPodcastDetailViewModel
    @State private var indicePagina = 0
    @State var selectionKeeper = Set<String>()
    
    // Private properties
    private let artworkSize: CGFloat = 64.0
    private let selectAllText = "Selecionar todos"
    private let unselectAllText = "Deselecionar todos"
    private let recentsFirstText = "Recentes primeiro"
    private let oldestFirstText = "Antigos primeiro"
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.recentsFirst.toggle()
                    
                    if viewModel.areAllSelectEpisodeList {
                        viewModel.applyToAllEpisodes(select: true)
                    } else {
                        viewModel.applyToAllEpisodes(select: false)
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.recentsFirst ? "arrow.uturn.down.circle" : "arrow.uturn.up.circle")
                        Text(viewModel.recentsFirst ? recentsFirstText : oldestFirstText)
                    }
                }
            }
            .padding(.vertical, 10)
            
            Divider()

            // List
            if viewModel.displayEpisodeList {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.episodes, id: \.id) { episode in
                            EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode), selectedItems: $selectionKeeper)
                                .padding(.vertical, 5)
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Nenhum Episódio")
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            Divider()
                .padding(.bottom, 5)
            
            Button(action: {
                if viewModel.download(episodeIDs: selectionKeeper) {
                    print("")
                }
            }) {
                Text("Exportar para...")
                    .bold()
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(30)
            .alert(isPresented: $viewModel.displayAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding(.vertical, 5)
            .disabled(viewModel.isAnyEpisodeSelected == false)
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
    }

}

struct ArchivedPodcastDetail_Previews: PreviewProvider {

    static var previews: some View {
        PodcastPreview(viewModel: PodcastPreviewViewModel(podcast: Podcast(id: 1, titulo: "Um Milkshake Chamado Wanda", autor: "PAPELPOP", episodios: [Episodio(id: UUID().uuidString, idPodcast: 1, titulo: "Teste", dataPublicacao: Date(), duracao: 2.0, urlRemoto: "", tamanho: 13000)], urlFeed: "", urlCapa: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")), estaSendoExibido: .constant(true))
    }

}
