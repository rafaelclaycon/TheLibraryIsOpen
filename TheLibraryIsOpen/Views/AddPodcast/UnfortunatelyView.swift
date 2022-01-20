import SwiftUI

struct UnfortunatelyView: View {
    
    @State var selectedOption: PodcastPlayer
    @Binding var isShowingModal: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    @State var showAlert: Bool = false
    @State var showingGetLinkScreen: Bool = false
    
    let iconSize: CGFloat = 70
    let hollowIconSize: CGFloat = 26
    let applePodcastsPlayer = PodcastPlayerFactory.getApplePodcasts()

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                NavigationLink(destination: GetLinkInstructionsView(isShowingModal: $isShowingModal, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd, selectedOption: applePodcastsPlayer), isActive: $showingGetLinkScreen) { EmptyView() }
                
                Image(selectedOption.iconName!)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .mask {
                        RoundedRectangle(cornerRadius: 14)
                    }
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                
                Text(String(format: LocalizableStrings.UnfortunatelyView.title, selectedOption.name))
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                Text(String(format: LocalizableStrings.UnfortunatelyView.explanation1stParagraph, selectedOption.name))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                Text(LocalizableStrings.UnfortunatelyView.explanation2ndParagraph)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                Text(LocalizableStrings.UnfortunatelyView.explanation3rdParagraph)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
                Button {
                    let podcastAppHook = "pcast://"
                    let podcastAppUrl = URL(string: podcastAppHook)!
                    if UIApplication.shared.canOpenURL(podcastAppUrl) {
                        UIApplication.shared.open(podcastAppUrl)
                        showingGetLinkScreen = true
                    } else {
                        showAlert = true
                    }
                } label: {
                    HStack(spacing: 15) {
                        Image("apple_podcasts_hollow_icon")
                            .resizable()
                            .frame(width: hollowIconSize, height: hollowIconSize)
                        
                        Text(LocalizableStrings.UnfortunatelyView.openApplePodcastsButtonTitle)
                            .bold()
                    }
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .applePodcastsPurple, verticalPadding: 10, horizontalPadding: 40))
                .foregroundColor(.applePodcastsPurple)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(LocalizableStrings.UnfortunatelyView.couldNotOpenPodcastsAppAlertTitle), message: Text(LocalizableStrings.UnfortunatelyView.couldNotOpenPodcastsAppAlertMessage), dismissButton: .default(Text(LocalizableStrings.ok), action: {
                        showingGetLinkScreen = true
                    }))
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.isShowingModal = false
                }) {
                    Text(LocalizableStrings.cancel)
                }
            )
        }
    }

}

struct UnfortunatelyView_Previews: PreviewProvider {

    static var previews: some View {
        UnfortunatelyView(selectedOption: PodcastPlayer(id: 6, name: "Google Podcasts", iconName: "google_podcasts_icon", type: .googlePodcasts), isShowingModal: .constant(true), podcastToAutoOpenAfterAdd: .constant(nil))
    }

}
