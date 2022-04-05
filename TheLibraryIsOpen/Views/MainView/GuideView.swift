import SwiftUI

struct GuideView: View {
    
    @Binding var isShowingModal: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HStack(spacing: 35) {
                        Image("Trixie")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                        VStack(spacing: 30) {
                            Image(systemName: "airpods.gen3")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                            
                            Image(systemName: "square.stack.3d.down.forward.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundColor(.pink)
                        }
                    }
                    
                    Text("What TLIO is")
                        .font(.title2)
                        .bold()
                    
                    Text("TLIO permite baixar os seus podcasts favoritos e guardá-los para sempre em um serviço de armazenamento de arquivos de sua escolha.")
                    
                    Text("What TLIO is not")
                        .font(.title2)
                        .bold()
                    
                    Text("TLIO is not a podcast player.")
                        .bold()
                    
                    Text("Para reproduzir um episódio baixado é necessário exportar o arquivo e utilizar um tocador de podcasts como Overcast ou Pocket Casts.")
                }
                .padding(.horizontal, 20)
                .navigationTitle("Como Funciona?")
                .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingModal = false
                    }) {
                        Image(systemName: "xmark")
                            .font(Font.body.weight(.bold))
                            .foregroundColor(.gray)
                            .padding(.vertical, 3)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .buttonBorderShape(.capsule)
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
