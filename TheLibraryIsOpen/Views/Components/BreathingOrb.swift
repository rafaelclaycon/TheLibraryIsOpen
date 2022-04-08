import SwiftUI

struct BreathingOrb: View {

    private var diameter: CGFloat = 280

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: diameter, height: diameter)
                .opacity(0.45)
            
            Image(systemName: "link")
                .foregroundColor(.white)
                .font(.system(size: 80))
        }
    }

}

struct BreathingOrb_Previews: PreviewProvider {

    static var previews: some View {
        BreathingOrb()
    }

}
