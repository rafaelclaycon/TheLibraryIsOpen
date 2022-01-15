import SwiftUI

struct Settings: View {
    
    @State var displayArtworkInArchive: Bool = true
    @State private var addingBehaviorSelectedOption = LocalizableStrings.Settings.AddPodcast.whenAddingPreviewFirstOption
    let addingBehaviors = [LocalizableStrings.Settings.AddPodcast.whenAddingPreviewFirstOption,
                           LocalizableStrings.Settings.AddPodcast.whenAddingJustAddToArchiveOption,
                           LocalizableStrings.Settings.AddPodcast.whenAddingAddAndDownloadAllEpisodesOption]

    var body: some View {
        Form {
            Section(LocalizableStrings.Settings.AddPodcast.sectionHeader) {
                Picker(LocalizableStrings.Settings.AddPodcast.whenAddingOptionLabel, selection: $addingBehaviorSelectedOption) {
                    ForEach(addingBehaviors, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section {
                Toggle(LocalizableStrings.Settings.ArchivedPodcast.displayEpisodeArtworkOption, isOn: $displayArtworkInArchive)
            } header: {
                Text(LocalizableStrings.Settings.ArchivedPodcast.sectionHeader)
            } footer: {
                Text(LocalizableStrings.Settings.ArchivedPodcast.sectionFooter)
            }
            
            Section {
                Text("And she is the moment")
            } header: {
                Text(LocalizableStrings.Settings.TipJar.sectionHeader)
            } footer: {
                //Text("As capas de episódios serão exibidas quando disponíveis.")
                EmptyView()
            }
            
            Section {
                Button(LocalizableStrings.Settings.Feedback.reportABugButtonLabel) {
                    print("Bug report")
                }
                Button(LocalizableStrings.Settings.Feedback.reportATranslationErrorButtonLabel) {
                    print("Translation error")
                }
            } header: {
                Text(LocalizableStrings.Settings.Feedback.sectionHeader)
            } footer: {
                Text(LocalizableStrings.Settings.Feedback.sectionFooter)
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
