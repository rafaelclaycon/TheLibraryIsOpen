//
//  InstrucoesLinkView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 12/03/21.
//

import SwiftUI

struct InstrucoesBView: View {
    @ObservedObject var viewModel = InstrucoesBViewModel()
    
    var body: some View {
        VStack {
            Text("6. toque em Inspecionar Link.")
                .bold()
                .foregroundColor(.pink)
                .padding(.bottom, 15)
            
            Text("Cole o link aqui:")
            
            TextField("https://...", text: $viewModel.entrada)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Spacer()
                
                Button(action: {
                    //viewModel.processar()
                }) {
                    Text("Inspecionar Link")
                }
                
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}

struct InstrucoesLinkView_Previews: PreviewProvider {
    static var previews: some View {
        InstrucoesBView()
    }
}
