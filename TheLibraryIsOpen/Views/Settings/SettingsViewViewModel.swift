import Combine

class SettingsViewViewModel: ObservableObject {
    
    @Published var displayHowToGetLinkInstructions: Bool
    @Published var addingBehaviorSelectedOption: String
    
    @Published var displayDeveloperOptions: Bool
    
    init() {
        displayHowToGetLinkInstructions = UserSettings.getSkipGetLinkInstructions()
        addingBehaviorSelectedOption = UserSettings.getAddingBehaviorSelectedOption()
        
        displayDeveloperOptions = CommandLine.arguments.contains("-DISPLAY_DEV_OPTIONS_IN_SETTINGS")
    }
    
}
