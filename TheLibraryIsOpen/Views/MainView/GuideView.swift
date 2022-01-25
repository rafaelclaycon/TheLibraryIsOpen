import SwiftUI

struct GuideView: View {
    
    @Binding var isShowingModal: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    Text("O que TLIO é")
                        .font(.title2)
                        .bold()
                    
                    Text("O que TLIO não é")
                        .font(.title2)
                        .bold()
                }
                .navigationTitle("Como Funciona?")
                .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingModal = false
                    }) {
                        Image(systemName: "xmark")
                            .font(Font.body.weight(.bold))
                            .foregroundColor(.gray)
                            .padding(.all, 1)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .buttonBorderShape(.capsule)
                    .padding(.vertical)
                )
            }
        }
    }

}

struct GuideView_Previews: PreviewProvider {

    static var previews: some View {
        GuideView(isShowingModal: .constant(true))
    }

}
