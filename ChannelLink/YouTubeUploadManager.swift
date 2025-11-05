import Foundation
import AVFoundation

class YouTubeUploadManager: NSObject, ObservableObject {
    @Published var uploadProgress: Double = 0
    @Published var isUploading = false
    @Published var uploadError: String?
    @Published var uploadedVideoURL: String?

    private var uploadTask: URLSessionUploadTask?

    func uploadVideo(
        videoURL: URL,
        metadata: GeminiService.VideoMetadata,
        isPublic: Bool,
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        DispatchQueue.main.async {
            self.isUploading = true
            self.uploadProgress = 0
            self.uploadError = nil
            self.uploadedVideoURL = nil
        }

        // Step 1: Initialize upload with metadata
        initializeUpload(
            metadata: metadata,
            isPublic: isPublic,
            accessToken: accessToken
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let uploadURL):
                // Step 2: Upload video file
                self.uploadVideoFile(
                    videoURL: videoURL,
                    uploadURL: uploadURL,
                    accessToken: accessToken,
                    completion: completion
                )

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isUploading = false
                    self.uploadError = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    private func initializeUpload(
        metadata: GeminiService.VideoMetadata,
        isPublic: Bool,
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let privacyStatus = isPublic ? "public" : "private"

        let requestBody: [String: Any] = [
            "snippet": [
                "title": metadata.title,
                "description": metadata.description,
                "tags": metadata.tags,
                "categoryId": "22" // 22 = People & Blogs
            ],
            "status": [
                "privacyStatus": privacyStatus,
                "selfDeclaredMadeForKids": false
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody),
              let url = URL(string: "https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status") else {
            completion(.failure(NSError(domain: "YouTubeUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let uploadURL = httpResponse.value(forHTTPHeaderField: "Location") else {
                completion(.failure(NSError(domain: "YouTubeUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get upload URL"])))
                return
            }

            completion(.success(uploadURL))
        }.resume()
    }

    private func uploadVideoFile(
        videoURL: URL,
        uploadURL: String,
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: uploadURL) else {
            completion(.failure(NSError(domain: "YouTubeUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid upload URL"])))
            return
        }

        // Get file size
        guard let fileAttributes = try? FileManager.default.attributesOfItem(atPath: videoURL.path),
              let fileSize = fileAttributes[.size] as? NSNumber else {
            completion(.failure(NSError(domain: "YouTubeUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get file size"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("video/*", forHTTPHeaderField: "Content-Type")
        request.setValue(fileSize.stringValue, forHTTPHeaderField: "Content-Length")

        // Create upload task with progress tracking
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        uploadTask = session.uploadTask(with: request, fromFile: videoURL) { [weak self] data, response, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isUploading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.uploadError = error.localizedDescription
                }
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let videoId = json["id"] as? String else {
                DispatchQueue.main.async {
                    self.uploadError = "Failed to parse video ID from response"
                }
                completion(.failure(NSError(domain: "YouTubeUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse video ID"])))
                return
            }

            let videoURL = "https://www.youtube.com/watch?v=\(videoId)"

            DispatchQueue.main.async {
                self.uploadedVideoURL = videoURL
            }

            completion(.success(videoURL))
        }

        uploadTask?.resume()
    }

    func cancelUpload() {
        uploadTask?.cancel()

        DispatchQueue.main.async {
            self.isUploading = false
            self.uploadProgress = 0
        }
    }
}

extension YouTubeUploadManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)

        DispatchQueue.main.async {
            self.uploadProgress = progress
        }
    }
}
