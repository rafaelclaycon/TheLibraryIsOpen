//
//  MainView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 27/11/20.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewViewModel()
    
    var body: some View {
        let navBarItemSize: CGFloat = 36
        
        NavigationView {
            VStack {
                Image(systemName: "headphones")
                    .font(.system(size: 46))
                    .foregroundColor(.pink)
                
                Text("Nenhum Podcast Arquivado")
                    .font(.title2)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text("Para arquivar um novo podcast, toque no + no canto superior direito.")
                    .font(.body)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .navigationBarItems(trailing:
                Button(action: {
                    print("Adicionar podcast pressionado!")
                    viewModel.exibindoSheetNovoPodcast = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .frame(width: 32, height: 32, alignment: .center)
                }
                .frame(width: navBarItemSize, height: navBarItemSize, alignment: .center)
            )
            .navigationBarTitle(Text("Arquivo"))
        }
        .sheet(isPresented: $viewModel.exibindoSheetNovoPodcast) {
            InstrucoesAView(viewModel: InstrucoesAViewModel(), estaSendoExibido: $viewModel.exibindoSheetNovoPodcast)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
