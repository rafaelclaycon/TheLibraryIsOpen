import SwiftUI

struct EpisodeGroupView: View {

    @StateObject var viewModel: EpisodeGroupViewViewModel
    @Binding var selectedItems: Set<String>
    var isSelected: Bool {
        return selectedItems.contains(viewModel.groupID)
    }
    
    // Unselected
    private let unselectedFillColor: Color = .systemBackground
    private let unselectedForegroundColor: Color = .gray
    
    // Selected
    private let selectedFillColor: Color = .accentColor
    private let selectedForegroundColor: Color = .white
    
    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(isSelected ? selectedFillColor : unselectedFillColor)
                    .frame(width: 160, height: 100)
            } else {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(unselectedForegroundColor, lineWidth: 0.5)
                    .frame(width: 160, height: 100)
            }
            
            if viewModel.showWeightEmoji {
                Text(viewModel.weightEmoji)
                    .font(.system(size: 34))
                    .opacity(isSelected ? 1.0 : 0.6)
                    .padding(.trailing, 105)
                    .padding(.top, 55)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .foregroundColor(isSelected ? selectedForegroundColor : unselectedForegroundColor)
                        .font(.title)
                        .bold()
                    
                    Text(viewModel.subtitle)
                        .foregroundColor(isSelected ? selectedForegroundColor : unselectedForegroundColor)
                        .font(.subheadline)
                    
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.top, 6)
                
                Spacer()
            }
            .frame(width: 160, height: 100)
            
            if isSelected {
                RoundCheckbox(selected: .constant(true), style: .holePunch)
                    .padding(.top, 50)
                    .padding(.leading, 110)
            } else {
                RoundCheckbox(selected: .constant(false), style: .holePunch)
                    .padding(.top, 50)
                    .padding(.leading, 110)
            }
        }
        .onTapGesture {
            if isSelected {
                selectedItems.remove(viewModel.groupID)
            } else {
                selectedItems.insert(viewModel.groupID)
            }
        }
    }

}

struct EpisodeGroupView_Previews: PreviewProvider {

    static var previews: some View {
        let episodeA = Episode(filesize: 738_000_000)
        let episodeB = Episode(filesize: 885_000_000)
        let episodeC = Episode(filesize: 1_499_000_000)
        let episodeD = Episode(filesize: 1_866_000_000)
        
        let alphaGroup = EpisodeGroup(id: "alpha", year: "2013", episodes: [episodeA], relativeWeight: .lightest)
        let betaGroup = EpisodeGroup(id: "beta", year: "2014", episodes: [episodeA, episodeB]) // 18 ep ~ 2.5 GB
        let gammaGroup = EpisodeGroup(id: "gamma", year: "2020", episodes: [episodeA, episodeB, episodeC]) // 52 ep ~ 6.81 GB
        let deltaGroup = EpisodeGroup(id: "delta", year: "2021", episodes: [episodeA, episodeB, episodeC, episodeD], relativeWeight: .heaviest)
        
        Group {
            // Unselected
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: alphaGroup, useWeightEmojis: false), selectedItems: .constant(Set<String>()))
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: betaGroup, useWeightEmojis: false), selectedItems: .constant(Set<String>()))
            
            // Selected
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: gammaGroup, useWeightEmojis: false), selectedItems: .constant(Set<String>(arrayLiteral: gammaGroup.id)))
            
            // Unselected
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: deltaGroup, useWeightEmojis: false), selectedItems: .constant(Set<String>()))
        }
        .previewLayout(.fixed(width: 250, height: 120))
    }

}
