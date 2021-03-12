//
//  ContentView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import SwiftUI

struct InstrucoesAView: View {
    @ObservedObject var viewModel = InstrucoesAViewModel()
    
    let bottomPadding: CGFloat = 15

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Obter Episódios de Um Novo Podcast")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    
                    Image("podcasts")
                        .resizable()
                        .frame(width: 365, height: 205)
                    
                    Spacer()
                }
                
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
                .padding(.all, 30)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        //viewModel.processar()
                    }) {
                        Text("Avançar")
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InstrucoesAView()
    }
}
