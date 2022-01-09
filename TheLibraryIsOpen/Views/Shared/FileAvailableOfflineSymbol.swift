import SwiftUI

struct FileAvailableOfflineSymbol: View {

    var body: some View {
        ZStack {
            Image(systemName: "doc.fill")
                .resizable()
                .frame(width: 32, height: 40)
                .foregroundColor(.pink)
                .opacity(0.2)
            
            Image(systemName: "checkmark")
                .foregroundColor(.pink)
                .font(.title3.bold())
                .offset(x: 0, y: 2)
        }
    }

}

struct FileDownloadedSymbol_Previews: PreviewProvider {

    static var previews: some View {
        FileAvailableOfflineSymbol()
            .previewLayout(.fixed(width: 100, height: 100))
    }

}
