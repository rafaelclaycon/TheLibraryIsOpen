import SwiftUI

struct ArchivedPodcastDetail: View {

    @StateObject var viewModel: ArchivedPodcastDetailViewModel
    @State private var indicePagina = 0
    @State var showingExportOptions: Bool = false
    
    // List status keepers
    //@State var selectionKeeper = Set<String>()
    @State var downloadingKeeper = Set<String>()
    @State var downloadedKeeper = Set<String>()
    @State var downloadErrorKeeper = Set<String>()
    
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
    
    private let files = "Files"
    private let googleDrive = "Google Drive"
    private let dropbox = "Dropbox"
    private let oneDrive = "OneDrive"

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
                            ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: episode),
                                               downloadingItems: $downloadingKeeper,
                                               downloadedItems: $downloadedKeeper,
                                               downloadErrorItems: $downloadErrorKeeper,
                                               circleSize: 30.0)
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
                showingExportOptions = true
            }) {
                Text("Export to...")
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
            .actionSheet(isPresented: $showingExportOptions) {
                ActionSheet(title: Text("Please select a destination"),
                            message: nil,
                            buttons: [.default(Text(files)) { viewModel.showExportDestinationNotSupportedYet(providerName: files) },
                                      .default(Text(googleDrive)) { viewModel.showExportDestinationNotSupportedYet(providerName: googleDrive) },
                                      .default(Text(dropbox)) { viewModel.showExportDestinationNotSupportedYet(providerName: dropbox) },
                                      .default(Text(oneDrive)) { viewModel.showExportDestinationNotSupportedYet(providerName: dropbox) },
                                      .cancel(Text("Cancel"))])
            }
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
    }

}

struct ArchivedPodcastDetail_Previews: PreviewProvider {

    static var previews: some View {
        ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: Podcast(id: 1,
                                                                                         title: "Um Milkshake Chamado Wanda",
                                                                                         author: "PAPELPOP",
                                                                                         episodes: [Episode(title: "#310 - Pais e mães de planta e o terror dos insetos",
                                                                                                            duration: 9120.0,
                                                                                                            filesize: 13000,
                                                                                                            offlineStatus: .downloading),
                                                                                                    Episode(title: "#309 - Ser ou não ser sincerão? (feat. Lorelay",
                                                                                                            duration: 7860.0,
                                                                                                            filesize: 13000,
                                                                                                            offlineStatus: .availableOffline),
                                                                                                    Episode(title: "#308 - A Nova Era do Wanda (feat. Chico Felitti",
                                                                                                            duration: 6900.0,
                                                                                                            filesize: 13000,
                                                                                                            offlineStatus: .downloading)
                                                                                                   ],
                                                                                        feedUrl: "",
                                                                                         artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")))
    }

}
