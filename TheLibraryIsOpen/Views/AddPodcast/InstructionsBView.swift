import SwiftUI

struct InstructionsBView: View {

    @StateObject var viewModel = InstructionsBViewModel()
    @Binding var estaSendoExibido: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        Image("paste")
                            .resizable()
                            .frame(width: 350, height: 197)
                        
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    
                    Text(LocalizableStrings.InstructionsBView.step6)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 15)
                    
                    TextField("https://podcasts.apple.com...", text: $viewModel.entrada)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 25)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: PodcastPreview(viewModel: viewModel.podcastDetailViewModel, estaSendoExibido: $estaSendoExibido, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd), isActive: $viewModel.isMostrandoPodcastDetailView) { EmptyView() }
                        
                        Button(action: {
                            viewModel.processLink()
                        }) {
                            Text(LocalizableStrings.InstructionsBView.processLinkButtonLabel)
                                .bold()
                        }
                        .buttonStyle(PillButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .alert(isPresented: $viewModel.displayAlert) {
                        Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                }
            }
            
            if viewModel.processando {
                ProcessingView(message: $viewModel.processingViewMessage)
            }
        }
        .navigationBarTitle(Text(LocalizableStrings.InstructionsBView.title))
        .navigationBarItems(trailing:
            Button(action: {
                self.estaSendoExibido = false
            }) {
                Text(LocalizableStrings.cancel)
            }
        )
    }

}

struct InstrucoesLinkView_Previews: PreviewProvider {

    static var previews: some View {
        InstructionsBView(estaSendoExibido: .constant(true), podcastToAutoOpenAfterAdd: .constant(0))
    }

}
