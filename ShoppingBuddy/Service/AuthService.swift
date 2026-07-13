import Foundation
import FirebaseAuth

@Observable @MainActor
final class AuthService {
    var userId: String?
    var isAuthenticated: Bool = false
    
    init() {
        self.userId = Auth.auth().currentUser?.uid
        self.isAuthenticated = self.userId != nil
    }
    
    /// Autentica de forma anônima caso o usuário ainda não tenha um ID
    func signInAnonymouslyIfNeeded() async {
        if Auth.auth().currentUser != nil {
            self.userId = Auth.auth().currentUser?.uid
            self.isAuthenticated = true
            return
        }
        
        do {
            let result = try await Auth.auth().signInAnonymously()
            self.userId = result.user.uid
            self.isAuthenticated = true
            print("Usuário autenticado anonimamente com sucesso: \(result.user.uid)")
        } catch {
            print("Erro ao tentar autenticação anônima: \(error.localizedDescription)")
        }
    }
}
