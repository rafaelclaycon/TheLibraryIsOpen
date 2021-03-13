//
//  InstrucoesLinkView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 12/03/21.
//

import SwiftUI

struct InstrucoesBView: View {
    @ObservedObject var viewModel = InstrucoesBViewModel()
    @Binding var estaSendoExibido: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Image("paste")
                        .resizable()
                        .frame(width: 350, height: 197)
                        .border(Color.gray, width: 1)
                    
                    Spacer()
                }
                .padding(.vertical, 30)
                
                Text("6. Cole o link do podcast aqui:")
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                
                TextField("https://...", text: $viewModel.entrada)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 25)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        //viewModel.processar()
                    }) {
                        Text("Analisar Link")
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .navigationBarTitle(Text("Obter Episódios"))
        }
    }
}

struct InstrucoesLinkView_Previews: PreviewProvider {
    static var previews: some View {
        InstrucoesBView(estaSendoExibido: .constant(true))
    }
}
