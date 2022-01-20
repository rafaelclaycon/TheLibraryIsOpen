import SwiftUI

struct PasteLinkView: View {

    @StateObject var viewModel = PasteLinkViewViewModel()
    @Binding var estaSendoExibido: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        Image("paste")
                            .resizable()
                            .frame(width: 350, height: 197)
                            .onTapGesture {
                                focusedField = nil
                            }
                        
                        Spacer()
                    }
                    .padding(.vertical, 30)
                    
                    Text(LocalizableStrings.InstructionsBView.step6)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 15)
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    TextField("https://...", text: $viewModel.linkInput)
                        .focused($focusedField, equals: 1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 25)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: PodcastPreview(viewModel: viewModel.podcastDetailViewModel, isShowingAddPodcastModal: $estaSendoExibido, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd), isActive: $viewModel.isShowingPodcastPreview) { EmptyView() }
                        
                        Button(action: {
                            focusedField = nil
                            viewModel.processLink()
                        }) {
                            Text(LocalizableStrings.InstructionsBView.processLinkButtonLabel)
                                .bold()
                        }
                        .buttonStyle(PillButtonStyle())
                        .disabled(viewModel.linkInput.isEmpty)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .alert(isPresented: $viewModel.displayAlert) {
                        Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text(LocalizableStrings.ok)))
                    }
                    
                    Spacer()
                }
            }
            
            if viewModel.isShowingProcessingView {
                ProcessingView(message: $viewModel.processingViewMessage)
                    .padding(.bottom)
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
        PasteLinkView(estaSendoExibido: .constant(true), podcastToAutoOpenAfterAdd: .constant(0))
    }

}
