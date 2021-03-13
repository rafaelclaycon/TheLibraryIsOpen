//
//  ContentView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import SwiftUI

struct InstrucoesAView: View {
    @ObservedObject var viewModel = InstrucoesAViewModel()
    @Binding var estaSendoExibido: Bool
    @State private var action: Int? = 0
    
    let bottomPadding: CGFloat = 15

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Image("podcasts")
                        .resizable()
                        .frame(width: 350, height: 197)
                    
                    Spacer()
                }
                .padding(.vertical, 30)
                
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
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: InstrucoesBView(estaSendoExibido: $estaSendoExibido), tag: 1, selection: $action, label: {
                        Text("Avançar")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InstrucoesAView(estaSendoExibido: .constant(true))
    }
}
