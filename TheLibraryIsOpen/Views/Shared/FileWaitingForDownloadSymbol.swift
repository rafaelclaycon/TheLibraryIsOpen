import SwiftUI

struct FileWaitingForDownloadSymbol: View {

    var body: some View {
        ZStack {
            Image(systemName: "doc.fill")
                .resizable()
                .frame(width: 32, height: 40)
                .foregroundColor(.gray)
                .opacity(0.15)
            
            Image(systemName: "clock")
                .foregroundColor(.primary)
                .font(.title2.bold())
                .offset(x: 0, y: 2)
        }
    }

}

struct FileWaitingForDownloadSymbol_Previews: PreviewProvider {

    static var previews: some View {
        FileWaitingForDownloadSymbol()
            .previewLayout(.fixed(width: 100, height: 100))
    }

}
