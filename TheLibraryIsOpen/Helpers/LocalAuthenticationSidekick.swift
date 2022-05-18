import Foundation
import LocalAuthentication

public class LocalAuthenticationSidekick {
    
    private let context: LAContext
    
    init(context: LAContext = LAContext()) {
        self.context = context
    }

    func authenticated(reasonToAuthenticate: String, completionHandler: @escaping (Bool) -> Void) {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = reasonToAuthenticate
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        } else {
            completionHandler(false)
        }
    }

}
