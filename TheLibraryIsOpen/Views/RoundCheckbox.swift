import SwiftUI

struct RoundCheckbox: View {
    
    @Binding var selected: Bool
    @State var showAsHollowButton: Bool

    private let circleSize: CGFloat = 32.0
    
    // Unselected
    private let unselectedFillColor: Color = .white
    private let unselectedForegroundColor: Color = .gray
    
    // Selected
    private let selectedFillColor: Color = .pink
    private let selectedForegroundColor: Color = .white
    
    var body: some View {
        ZStack {
            if selected {
                Circle()
                    .fill(showAsHollowButton ? selectedForegroundColor : selectedFillColor)
                    .frame(width: circleSize, height: circleSize)
                
                Image(systemName: "checkmark")
                    .foregroundColor(showAsHollowButton ? selectedFillColor : unselectedFillColor)
                    .font(.title3.bold())
                    .frame(width: circleSize, height: circleSize)
            } else {
                Circle()
                    .stroke(unselectedForegroundColor, lineWidth: 0.5)
                    .frame(width: circleSize, height: circleSize)
            }
        }
        .onTapGesture {
            selected.toggle()
        }
    }

}

struct RoundCheckbox_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            RoundCheckbox(selected: .constant(false), showAsHollowButton: false)
            RoundCheckbox(selected: .constant(true), showAsHollowButton: false)
            RoundCheckbox(selected: .constant(true), showAsHollowButton: true)
        }
        .previewLayout(.fixed(width: 80, height: 80))
    }

}
