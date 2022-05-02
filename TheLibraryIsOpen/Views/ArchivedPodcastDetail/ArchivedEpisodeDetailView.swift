import SwiftUI

struct ArchivedEpisodeDetailView: View {

    @StateObject var viewModel: ArchivedEpisodeDetailViewViewModel
    @Binding var isShowingModal: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.isShowingModal = false
                }) {
                    Image(systemName: "chevron.down")
                        .font(Font.body.weight(.bold))
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 3)
                }
                
                Spacer()
            }
            .padding()
            
            VStack(alignment: .center, spacing: 20) {
                if let episodeArtwork = viewModel.artwork, let uiImage = UIImage(data: episodeArtwork) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Text(viewModel.title)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal)
                
                Button {
                    print("Button tapped")
                } label: {
                    Text(viewModel.episodeIsDownloaded ? LocalizableStrings.ArchivedEpisodeDetailView.exportEpisodeButtonLabel : LocalizableStrings.ArchivedEpisodeDetailView.downloadEpisodeButtonLabel)
                        .bold()
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .controlSize(.large)
                
                HStack(spacing: 12) {
                    if viewModel.episodeIsDownloaded {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "icloud")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                            .foregroundColor(.gray)
                    }
                    
                    Text(viewModel.fileSize)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                HStack {
                    Text(viewModel.publicationDate)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.duration)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 15)
                
                Text(viewModel.description)
                    .padding(.horizontal, 10)
                
                Spacer()
            }
        }
    }

}

struct ArchivedEpisodeDetailView_Previews: PreviewProvider {

    static var previews: some View {
        ArchivedEpisodeDetailView(viewModel: ArchivedEpisodeDetailViewViewModel(episode: Episode(title: "Tricô Talks 104 - Vamos Falar de Big Brother, Sim! - com @inutilidadesdagabi")), isShowingModal: .constant(true))
    }

}
