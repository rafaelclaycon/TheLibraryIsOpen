import Foundation

class UserSettings {
    
    // MARK: - Getters
    
    static func getSkipGetLinkInstructions() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let value = userDefaults.object(forKey: "skipGetLinkInstructions") else {
            return false
        }
        return Bool(value as! Bool)
    }
    
    static func getAddingBehaviorSelectedOption() -> String {
        let userDefaults = UserDefaults.standard
        guard let value = userDefaults.object(forKey: "addingBehaviorSelectedOption") else {
            return LocalizableStrings.Settings.AddPodcast.WhenAdding.previewFirstOption
        }
        return String(value as! String)
    }
    
    static func getArchiveSortOption() -> Int {
        let userDefaults = UserDefaults.standard
        guard let value = userDefaults.object(forKey: "archiveSortOption") else {
            return 0
        }
        return Int(value as! Int)
    }
    
    static func getArchiveRowAdditionalInfoToShowOption() -> Int {
        let userDefaults = UserDefaults.standard
        guard let value = userDefaults.object(forKey: "archiveRowAdditionalInfoToShowOption") else {
            return 0
        }
        return Int(value as! Int)
    }
    
    // MARK: - Setters
    
    static func setSkipGetLinkInstructions(to newValue: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(newValue, forKey: "skipGetLinkInstructions")
    }
    
    static func setAddingBehaviorSelectedOption(to newValue: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(newValue, forKey: "addingBehaviorSelectedOption")
    }
    
    static func setArchiveSortOption(to newValue: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(newValue, forKey: "archiveSortOption")
    }
    
    static func setArchiveRowAdditionalInfoToShowOption(to newValue: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(newValue, forKey: "archiveRowAdditionalInfoToShowOption")
    }
    
    // MARK: - Developer options
    
    static func restoreDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
}
