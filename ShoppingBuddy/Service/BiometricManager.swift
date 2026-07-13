import LocalAuthentication
import Foundation

@Observable @MainActor
final class BiometricManager {
    var isUnlocked: Bool = false
    var errorDescription: String? = nil
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = CommonsStrings.biometricReason.localized
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                Task { @MainActor in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.errorDescription = authenticationError?.localizedDescription ?? CommonsStrings.authenticationFailed.localized
                    }
                }
            }
        } else {
            // If the device does not have biometrics registered or does not support it, unlock automatically.
            self.isUnlocked = true
            self.errorDescription = error?.localizedDescription ?? CommonsStrings.biometricsUnavailable.localized
        }
    }
}
