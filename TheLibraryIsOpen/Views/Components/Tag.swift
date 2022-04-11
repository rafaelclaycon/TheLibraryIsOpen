import SwiftUI

struct Tag: View {
    
    @State var text: String
    @State var color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(color)
                .opacity(0.2)
                .frame(height: 22)
            
            Text(text.uppercased())
                .font(.footnote)
                .bold()
                .foregroundColor(color)
                .padding(.horizontal, 8)
        }
        .fixedSize()
    }

}

struct Tag_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            Tag(text: "Not exported yet", color: .gray)
            Tag(text: "Exported 2 hours ago", color: .green)
            
            // With diacritics
            Tag(text: "Não exportado", color: .gray)
            Tag(text: "Exportado há 46 minutos", color: .green)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }

}
