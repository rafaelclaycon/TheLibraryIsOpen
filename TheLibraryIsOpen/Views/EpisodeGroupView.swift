import SwiftUI

struct EpisodeGroupView: View {

    @ObservedObject var viewModel: EpisodeGroupViewViewModel
    
    private let circleSize: CGFloat = 32.0
    
    // Unselected
    private let unselectedFillColor: Color = .white
    private let unselectedForegroundColor: Color = .gray
    
    // Selected
    private let selectedFillColor: Color = .pink
    private let selectedForegroundColor: Color = .white
    
    var body: some View {
        ZStack {
            if viewModel.isSelected {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(viewModel.isSelected ? selectedFillColor : unselectedFillColor)
                    .frame(width: 160, height: 100)
            } else {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(unselectedForegroundColor, lineWidth: 0.5)
                    .frame(width: 160, height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .foregroundColor(viewModel.isSelected ? selectedForegroundColor : unselectedForegroundColor)
                    .font(.title)
                    .bold()
                
                Text(viewModel.subtitle)
                    .foregroundColor(viewModel.isSelected ? selectedForegroundColor : unselectedForegroundColor)
                    .font(.footnote)
            }
            .padding(.trailing, 60)
            .padding(.bottom, 35)
            
            if viewModel.isSelected {
                Circle()
                    .fill(selectedForegroundColor)
                    .frame(width: circleSize, height: circleSize)
                    .padding(.top, 50)
                    .padding(.leading, 110)
                
                Image(systemName: "checkmark")
                    .foregroundColor(selectedFillColor)
                    .font(.title3.bold())
                    .frame(width: circleSize, height: circleSize)
                    .padding(.top, 50)
                    .padding(.leading, 110)
            } else {
                Circle()
                    .stroke(unselectedForegroundColor, lineWidth: 0.5)
                    .frame(width: circleSize, height: circleSize)
                    .padding(.top, 50)
                    .padding(.leading, 110)
            }
        }
        .onTapGesture {
            viewModel.isSelected.toggle()
        }
    }

}

struct EpisodeGroupView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(year: "2014", episodeCount: "18 episódios"))
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(year: "2020", episodeCount: "52 episódios", selected: true))
        }
        .previewLayout(.fixed(width: 250, height: 120))
    }

}
