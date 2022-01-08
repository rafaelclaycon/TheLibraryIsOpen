import SwiftUI

let isRunningUnitTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

let dataManager = DataManager(storage: isRunningUnitTests ? nil : LocalStorage(), fetchMethod: TheLibraryIsOpenService.getPodcasts)

@main
struct TheLibraryIsOpenApp: App {
    
    init() {
        dataManager.cleanUpDatabase()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

}
