import KingfisherSwiftUI
import SwiftUI

struct PodcastDetail: View {

    @ObservedObject var viewModel: PodcastDetailViewModel
    @State private var indicePagina = 0
    
    private let artworkSize: CGFloat = 64.0
    
    private let selectAllText = "Selecionar Todos"
    private let unselectAllText = "Deselecionar Todos"
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack(spacing: 15) {
//                AsyncImage(url: URL(string: "https://soundcloud.com/ummilkshakechamadowanda"))
//                    .frame(width: 55, height: 55)
                
                KFImage(URL(string: viewModel.artworkURL))
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
                                .opacity(0.5)

                            Image(systemName: "waveform")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                    }
                    .resizable()
                    .frame(width: artworkSize, height: artworkSize)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.title)
                        .font(.title3)
                        .bold()
                    Text(viewModel.details)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
            }
            .padding(.top, 5)
            .padding(.leading, 5)
            .padding(.trailing, 15)
            
            Picker(selection: $indicePagina, label: Text("Info")) {
                Text("Por episódio").tag(0)
                Text("Por ano").tag(1)
            }
            .disabled(viewModel.displayEpisodeList == false)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
            .padding(.top, 7)
            
            Button(action: {
                viewModel.areAllSelectEpisodeList.toggle()
                
                if viewModel.areAllSelectEpisodeList {
                    viewModel.unselectAll()
                } else {
                    viewModel.selectAll()
                }
            }) {
                Text(viewModel.areAllSelectEpisodeList ? unselectAllText : selectAllText)
            }
            .padding(.vertical, 10)
            
            Divider()

            // List
            if viewModel.displayEpisodeList {
                if indicePagina == 0 {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeCell(viewModel: EpisodeCellViewModel(episode: episode, selected: episode.selectedForDownload))
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                } else if indicePagina == 1 {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(viewModel.groups, id: \.id) { group in
                                EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(year: group.title, episodeCount: group.value))
                                    .padding(.vertical, 5)
                            }
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
                viewModel.downloadAll()
            }) {
                Text(viewModel.downloadAllButtonTitle)
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
            
            /*Text("Você pode baixar todos os episódios neste dispositivo, porém restará menos de 10% do espaço livre atualmente (40,5 GB).")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)*/
        }
        .navigationBarTitle("", displayMode: .inline)
    }

}

struct PodcastDetail_Previews: PreviewProvider {

    static var previews: some View {
        PodcastDetail(viewModel: PodcastDetailViewModel(podcast: Podcast(id: 1, titulo: "Um Milkshake Chamado Wanda", autor: "PAPELPOP", episodios: [Episodio(id: UUID().uuidString, idPodcast: 1, titulo: "Teste", dataPublicacao: Date(), duracao: 2.0, urlRemoto: "", tamanho: 13000)], urlFeed: "", urlCapa: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")))
    }

}
