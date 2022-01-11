import SwiftUI

struct Settings: View {
    
    @State var displayArtworkInArchive: Bool = true
    @State private var addingBehaviorSelectedOption = LocalizableStrings.Settings.addPodcastWhenAddingPreviewFirstOption
    let addingBehaviors = [LocalizableStrings.Settings.addPodcastWhenAddingPreviewFirstOption,
                           LocalizableStrings.Settings.addPodcastWhenAddingJustAddToArchiveOption,
                           LocalizableStrings.Settings.addPodcastWhenAddingAddAndDownloadAllEpisodesOption]

    var body: some View {
        Form {
            Section(LocalizableStrings.Settings.addPodcastSectionHeader) {
                Picker(LocalizableStrings.Settings.addPodcastWhenAddingOptionLabel, selection: $addingBehaviorSelectedOption) {
                    ForEach(addingBehaviors, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section {
                Toggle(LocalizableStrings.Settings.archivedPodcastDisplayEpisodeArtworkOption, isOn: $displayArtworkInArchive)
            } header: {
                Text(LocalizableStrings.Settings.archivedPodcastSectionHeader)
            } footer: {
                Text("As capas de episódios serão exibidas quando disponíveis.")
            }
            
            Section {
                Text("And she is the moment")
            } header: {
                Text("Tip jar")
            } footer: {
                //Text("As capas de episódios serão exibidas quando disponíveis.")
                EmptyView()
            }
        }
        .navigationTitle(LocalizableStrings.Settings.title)
    }

}

struct Settings_Previews: PreviewProvider {

    static var previews: some View {
        Settings()
    }

}
