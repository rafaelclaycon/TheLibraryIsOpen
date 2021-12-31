import SwiftUI

let isRunningUnitTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

let dataManager = DataManager(storage: isRunningUnitTests ? nil : LocalStorage(), fetchMethod: TheLibraryIsOpenService.getPodcasts)

@main
struct TheLibraryIsOpenApp: App {

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }

}

extension UIApplication {

    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }

}

extension UIApplication: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }

}
