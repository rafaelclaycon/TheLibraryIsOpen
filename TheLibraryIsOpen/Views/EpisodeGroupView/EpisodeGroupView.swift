import SwiftUI

struct EpisodeGroupView: View {

    @StateObject var viewModel: EpisodeGroupViewViewModel
    @Binding var selectedItems: Set<String>
    @State var isSelectedForComponent: Bool = false
    var isSelected: Bool {
        let newValue = selectedItems.contains(viewModel.groupID)
        isSelectedForComponent = newValue
        return newValue
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
            
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .foregroundColor(isSelected ? selectedForegroundColor : unselectedForegroundColor)
                    .font(.title)
                    .bold()
                
                Text(viewModel.subtitle)
                    .foregroundColor(isSelected ? selectedForegroundColor : unselectedForegroundColor)
                    .font(.footnote)
            }
            .padding(.trailing, 60)
            .padding(.bottom, 35)
            
            RoundCheckbox(selected: $isSelectedForComponent, showAsHollowButton: true)
                .padding(.top, 50)
                .padding(.leading, 110)
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
        Group {
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: EpisodeGroup(title: "2014", value: "18 episódios")), selectedItems: .constant(Set<String>()))
            EpisodeGroupView(viewModel: EpisodeGroupViewViewModel(group: EpisodeGroup(title: "2020", value: "52 episódios")), selectedItems: .constant(Set<String>()))
        }
        .previewLayout(.fixed(width: 250, height: 120))
    }

}
