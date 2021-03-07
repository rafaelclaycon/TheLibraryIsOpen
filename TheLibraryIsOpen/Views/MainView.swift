//
//  MainView.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 27/11/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NowPlayingBar(content: InstrucoesView()).tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Novo Podcast")
            }

            NowPlayingBar(content: ArquivoView()).tabItem {
                Image(systemName: "archivebox.fill")
                Text("Arquivo")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
