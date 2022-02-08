import SwiftUI

let isRunningUnitTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

let dataManager = DataManager(database: isRunningUnitTests ? nil : LocalDatabase())

@main
struct TheLibraryIsOpenApp: App {
    
    init() {
        if CommandLine.arguments.contains("-CLEAN_DATABASE_AND_STORAGE_UPON_LAUNCH") {
            dataManager.cleanUpDatabase()
            InternalStorage.cleanUp()
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

}
