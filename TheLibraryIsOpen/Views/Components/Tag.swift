import SwiftUI

struct Tag: View {
    
    @State var text: String
    @State var color: Color
    private var backgroundWidth: CGFloat {
        return CGFloat(text.count * 9)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(color)
                .opacity(0.2)
                .frame(width: backgroundWidth, height: 22)
            
            Text(text.uppercased())
                .font(.footnote)
                .bold()
                .foregroundColor(color)
        }
    }

}

struct Tag_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            Tag(text: "Not exported yet", color: .gray)
            Tag(text: "Exported 2 hours ago", color: .green)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }

}
