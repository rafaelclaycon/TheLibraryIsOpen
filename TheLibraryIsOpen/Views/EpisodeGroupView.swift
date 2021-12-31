import SwiftUI

struct EpisodeGroupView: View {

    @ObservedObject var viewModel: EpisodeGroupViewViewModel
    
    private let deactivatedColor: Color = .gray
    private let activeColor: Color = .black
    private let circleSize: CGFloat = 32.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(viewModel.isSelected ? activeColor : deactivatedColor, lineWidth: viewModel.isSelected ? 1.0 : 0.5)
                .frame(width: 160, height: 100)
            
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .foregroundColor(viewModel.isSelected ? activeColor : deactivatedColor)
                    .font(.title)
                    .bold()
                
                Text(viewModel.subtitle)
                    .foregroundColor(viewModel.isSelected ? activeColor : deactivatedColor)
                    .font(.footnote)
            }
            .padding(.trailing, 60)
            .padding(.bottom, 35)
            
            if viewModel.isSelected {
                Circle()
                    .fill(Color.pink)
                    .frame(width: circleSize, height: circleSize)
                    .padding(.top, 50)
                    .padding(.leading, 110)
                
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
                    .font(.title3.bold())
                    .frame(width: circleSize, height: circleSize)
                    .padding(.top, 50)
                    .padding(.leading, 110)
            } else {
                Circle()
                    .stroke(deactivatedColor, lineWidth: 0.5)
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
