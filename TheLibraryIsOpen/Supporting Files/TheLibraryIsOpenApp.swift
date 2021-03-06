//
//  TheLibraryIsOpenApp.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import SwiftUI

let isRunningUnitTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

let dataManager = DataManager(storage: isRunningUnitTests ? nil : LocalStorage(), fetchMethod: TheLibraryIsOpenService.getPodcasts)
var player: Player?

@main
struct TheLibraryIsOpenApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
