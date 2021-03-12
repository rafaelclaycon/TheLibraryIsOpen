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
                //Spacer()
                
                Image(systemName: "headphones")
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                
                Text("Nenhum Podcast Arquivado")
                    .font(.headline)
                    .padding()
                    //.foregroundColor(.gray)
                
                Text("Para arquivar um novo podcast, toque no + no canto superior direito.")
                    .font(.body)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                //Spacer()
            }
            .navigationBarItems(trailing:
                Button(action: {
                    print("Adicionar podcast pressionado!")
                    viewModel.exibindoSheetNovoPodcast = true
                }) {
                    Image(systemName: "plus")
                        .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                        .frame(width: 20, height: 20, alignment: .center)
                }
                .frame(width: navBarItemSize, height: navBarItemSize, alignment: .center)
            )
            .navigationBarTitle(Text("Arquivo"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
