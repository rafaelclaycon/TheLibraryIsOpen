import SwiftUI

struct PlayerPickerView: View {
    
    @Binding var isShowingModal: Bool
    @Binding var podcastToAutoOpenAfterAdd: Int?
    @State var selectedOption: Int?
    let options = PodcastPlayerFactory.getPlayers()

    var body: some View {
        NavigationView {
            VStack {
                Text("What podcast player do you use?")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                List(options) { option in
                    NavigationLink(destination: InstructionsAView(isShowingModal: $isShowingModal, podcastToAutoOpenAfterAdd: $podcastToAutoOpenAfterAdd, selectedOption: option),
                                   tag: option.id,
                                   selection: $selectedOption,
                                   label: {
                        Button {
                            selectedOption = option.id
                        } label: {
                            HStack(spacing: 20) {
                                if option.iconName != nil {
                                    Image(option.iconName!)
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 7)
                                        }
                                } else {
                                    Image(systemName: "questionmark")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 10)
                                }
                                
                                Text(option.name)
                            }
                        }
                    })
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingModal = false
                    }) {
                        Text(LocalizableStrings.cancel)
                    }
                )
            }
        }
    }

}

struct ChooseYourPlayerView_Previews: PreviewProvider {

    static var previews: some View {
        PlayerPickerView(isShowingModal: .constant(true), podcastToAutoOpenAfterAdd: .constant(nil))
    }

}
