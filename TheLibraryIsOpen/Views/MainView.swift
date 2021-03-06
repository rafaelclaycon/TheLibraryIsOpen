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
            NowPlayingBar(content: PodcastList()).tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Novo Podcast")
            }

            NowPlayingBar(content: FilterView()).tabItem {
                Image(systemName: "archivebox.fill")
                Text("Arquivados")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
