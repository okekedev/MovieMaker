import Foundation
import AuthenticationServices

class YouTubeAuthManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var accessToken: String?
    @Published var userEmail: String?

    private let clientID = "880243579911-95788vph5je6vjm2rnhvnqo8n6lk31gm.apps.googleusercontent.com"
    private let redirectURI = "com.googleusercontent.apps.880243579911-95788vph5je6vjm2rnhvnqo8n6lk31gm:/oauth2redirect"
    private let scope = "https://www.googleapis.com/auth/youtube.upload https://www.googleapis.com/auth/userinfo.email"

    private var webAuthSession: ASWebAuthenticationSession?

    func signIn(presentationAnchor: ASPresentationAnchor, completion: @escaping (Bool, Error?) -> Void) {
        let state = UUID().uuidString

        var components = URLComponents(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "state", value: state)
        ]

        guard let authURL = components.url else {
            completion(false, NSError(domain: "YouTubeAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid auth URL"]))
            return
        }

        webAuthSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "com.googleusercontent.apps.880243579911-95788vph5je6vjm2rnhvnqo8n6lk31gm") { [weak self] callbackURL, error in
            guard let self = self else { return }

            if let error = error {
                completion(false, error)
                return
            }

            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                completion(false, NSError(domain: "YouTubeAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authorization code"]))
                return
            }

            self.exchangeCodeForToken(code: code, completion: completion)
        }

        webAuthSession?.presentationContextProvider = self
        webAuthSession?.prefersEphemeralWebBrowserSession = false
        webAuthSession?.start()
    }

    private func exchangeCodeForToken(code: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://oauth2.googleapis.com/token")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "code": code,
            "client_id": clientID,
            "redirect_uri": redirectURI,
            "grant_type": "authorization_code"
        ]

        request.httpBody = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let accessToken = json["access_token"] as? String else {
                DispatchQueue.main.async {
                    completion(false, NSError(domain: "YouTubeAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get access token"]))
                }
                return
            }

            DispatchQueue.main.async {
                self.accessToken = accessToken
                self.isAuthenticated = true
                self.fetchUserEmail()
                completion(true, nil)
            }
        }.resume()
    }

    private func fetchUserEmail() {
        guard let accessToken = accessToken else { return }

        var request = URLRequest(url: URL(string: "https://www.googleapis.com/oauth2/v2/userinfo")!)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let email = json["email"] as? String else {
                return
            }

            DispatchQueue.main.async {
                self?.userEmail = email
            }
        }.resume()
    }

    func signOut() {
        accessToken = nil
        isAuthenticated = false
        userEmail = nil
    }
}

extension YouTubeAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window
        }
        return ASPresentationAnchor()
    }
}
