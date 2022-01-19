import SwiftUI

struct UnfortunatelyView: View {
    
    @State var selectedOption: PodcastPlayer
    @Binding var isShowingModal: Bool
    
    let iconSize: CGFloat = 70
    let hollowIconSize: CGFloat = 26
    let flatButtonVerticalPadding: CGFloat = 12
    //@State private var explanationLevelIndex = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(selectedOption.iconName!)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .mask {
                        RoundedRectangle(cornerRadius: 14)
                    }
                
                Text(String(format: LocalizableStrings.UnfortunatelyView.title, selectedOption.name))
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 15)
                
//                Picker(selection: $explanationLevelIndex, label: Text("Info")) {
//                    Text("Layperson").tag(0)
//                    Text("Nerd explanation").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal, 25)
                
                Text(String(format: LocalizableStrings.UnfortunatelyView.laypersonExplanationFirstParagraph, selectedOption.name))
                    .multilineTextAlignment(.center)
                
                Text(LocalizableStrings.UnfortunatelyView.laypersonExplanationSecondParagraph)
                    .multilineTextAlignment(.center)
                
                Button {
                    print("Use Overcast button pressed!")
                } label: {
                    HStack(spacing: 15) {
                        Image("overcast_hollow_icon")
                            .resizable()
                            .frame(width: hollowIconSize, height: hollowIconSize)
                        
                        Text("Use Overcast")
                            .bold()
                    }
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .overcastOrange, verticalPadding: flatButtonVerticalPadding, horizontalPadding: 50))
                
                Button {
                    print("Use Pocket Casts button pressed!")
                } label: {
                    HStack(spacing: 15) {
                        Image("pocket_casts_hollow_icon")
                            .resizable()
                            .frame(width: hollowIconSize, height: hollowIconSize)
                        
                        Text("Use Pocket Casts")
                            .bold()
                    }
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .pocketCastsRed, verticalPadding: flatButtonVerticalPadding, horizontalPadding: 40))
                
                Button {
                    print("Use Apple Podcasts button pressed!")
                } label: {
                    HStack(spacing: 15) {
                        Image("apple_podcasts_hollow_icon")
                            .resizable()
                            .frame(width: hollowIconSize, height: hollowIconSize)
                        
                        Text("Use Apple Podcasts")
                            .bold()
                    }
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .applePodcastsPurple, verticalPadding: flatButtonVerticalPadding, horizontalPadding: 40))
                .foregroundColor(.applePodcastsPurple)
                
                Button {
                    print("Use Castro button pressed!")
                } label: {
                    HStack(spacing: 15) {
                        Image("castro_hollow_icon")
                            .resizable()
                            .frame(width: hollowIconSize, height: hollowIconSize)
                        
                        Text("Use Castro")
                            .bold()
                    }
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .castroGreen, verticalPadding: flatButtonVerticalPadding, horizontalPadding: 60))
                
                Button {
                    print("TLDR button pressed!")
                } label: {
                    Text(LocalizableStrings.UnfortunatelyView.tldrButtonTitle)
                        .bold()
                }
                .buttonStyle(FlatBackgroundButtonStyle(foregroundColor: .black, verticalPadding: 12, horizontalPadding: 20))
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
        UnfortunatelyView(selectedOption: PodcastPlayer(id: 6, name: "Orelo", iconName: "orelo_icon", type: .orelo), isShowingModal: .constant(true))
    }

}
