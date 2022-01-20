import SwiftUI

struct GetLinkInstructionsView: View {

    @Binding var isShowingModal: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    @State private var action: Int? = 0
    @State var selectedOption: PodcastPlayer
    let actualInstructions: Set<PodcastPlayerType> = PodcastPlayerFactory.getActualInstructions()
    var imageName: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.imageName
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.imageName
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.imageName
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.imageName
            }
        }
    }
    var step1: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step1
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step1
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step1
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step1
            }
        }
    }
    var step2: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step2
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step2
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step2
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step2
            }
        }
    }
    var step3: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step3
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step3
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step3
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step3
            }
        }
    }
    var step4: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step4
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step4
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step4
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step4
            }
        }
    }
    var step5: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step5
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step5
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step5
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step5
            }
        }
    }
    var step6: String {
        get {
            switch selectedOption.type {
            case .castro:
                return LocalizableStrings.InstructionsAView.Castro.step6
            case .overcast:
                return LocalizableStrings.InstructionsAView.Overcast.step6
            case .pocketCasts:
                return LocalizableStrings.InstructionsAView.PocketCasts.step6
            default:
                return LocalizableStrings.InstructionsAView.ApplePodcasts.step6
            }
        }
    }
    
    let bottomPadding: CGFloat = 15

    var body: some View {
        if actualInstructions.contains(selectedOption.type) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(LocalizableStrings.InstructionsAView.generalExplanationText)
                        .padding(.horizontal, 30)
                        .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        
                        Image(imageName)
                            .resizable()
                            .frame(width: 350, height: 197)
                        
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    
                    VStack(alignment: .leading) {
                        Text(step1)
                            .padding(.bottom, bottomPadding)
                        
                        Text(step2)
                            .padding(.bottom, bottomPadding)
                        
                        Text(step3)
                            .padding(.bottom, bottomPadding)
                        
                        Text(step4)
                            .padding(.bottom, bottomPadding)
                        
                        Text(step5)
                            .padding(.bottom, bottomPadding)
                        
                        Text(step6)
                            .padding(.bottom, bottomPadding)
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: PasteLinkView(estaSendoExibido: $isShowingModal, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd), tag: 1, selection: $action, label: {
                            Text(LocalizableStrings.InstructionsAView.nextButtonLabel)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 50)
                                .background(Color.accentColor)
                                .cornerRadius(50)
                        })
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    Spacer()
                }
                .navigationBarTitle(Text(LocalizableStrings.InstructionsAView.title))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.isShowingModal = false
                    }) {
                        Text(LocalizableStrings.cancel)
                    }
                )
            }
        } else {
            UnfortunatelyView(selectedOption: selectedOption, isShowingModal: $isShowingModal)
        }
    }

}

struct ContentView_Previews: PreviewProvider {

    // iPod touch (7th generation)
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            GetLinkInstructionsView(isShowingModal: .constant(true), podcastToAutoOpenAfterAdd: .constant(0), selectedOption: PodcastPlayer(id: 6, name: "Orelo", iconName: "orelo_icon", type: .orelo))
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }

}