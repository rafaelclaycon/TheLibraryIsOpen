import SwiftUI

struct InstrucoesAView: View {

    @StateObject var viewModel = InstrucoesAViewModel()
    @Binding var estaSendoExibido: Bool
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
                            Text("1. Abra o app Podcasts")
                                .padding(.bottom, bottomPadding)
                            
                            Text("2. Navegue até o podcast que deseja arquivar")
                                .padding(.bottom, bottomPadding)
                            
                            Text("3. Toque no botão ...")
                                .padding(.bottom, bottomPadding)
                            
                            Text("4. Toque na opção Copiar Link")
                                .padding(.bottom, bottomPadding)
                            
                            Text("5. Volte para cá e toque em Avançar.")
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
                            Text("1. Abra o app Pocket Casts")
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
                        
                        NavigationLink(destination: InstrucoesBView(estaSendoExibido: $estaSendoExibido), tag: 1, selection: $action, label: {
                            Text("Avançar")
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
                .navigationBarTitle(Text("Obter Link"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.estaSendoExibido = false
                    }) {
                        Text("Cancelar")
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
            InstrucoesAView(estaSendoExibido: .constant(true))
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }

}
