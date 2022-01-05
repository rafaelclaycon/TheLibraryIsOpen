import SwiftUI

struct ProcessandoView: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .opacity(0.2)
            
            ProgressView()
                .scaleEffect(2, anchor: .center)
        }
    }

}

struct ProcessandoView_Previews: PreviewProvider {

    static var previews: some View {
        ProcessandoView()
    }

}
