import SwiftUI

struct EpisodeRow: View {

    @StateObject var viewModel: EpisodeRowViewModel
    @Binding var selectedItems: Set<String>
    var isSelected: Bool {
        selectedItems.contains(viewModel.episodeID)
    }
    
    // MARK: - Checkmark component
    private let circleSize: CGFloat = 32.0
    private let unselectedFillColor: Color = .white
    private let unselectedForegroundColor: Color = .gray
    private let selectedFillColor: Color = .pink

    var body: some View {
        HStack {
            if isSelected {
                ZStack {
                    Circle()
                        .fill(selectedFillColor)
                        .frame(width: circleSize, height: circleSize)
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(unselectedFillColor)
                        .font(.title3.bold())
                        .frame(width: circleSize, height: circleSize)
                }
                .padding(.leading)
            } else {
                Circle()
                    .stroke(unselectedForegroundColor, lineWidth: 0.5)
                    .frame(width: circleSize, height: circleSize)
                    .padding(.leading)
            }
            
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

struct EpisodeCell_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episode(id: "1",
                                                                       podcastId: 123,
                                                                       title: "Flat-Side Promoter",
                                                                       pubDate: Date(),
                                                                       duration: 300,
                                                                       remoteUrl: "",
                                                                       filesize: 0)),
                       selectedItems: .constant(Set<String>()))
            
            EpisodeRow(viewModel: EpisodeRowViewModel(episode: Episode(id: "2",
                                                                       podcastId: 456,
                                                                       title: "With Four Hands Tied Behind Its Back",
                                                                       pubDate: Date(),
                                                                       duration: 3600,
                                                                       remoteUrl: "",
                                                                       filesize: 13080400)),
                       selectedItems: .constant(Set<String>()))
        }
        .previewLayout(.fixed(width: 350, height: 100))
    }

}
