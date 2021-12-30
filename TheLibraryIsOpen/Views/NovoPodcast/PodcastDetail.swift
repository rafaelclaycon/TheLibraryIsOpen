//
//  PodcastDetail.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import KingfisherSwiftUI
import SwiftUI

struct PodcastDetail: View {
    @ObservedObject var viewModel: PodcastDetailViewModel
    @State private var indicePagina = 0

    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: viewModel.artworkURL))
                    .onSuccess { r in
                        print("success: \(r)")
                    }
                    .onFailure { e in
                        print("failure: \(e)")
                    }
                    .placeholder {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 70, height: 70)
                                .opacity(0.5)

                            Image(systemName: "waveform")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                    }
                    .resizable()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.title3)
                        .bold()
                    Text(viewModel.details)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
                .padding(.leading, 15)
            }
            .padding(.horizontal, 15)
            
            Picker(selection: $indicePagina, label: Text("Info")) {
                Text("Lista").tag(0)
                Text("Por ano").tag(1)
            }
            .disabled(viewModel.displayEpisodeList == false)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            
            Divider()

            // List
            if viewModel.displayEpisodeList {
                if indicePagina == 0 {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode))
                                    .padding(.vertical, 5)
                            }
                        }
                    }//.padding(.top, 25)
                } else if indicePagina == 1 {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.episodes, id: \.id) { episode in
                                EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode))
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Nenhum Episódio")
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            Divider()
                .padding(.bottom, 5)
            
            Button(action: {
                viewModel.downloadAll()
            }) {
                Text(viewModel.downloadAllButtonTitle)
                    .bold()
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(30)
            .alert(isPresented: $viewModel.displayAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding(.vertical, 5)
            
            /*Text("Você pode baixar todos os episódios neste dispositivo, porém restará menos de 10% do espaço livre atualmente (40,5 GB).")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)*/
        }
    }
}

struct PodcastDetail_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetail(viewModel: PodcastDetailViewModel(podcast: Podcast(id: 1, titulo: "Um Milkshake Chamado Wanda", autor: "PAPELPOP", episodios: nil, urlFeed: "", urlCapa: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")))
    }
}
