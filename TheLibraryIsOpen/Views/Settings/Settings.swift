import SwiftUI

struct Settings: View {
    
    @State var displayHowToGetLinkInstructions: Bool = false
    
    @State private var addingBehaviorSelectedOption = LocalizableStrings.Settings.AddPodcast.WhenAdding.previewFirstOption
    let addingBehaviors = [LocalizableStrings.Settings.AddPodcast.WhenAdding.previewFirstOption,
                           LocalizableStrings.Settings.AddPodcast.WhenAdding.justAddToArchiveOption,
                           LocalizableStrings.Settings.AddPodcast.WhenAdding.addAndDownloadAllEpisodesOption]
    
    @State private var podcastRowBehaviorSelectedOption = "Exibir quantidade de episódios"
    let podcastRowBehaviors = ["Exibir quantidade de episódios", "Exibir espaço ocupado"]
    
    @State var displayArtworkInArchive: Bool = true
    
    @State private var defaultCloudProviderSelectedOption = "Nenhum"
    let defaultCloudProviderOptions = ["Nenhum", "Arquivo & iCloud Drive", "Google Drive", "Dropbox", "OneDrive"]
    
    @State var showingTipJarThankYouAlert: Bool = false

    var body: some View {
        Form {
            Section(LocalizableStrings.Settings.AddPodcast.sectionHeader) {
                Toggle(LocalizableStrings.Settings.AddPodcast.skipGetLinkInstructions, isOn: $displayHowToGetLinkInstructions)
                
                Picker(LocalizableStrings.Settings.AddPodcast.WhenAdding.optionLabel, selection: $addingBehaviorSelectedOption) {
                    ForEach(addingBehaviors, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section("Arquivo") {
                Picker("No podcast", selection: $podcastRowBehaviorSelectedOption) {
                    ForEach(podcastRowBehaviors, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section {
                Picker("Exportar diretamente para", selection: $defaultCloudProviderSelectedOption) {
                    ForEach(defaultCloudProviderOptions, id: \.self) {
                        Text($0)
                    }
                }
                
                Toggle(LocalizableStrings.Settings.ArchivedPodcast.displayEpisodeArtworkOption, isOn: $displayArtworkInArchive)
            } header: {
                Text(LocalizableStrings.Settings.ArchivedPodcast.sectionHeader)
            } footer: {
                Text(LocalizableStrings.Settings.ArchivedPodcast.sectionFooter)
            }
            
            Section {
                Button("❤️  Generous $5 tip") {
                    showingTipJarThankYouAlert = true
                }
                .alert(isPresented: $showingTipJarThankYouAlert) {
                    Alert(title: Text("And She Is the Moment"), message: Text("Thank you so much for your support."), dismissButton: .default(Text("OK")))
                }
            } header: {
                Text(LocalizableStrings.Settings.TipJar.sectionHeader)
            } footer: {
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
