import SwiftUI

struct FileNotMarkedForDownloadSymbol: View {

    var body: some View {
        ZStack {
            Image(systemName: "doc.fill")
                .resizable()
                .frame(width: 32, height: 40)
                .foregroundColor(.gray)
                .opacity(0.10)
            
            Image(systemName: "icloud")
                .foregroundColor(.gray)
                .font(.title3)
                .offset(x: 0, y: 2)
                .opacity(0.5)
        }
    }

}

struct FileNotMarkedForDownloadSymbol_Previews: PreviewProvider {

    static var previews: some View {
        FileNotMarkedForDownloadSymbol()
            .previewLayout(.fixed(width: 100, height: 100))
    }

}
