import SwiftUI
import UniformTypeIdentifiers

struct ArchivedPodcastDetail: View {

    @StateObject var viewModel: ArchivedPodcastDetailViewModel
    @State private var showingExportOptions: Bool = false
    @State private var showingHistory: Bool = false
    @State private var sort: Int = 0
    
    private let files = LocalizableStrings.ArchivedPodcastDetail.Export.Options.filesApp
    private let other = LocalizableStrings.ArchivedPodcastDetail.Export.Options.other

    var body: some View {
        ZStack {
            VStack {
                NavigationLink(destination: PodcastHistoryView(viewModel: PodcastHistoryViewViewModel(podcastId: viewModel.podcast.id)), isActive: $showingHistory) { EmptyView() }
                
                Divider()

                // MARK: - List
                if viewModel.displayEpisodeList {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                ArchivedEpisodeRow(viewModel: ArchivedEpisodeRowViewModel(episode: episode),
                                                   downloadingItems: $viewModel.downloadingKeeper,
                                                   downloadedItems: $viewModel.downloadedKeeper,
                                                   downloadErrorItems: $viewModel.downloadErrorKeeper)
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
                
                // MARK: - Downloading...
                if viewModel.showOverallDownloadProgress {
                    HStack(spacing: 20) {
                        ProgressView(viewModel.progressViewMessage, value: viewModel.currentDownloadPercentage, total: viewModel.totalDownloadPercentage)
                            .animation(.linear, value: viewModel.currentDownloadPercentage)
                        
                        Button {
                            print("Download paused")
                        } label: {
                            Image(systemName: "pause.fill")
                                .font(.title2)
                        }
                        .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .accentColor, verticalPadding: 12, horizontalPadding: 18))
                        
                        Button {
                            print("Download cancelled")
                        } label: {
                            Image(systemName: "stop.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .accentColor, verticalPadding: 10, horizontalPadding: 14))
                    }
                    .padding(.horizontal)
                    .onChange(of: viewModel.currentDownloadPercentage) { newValue in
                        if newValue == viewModel.totalDownloadPercentage {
                            viewModel.showOverallDownloadProgress = false
                        }
                    }
                
                    switch viewModel.downloadOperationStatus {
                    case .activelyDownloading:
                        Text("ACTIVELY DOWNLOADING")
                            .font(.caption)
                            .foregroundColor(.gray)
                    case .paused:
                        Text("DOWNLOAD PAUSED")
                            .font(.caption)
                            .foregroundColor(.gray)
                    case .stopped:
                        Text("DOWNLOAD STOPPED")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // MARK: - Info
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ModernDataVisualizer(title: LocalizableStrings.episodes, imageName: "play.circle", value: viewModel.episodeCount)
                        Divider()
                            .fixedSize()
                        ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.Info.totalSize, imageName: "tray.full", value: viewModel.totalFilesize)
                        Divider()
                            .fixedSize()
                        ModernDataVisualizer(title: LocalizableStrings.ArchivedPodcastDetail.Info.lastChecked, imageName: "calendar", value: viewModel.lastCheckDate)
                    }
                }
                .padding()
                
                // MARK: - Export All button
                Button(action: {
                    showingExportOptions = true
                }) {
                    Text(LocalizableStrings.ArchivedPodcastDetail.Export.exportAllButtonLabel)
                        .bold()
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 25)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(30)
                .alert(isPresented: $viewModel.displayAlert) {
                    switch viewModel.alertType {
                    case .singleOption:
                        return Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(LocalizableStrings.ok)))
                    default:
                        return Alert(title: Text("Other Option Relies on Installed Apps"), message: Text("To export to your prefered cloud service, please make sure its app is installed on this device before continuing."), dismissButton: Alert.Button.default(Text(LocalizableStrings.ok), action: {
                            viewModel.showShareSheet()
                        }))
                    }
                }
                .padding(.vertical, 5)
                .disabled(viewModel.downloadingKeeper.isEmpty == false)
                .actionSheet(isPresented: $showingExportOptions) {
                    ActionSheet(title: Text(LocalizableStrings.ArchivedPodcastDetail.Export.exportOptionsText),
                                message: nil,
                                buttons: [.default(Text(files)) {
                                              viewModel.zipAllEpisodes()
                                              viewModel.showingFileExplorer = true
                                          },
                                          .default(Text(other)) {
                                              viewModel.alertType = .speciallyPreparedOption
                                              viewModel.displayAlert = true
                                          },
                                          .cancel(Text(LocalizableStrings.cancel))])
                }
                .fileMover(isPresented: $viewModel.showingFileExplorer, file: viewModel.zipFileURL, onCompletion: { result in
                    switch result {
                    case .success:
                        viewModel.isShowingProcessingView = false
                        viewModel.showingModalView = true
                    case .failure(let error):
                        print(error.localizedDescription)
                        viewModel.showAlert(withTitle: "Failed to Export Archive", message: error.localizedDescription)
                    }
                })
            }
            
            if viewModel.isShowingProcessingView {
                ProcessingView(message: $viewModel.processingViewMessage)
                    .padding(.bottom)
            }
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
        .navigationBarItems(trailing:
            Menu {
                Section {
                    Button(action: {
                        viewModel.toggleEpisodeListSorting()
                    }) {
                        Label("Data de Publicação", systemImage: viewModel.episodeListSorting == .fromNewToOld ? "chevron.down" : "chevron.up")
                    }
                    .onChange(of: viewModel.episodeListSorting) { newValue in
                        if viewModel.episodeListSorting == .fromNewToOld {
                            viewModel.sortEpisodesByPubDateDescending()
                        } else {
                            viewModel.sortEpisodesByPubDateAscending()
                        }
                    }
                }
                
                Section {
                    Picker(selection: $sort) {
                        Text(LocalizableStrings.ArchivedPodcastDetail.Options.showDownloadedEpisodesOnly).tag(0)
                        Text(LocalizableStrings.ArchivedPodcastDetail.Options.showAllEpisodes).tag(1)
                    } label: {
                        Text("Sorting options")
                    }
                }
                
                Section {
                    Button {
                        print("Look for new episodes pressed")
                    } label: {
                        Label(LocalizableStrings.ArchivedPodcastDetail.Options.lookForNewEpisodes, systemImage: "arrow.clockwise")
                    }
                    
                    Button {
                        showingHistory = true
                    } label: {
                        Label(LocalizableStrings.ArchivedPodcastDetail.Options.viewHistory, systemImage: "clock")
                    }
                }
            
                Section {
                    Button(role: .destructive, action: {
                        viewModel.dummyCall()
                    }, label: {
                        HStack {
                            Text(LocalizableStrings.ArchivedPodcastDetail.Options.deletePodcast)
                            Image(systemName: "trash")
                        }
                    })
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        )
        .sheet(isPresented: $viewModel.showingModalView) {
            AfterExportSuccessView(isShowingModal: $viewModel.showingModalView)
        }
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
