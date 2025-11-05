import Foundation
import SwiftUI

class GeminiService: ObservableObject {
    @AppStorage("gemini_api_key") private var apiKey: String = ""

    struct VideoMetadata {
        let title: String
        let description: String
        let tags: [String]
    }

    func generateMetadata(userTitle: String?, videoDescription: String, isPublic: Bool, completion: @escaping (Result<VideoMetadata, Error>) -> Void) {
        let prompt: String

        if let userTitle = userTitle, !userTitle.isEmpty {
            prompt = """
            I have a YouTube video titled "\(userTitle)".
            The video is about: \(videoDescription)

            Please provide:
            1. An SEO-optimized description (200-300 words) with relevant keywords
            2. 10-15 relevant tags for YouTube

            Format your response as JSON:
            {
                "description": "...",
                "tags": ["tag1", "tag2", ...]
            }
            """
        } else {
            prompt = """
            I'm uploading a YouTube video about: \(videoDescription)

            Please provide:
            1. An engaging, SEO-optimized title (under 60 characters)
            2. An SEO-optimized description (200-300 words) with relevant keywords
            3. 10-15 relevant tags for YouTube

            Format your response as JSON:
            {
                "title": "...",
                "description": "...",
                "tags": ["tag1", "tag2", ...]
            }
            """
        }

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody),
              let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "GeminiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let firstCandidate = candidates.first,
                  let content = firstCandidate["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let firstPart = parts.first,
                  let text = firstPart["text"] as? String else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "GeminiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse Gemini response"])))
                }
                return
            }

            let cleanedText = text
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard let jsonData = cleanedText.data(using: .utf8),
                  let metadata = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "GeminiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse metadata JSON"])))
                }
                return
            }

            let finalTitle: String
            if let userTitle = userTitle, !userTitle.isEmpty {
                finalTitle = userTitle
            } else {
                finalTitle = metadata["title"] as? String ?? "Untitled Video"
            }

            let description = metadata["description"] as? String ?? videoDescription
            let tags = metadata["tags"] as? [String] ?? []

            let videoMetadata = VideoMetadata(
                title: finalTitle,
                description: description,
                tags: tags
            )

            DispatchQueue.main.async {
                completion(.success(videoMetadata))
            }
        }.resume()
    }
}
