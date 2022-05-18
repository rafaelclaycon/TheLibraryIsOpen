import Combine

class SettingsViewViewModel: ObservableObject {
    
    @Published var displayHowToGetLinkInstructions: Bool
    @Published var addingBehaviorSelectedOption: String
    
    @Published var displayPrivateFolder: Bool
    @Published var displayArtworkInArchive: Bool = true
    
    @Published var displayDeveloperOptions: Bool
    
    init() {
        displayHowToGetLinkInstructions = UserSettings.getSkipGetLinkInstructions()
        addingBehaviorSelectedOption = UserSettings.getAddingBehaviorSelectedOption()
        displayPrivateFolder = UserSettings.getDisplayPrivateFolder()
        displayArtworkInArchive = UserSettings.getDisplayArtworkInArchiveOption()
        
        displayDeveloperOptions = CommandLine.arguments.contains("-DISPLAY_DEV_OPTIONS_IN_SETTINGS")
    }
    
}
