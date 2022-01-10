import SwiftUI

struct ModernDataVisualizer: View {
    
    let title: String
    let imageName: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
            HStack {
                Image(systemName: imageName)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title3)
            }
        }
    }

}

struct ModernDataVisualizer_Previews: PreviewProvider {

    static var previews: some View {
        ModernDataVisualizer(title: "Episodes", imageName: "play.circle", value: "8")
            .previewLayout(.fixed(width: 200, height: 100))
    }

}
