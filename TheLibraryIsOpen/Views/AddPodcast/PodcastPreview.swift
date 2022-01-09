import KingfisherSwiftUI
import SwiftUI

struct PodcastPreview: View {

    @StateObject var viewModel: PodcastPreviewViewModel
    @State private var indicePagina = 0
    @Binding var estaSendoExibido: Bool
    
    // Private properties
    private let artworkSize: CGFloat = 64.0
    private let selectAllText = "Select all"
    private let unselectAllText = "Unselect all"
    private let recentsFirstText = "Most recent first"
    private let oldestFirstText = "Oldest first"
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack(spacing: 15) {                
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
            
            Picker(selection: $indicePagina, label: Text("Grouped by")) {
                Text("Grouped by episode").tag(0)
                Text("Grouped by year").tag(1)
            }
            .disabled(viewModel.displayEpisodeList == false)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
            .padding(.top, 7)
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.toggleSelectAll()
                }) {
                    HStack {
                        Image(systemName: viewModel.allEpisodesSelected ? "circle.dotted" : "checkmark.circle")
                        Text(viewModel.allEpisodesSelected ? unselectAllText : selectAllText)
                    }
                }
                
                Button(action: {
                    viewModel.recentsFirst.toggle()
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
                if indicePagina == 0 {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode), selectedItems: $viewModel.selectionKeeper)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    .onChange(of: viewModel.selectionKeeper) { value in
                        viewModel.updateDownloadButton(selectedIDs: Array(viewModel.selectionKeeper))
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
                        Text("No Episodes")
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            Divider()
                .padding(.bottom, 5)
            
            Button(action: {
                if viewModel.download(episodeIDs: viewModel.selectionKeeper) {
                    estaSendoExibido = false
                }
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
            .disabled(viewModel.isAnyEpisodeSelected == false)
            
            /*Button(action: {
                // viewModel.
            }) {
                Text("Apenas adicionar podcast ao arquivo")
            }
            .padding(.vertical, 10)*/
            
            /*Text("Você pode baixar todos os episódios neste dispositivo, porém restará menos de 10% do espaço livre atualmente (40,5 GB).")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)*/
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.estaSendoExibido = false
            }) {
                Text("Cancel")
            }
        )
    }

}

struct PodcastPreview_Previews: PreviewProvider {

    static var previews: some View {
        PodcastPreview(viewModel: PodcastPreviewViewModel(podcast: Podcast(id: 1, titulo: "Um Milkshake Chamado Wanda", autor: "PAPELPOP", episodios: [Episodio(id: UUID().uuidString, idPodcast: 1, titulo: "Teste", dataPublicacao: Date(), duracao: 2.0, urlRemoto: "", tamanho: 13000)], urlFeed: "", urlCapa: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")), estaSendoExibido: .constant(true))
    }

}
