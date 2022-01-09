import SwiftUI

struct InstructionsAView: View {

    @Binding var isShowingModal: Bool
    @State private var action: Int? = 0
    @State private var indicePagina = 0
    
    let bottomPadding: CGFloat = 15

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
//                    Picker(selection: $indicePagina, label: Text("Info")) {
//                        Text("Apple Podcasts").tag(0)
//                        Text("Pocket Casts").tag(1)
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(.horizontal, 25)
//                    .padding(.top, 7)
                    
                    if indicePagina == 0 {
                        HStack {
                            Spacer()
                            
                            Image("podcasts")
                                .resizable()
                                .frame(width: 350, height: 197)
                            
                            Spacer()
                        }
                        .padding(.vertical, 15)
                        
                        VStack(alignment: .leading) {
                            Text("1. Open the Podcasts app")
                                .padding(.bottom, bottomPadding)
                            
                            Text("2. Find the podcast you want to archive")
                                .padding(.bottom, bottomPadding)
                            
                            Text("3. Tap the ... button on the top left of the show page")
                                .padding(.bottom, bottomPadding)
                            
                            Text("4. Tap Copy Link")
                                .padding(.bottom, bottomPadding)
                            
                            Text("5. Come back here and tap Next.")
                                .padding(.bottom, bottomPadding)
                        }
                        .padding(.horizontal, 30)
                    } else {
                        HStack {
                            Spacer()
                            
                            Image("pocket_casts_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 197)
                            
                            Spacer()
                        }
                        .padding(.vertical, 15)
                        
                        VStack(alignment: .leading) {
                            Text("1. Open the Pocket Casts app")
                                .padding(.bottom, bottomPadding)
                            
                            Text("2. Navegue até o podcast que deseja arquivar")
                                .padding(.bottom, bottomPadding)
                            
                            Text("3. Toque no botão com uma seta para cima")
                                .padding(.bottom, bottomPadding)
                            
                            Text("4. Toque em Copiar")
                                .padding(.bottom, bottomPadding)
                            
                            Text("5. Volte para cá e toque em Avançar.")
                                .padding(.bottom, bottomPadding)
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: InstructionsBView(estaSendoExibido: $isShowingModal), tag: 1, selection: $action, label: {
                            Text("Next")
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
                .navigationBarTitle(Text("Get Link"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingModal = false
                    }) {
                        Text("Cancel")
                    }
                )
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {

    // iPod touch (7th generation)
    static var previews: some View {
        ForEach(["iPhone 12"], id: \.self) { deviceName in
            InstructionsAView(isShowingModal: .constant(true))
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }

}
