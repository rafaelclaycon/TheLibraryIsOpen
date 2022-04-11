import SwiftUI

struct GetLinkView: View {

    @StateObject var viewModel = GetLinkViewViewModel()
    @Binding var isBeingShown: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    NavigationLink(destination: PodcastPreview(viewModel: viewModel.podcastDetailViewModel, isShowingAddPodcastModal: $isBeingShown, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd), isActive: $viewModel.isShowingPodcastPreview) { EmptyView() }
                    
                    BreathingOrb(link: $viewModel.pasteboardContents)
                        .padding(.vertical)
                        //.scaleEffect(animationAmount)
                        //.animation(.default, value: animationAmount)
                    
//                    Text("Looking for podcast link in pasteboard...")
//                        .font(.subheadline)
                    
                    Text("Copy the podcast link, come back here and press the button below.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button(LocalizableStrings.PasteLinkView.lookForLinkButtonLabel, action: {
                        viewModel.inspectPasteboard()
                        //animationAmount += 0.1
                    })
                    .tint(.accentColor)
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Spacer()
                }
                .navigationBarTitle(Text(LocalizableStrings.PasteLinkView.title))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.isBeingShown = false
                    }) {
                        Text(LocalizableStrings.cancel)
                    }
                )
            }
            
            if viewModel.isShowingProcessingView {
                ProcessingView(message: $viewModel.processingViewMessage)
                    .padding(.bottom)
            }
        }
    }

}

struct InstrucoesLinkView_Previews: PreviewProvider {

    static var previews: some View {
        GetLinkView(isBeingShown: .constant(true), podcastToAutoOpenAfterAdd: .constant(0))
    }

}
