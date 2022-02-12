import SwiftUI

struct AfterExportSuccessView: View {

    @Binding var isShowingModal: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack(spacing: 15) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 34)
                    .foregroundColor(.green)
                
                Text(LocalizableStrings.AfterExportSuccessView.exportSuccessfulTitle)
                    .font(.title)
                    .foregroundColor(.green)
                    .bold()
            }
            .padding(.top, 25)
            
            Image("happy listener")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Text(LocalizableStrings.AfterExportSuccessView.whatNowSubtitle)
                .font(.title2)
                .bold()
            
            Text(LocalizableStrings.AfterExportSuccessView.explanationTextFirstParagraph)
            
            Text(LocalizableStrings.AfterExportSuccessView.explanationTextSecondParagraph)
            
            Spacer()
            
            Button {
                isShowingModal = false
            } label: {
                Text(LocalizableStrings.ok)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 26)
    }

}

struct AfterExportSuccessView_Previews: PreviewProvider {

    static var previews: some View {
        AfterExportSuccessView(isShowingModal: .constant(true))
    }

}
