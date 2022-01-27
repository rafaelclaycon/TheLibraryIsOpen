import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewViewModel()
    
    let addingBehaviors = [LocalizableStrings.SettingsView.AddPodcast.WhenAdding.previewFirstOption,
                           LocalizableStrings.SettingsView.AddPodcast.WhenAdding.justAddToArchiveOption,
                           LocalizableStrings.SettingsView.AddPodcast.WhenAdding.addAndDownloadAllEpisodesOption]
    
    @State private var podcastRowBehaviorSelectedOption = "Exibir quantidade de episódios"
    let podcastRowBehaviors = ["Exibir quantidade de episódios", "Exibir espaço ocupado"]
    
    @State var displayArtworkInArchive: Bool = true
    
    @State private var defaultCloudProviderSelectedOption = "Nenhum"
    let defaultCloudProviderOptions = ["Nenhum", "Arquivo & iCloud Drive", "Google Drive", "Dropbox", "OneDrive"]
    
    @State var showingTipJarThankYouAlert: Bool = false

    var body: some View {
        Form {
            Section(LocalizableStrings.SettingsView.AddPodcast.sectionHeader) {
                Toggle(LocalizableStrings.SettingsView.AddPodcast.skipGetLinkInstructions, isOn: $viewModel.displayHowToGetLinkInstructions)
                    .onChange(of: viewModel.displayHowToGetLinkInstructions) { newValue in
                        UserSettings.setSkipGetLinkInstructions(to: newValue)
                    }
                
                Picker(LocalizableStrings.SettingsView.AddPodcast.WhenAdding.optionLabel, selection: $viewModel.addingBehaviorSelectedOption) {
                    ForEach(addingBehaviors, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: viewModel.addingBehaviorSelectedOption) { newValue in
                    UserSettings.setAddingBehaviorSelectedOption(to: viewModel.addingBehaviorSelectedOption)
                }
            }
            
            /*Section("Arquivo") {
                Picker("No podcast", selection: $podcastRowBehaviorSelectedOption) {
                    ForEach(podcastRowBehaviors, id: \.self) {
                        Text($0)
                    }
                }
            }*/
            
            Section {
                /*Picker("Exportar diretamente para", selection: $defaultCloudProviderSelectedOption) {
                    ForEach(defaultCloudProviderOptions, id: \.self) {
                        Text($0)
                    }
                }*/
                
                Toggle(LocalizableStrings.SettingsView.ArchivedPodcast.displayEpisodeArtworkOption, isOn: $displayArtworkInArchive)
            } header: {
                Text(LocalizableStrings.SettingsView.ArchivedPodcast.sectionHeader)
            } footer: {
                Text(LocalizableStrings.SettingsView.ArchivedPodcast.sectionFooter)
            }
            
            Section {
                Button("❤️  Generous $5 tip") {
                    showingTipJarThankYouAlert = true
                }
                .alert(isPresented: $showingTipJarThankYouAlert) {
                    Alert(title: Text("And She Is the Moment"), message: Text("Thank you so much for your support."), dismissButton: .default(Text(LocalizableStrings.ok)))
                }
            } header: {
                Text(LocalizableStrings.SettingsView.TipJar.sectionHeader)
            }
            
            Section {
                Text("Put my picture here")
            } header: {
                Text("About")
            }
            
            Section {
                Button(LocalizableStrings.SettingsView.Feedback.reportABugButtonLabel) {
                    print("Bug report")
                }
                Button(LocalizableStrings.SettingsView.Feedback.reportATranslationErrorButtonLabel) {
                    print("Translation error")
                }
            } header: {
                Text(LocalizableStrings.SettingsView.Feedback.sectionHeader)
            } footer: {
                Text(LocalizableStrings.SettingsView.Feedback.sectionFooter)
            }
            
            if viewModel.displayDeveloperOptions {
                Section {
                    Button("Clear UserDefaults") {
                        UserSettings.restoreDefaults()
                    }
                } header: {
                    Text("Developer options")
                } footer: {
                    EmptyView()
                }
            }
        }
        .navigationTitle(LocalizableStrings.SettingsView.title)
    }

}

struct Settings_Previews: PreviewProvider {

    static var previews: some View {
        SettingsView()
    }

}
