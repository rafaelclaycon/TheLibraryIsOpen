//
//  ContentView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import SwiftUI

struct NovoPodcastView: View {
    @ObservedObject var viewModel = NovoPodcastViewModel(podcasts: isRunningUnitTests ? nil : dataManager.podcasts)

    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Para começar,")
                        .padding(.bottom, 20)
                    
                    Text("1. Abra o app Podcasts")
                        .bold()
                        .foregroundColor(.purple)
                        .padding(.bottom, 20)
                    
                    Text("2. navegue até o podcast que deseja arquivar")
                        .bold()
                        .foregroundColor(.purple)
                        .padding(.bottom, 20)
                    
                    Text("3. toque no botão ...")
                        .bold()
                        .foregroundColor(.purple)
                        .padding(.bottom, 20)
                    
                    Text("4. toque na opção Copiar Link")
                        .bold()
                        .foregroundColor(.purple)
                        .padding(.bottom, 20)
                    
                    Text("5. volte para cá e cole o link no campo abaixo")
                        .bold()
                        .foregroundColor(.pink)
                        .padding(.bottom, 20)
                    
                    Text("6. toque em Inspecionar Link.")
                        .bold()
                        .foregroundColor(.pink)
                        .padding(.bottom, 20)
                    
                    Text("Cole o link aqui:")
                    
                    TextField("https://...", text: $viewModel.entrada)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            //
                        }) {
                            Text("Inspecionar Link")
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle(Text("Extrair Episódios ⛏"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NovoPodcastView()
    }
}
