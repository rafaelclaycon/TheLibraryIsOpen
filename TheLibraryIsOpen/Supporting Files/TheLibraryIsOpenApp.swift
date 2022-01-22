import SwiftUI

let isRunningUnitTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

let dataManager = DataManager(database: isRunningUnitTests ? nil : LocalDatabase(), fetchMethod: TheLibraryIsOpenService.getPodcasts)

@main
struct TheLibraryIsOpenApp: App {
    
    init() {
        if CommandLine.arguments.contains("-CLEAN_DATABASE_UPON_LAUNCH") {
            dataManager.cleanUpDatabase()
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

}
