import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewViewModel()
    
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
                Toggle(LocalizableStrings.Settings.AddPodcast.skipGetLinkInstructions, isOn: $viewModel.displayHowToGetLinkInstructions)
                    .onChange(of: viewModel.displayHowToGetLinkInstructions) { newValue in
                        UserSettings.setSkipGetLinkInstructions(to: newValue)
                    }
                
                Picker(LocalizableStrings.Settings.AddPodcast.WhenAdding.optionLabel, selection: $viewModel.addingBehaviorSelectedOption) {
                    ForEach(addingBehaviors, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: viewModel.addingBehaviorSelectedOption) { newValue in
                    UserSettings.setAddingBehaviorSelectedOption(to: viewModel.addingBehaviorSelectedOption)
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
                    Alert(title: Text("And She Is the Moment"), message: Text("Thank you so much for your support."), dismissButton: .default(Text(LocalizableStrings.ok)))
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
        .navigationTitle(LocalizableStrings.Settings.title)
    }

}

struct Settings_Previews: PreviewProvider {

    static var previews: some View {
        SettingsView()
    }

}
