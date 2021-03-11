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

    var body: some View {
        VStack(alignment: .center) {
            // Header
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
                .frame(width: 170, height: 170)
                .cornerRadius(8.0)
            
            Text(viewModel.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.top, 12)
            
            Text(viewModel.details)
                .foregroundColor(.gray)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.all, 5)
            
            Button(action: {
                viewModel.downloadAll()
            }) {
                Image(systemName: "icloud.and.arrow.down")
                    .font(Font.body.weight(.bold))
                    .padding(.trailing, 4)
                Text("Baixar tudo")
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
            .padding(.vertical, 10)
            
            Divider()
                .padding(.top, 15)

            // List
            if viewModel.displayEpisodeList {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.episodes, id: \.id) { episode in
                            EpisodeRow(viewModel: EpisodeRowViewModel(episode: episode))
                                .padding(.vertical, 5)
                        }
                    }
                }.padding(.top, 25)
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
        }
    }
}

struct PodcastDetail_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetail(viewModel: PodcastDetailViewModel(podcast: Podcast(id: 1, title: "Um Milkshake Chamado Wanda", author: "PAPELPOP", episodes: nil, feedURL: "", artworkURL: "https://i1.sndcdn.com/avatars-l7UAPy4c6vYw4Uzb-zLzBYw-original.jpg")))
    }
}
