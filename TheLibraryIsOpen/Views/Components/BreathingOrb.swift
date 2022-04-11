import SwiftUI

struct BreathingOrb: View {

    @Binding var link: String
    var breatheOutDiameter: CGFloat = 150
    var breatheInDiameter: CGFloat = 290
    var hasLink: Bool {
        return link.isEmpty == false
    }

    var body: some View {
        ZStack {
            if hasLink {
                Circle()
                    .fill(Color.purple)
                    .frame(width: breatheInDiameter, height: breatheInDiameter)
                    .opacity(1.0)
                
                Text(link)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: 250)
                    .multilineTextAlignment(.center)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: breatheOutDiameter, height: breatheOutDiameter)
                    .opacity(0.45)
                
                Image(systemName: "link")
                    .foregroundColor(.white)
                    .font(.system(size: 80))
            }
        }
    }

}

struct BreathingOrb_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            BreathingOrb(link: .constant(.empty))
            BreathingOrb(link: .constant("https://podcasts.apple.com/br/podcast/um-milkshake-chamado-wanda/id916378162"))
        }
        .previewLayout(.fixed(width: 390, height: 320))
    }

}
