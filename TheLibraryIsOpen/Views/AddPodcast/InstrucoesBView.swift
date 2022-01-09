import SwiftUI

struct InstrucoesBView: View {

    @StateObject var viewModel = InstrucoesBViewModel()
    @Binding var estaSendoExibido: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        Image("paste")
                            .resizable()
                            .frame(width: 350, height: 197)
                            .border(Color.gray, width: 1)
                        
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    
                    Text("6. Cole o link do podcast aqui:")
                        .padding(.horizontal, 25)
                        .padding(.bottom, 15)
                    
                    TextField("https://...", text: $viewModel.entrada)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 25)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: PodcastPreview(viewModel: viewModel.podcastDetailViewModel, estaSendoExibido: $estaSendoExibido), isActive: $viewModel.isMostrandoPodcastDetailView) { EmptyView() }
                        
                        Button(action: {
                            viewModel.processar()
                        }) {
                            Text("Analisar Link")
                                .bold()
                        }
                        .buttonStyle(PillButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    VStack() {
                        Text(viewModel.titulo)
                            .bold()
                            .padding(.bottom, 5)
                        Text(viewModel.primeiroEp)
                        Text(viewModel.ultimoEp)
                        Text(viewModel.qtd)
                            .padding(.top, 5)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            
            if viewModel.processando {
                ProcessandoView()
            }
        }
        .navigationBarTitle(Text("Obter Episódios"))
        .navigationBarItems(trailing:
            Button(action: {
                self.estaSendoExibido = false
            }) {
                Text("Cancelar")
            }
        )
    }

}

struct InstrucoesLinkView_Previews: PreviewProvider {

    static var previews: some View {
        InstrucoesBView(estaSendoExibido: .constant(true))
    }

}
