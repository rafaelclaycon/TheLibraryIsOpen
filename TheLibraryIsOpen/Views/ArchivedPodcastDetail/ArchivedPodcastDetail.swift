import SwiftUI
import UniformTypeIdentifiers

struct ArchivedPodcastDetail: View {

    @StateObject var viewModel: ArchivedPodcastDetailViewModel
    @State private var indicePagina = 0
    @State var showingExportOptions: Bool = false
    @State var showingFileExplorer: Bool = false
    @State var myDocument: TextFile = TextFile(initialText: "Hello")
    
    // Private properties
    private let artworkSize: CGFloat = 64.0
    private let recentsFirstText = LocalizableStrings.mostRecentFirst
    private let oldestFirstText = LocalizableStrings.oldestFirst
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
                }) {
                    HStack {
                        Image(systemName: viewModel.recentsFirst ? "arrow.uturn.down.circle" : "arrow.uturn.up.circle")
                        Text(viewModel.recentsFirst ? recentsFirstText : oldestFirstText)
                    }
                }
                
                Menu {
                    Button("Only Downloaded", action: viewModel.placeOrder)
                    Button("All Episodes", action: viewModel.adjustOrder)
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filter")
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
                                               downloadingItems: $viewModel.downloadingKeeper,
                                               downloadedItems: $viewModel.downloadedKeeper,
                                               downloadErrorItems: $viewModel.downloadErrorKeeper,
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ModernDataVisualizer(title: LocalizableStrings.episodes, imageName: "play.circle", value: viewModel.episodeCount)
                    Divider()
                        .fixedSize()
                    ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.totalSize, imageName: "tray.full", value: viewModel.totalFilesize)
                    Divider()
                        .fixedSize()
                    ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.lastChecked, imageName: "calendar", value: viewModel.lastCheckDate)
                }
            }
            .padding()
            
            Button(action: {
                showingExportOptions = true
            }) {
                Text(LocalizableStrings.ArchivedPodcastDetail.exportButtonLabel)
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
            .actionSheet(isPresented: $showingExportOptions) {
                ActionSheet(title: Text(LocalizableStrings.ArchivedPodcastDetail.exportOptionsText),
                            message: nil,
                            buttons: [.default(Text(files)) {
                                          viewModel.zipAll()
                                      },
                                      .default(Text(googleDrive)) { viewModel.showExportDestinationNotSupportedYet(providerName: googleDrive) },
                                      .default(Text(dropbox)) { viewModel.showExportDestinationNotSupportedYet(providerName: dropbox) },
                                      .default(Text(oneDrive)) { viewModel.showExportDestinationNotSupportedYet(providerName: dropbox) },
                                      .cancel(Text(LocalizableStrings.cancel))])
            }
//            .fileExporter(isPresented: $showingFileExplorer, document: myDocument, contentType: .mp3, onCompletion: { result in
//                switch result {
//                case .success(let url):
//                    print("Saved to \(url)")
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            })
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
        .navigationBarItems(trailing:
            Menu {
                Button("View History", action: viewModel.placeOrder)
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        )
    }

}

struct ArchivedPodcastDetail_Previews: PreviewProvider {

    static var previews: some View {
        ArchivedPodcastDetail(viewModel: ArchivedPodcastDetailViewModel(podcast: Podcast(id: 1,
                                                                                         title: "Um Milkshake Chamado Wanda",
                                                                                         author: "PAPELPOP",
                                                                                         episodes: [Episode(title: "#310 - Pais e mães de planta e o terror dos insetos",
                                                                                                            duration: 9120.0,
                                                                                                            filesize: 121700000,
                                                                                                            offlineStatus: .downloading),
                                                                                                    Episode(title: "#309 - Ser ou não ser sincerão? (feat. Lorelay",
                                                                                                            duration: 7860.0,
                                                                                                            filesize: 107000000,
                                                                                                            offlineStatus: .availableOffline),
                                                                                                    Episode(title: "#308 - A Nova Era do Wanda (feat. Chico Felitti",
                                                                                                            duration: 6900.0,
                                                                                                            filesize: 95000000,
                                                                                                            offlineStatus: .downloading)
                                                                                                   ],
                                                                                        feedUrl: "",
                                                                                         artworkUrl: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")))
    }

}
