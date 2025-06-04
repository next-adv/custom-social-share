import Foundation
import Capacitor
import UIKit

@objc(CustomSocialSharePlugin)
public class CustomSocialSharePlugin: CAPPlugin, UIDocumentInteractionControllerDelegate {
    var documentController: UIDocumentInteractionController?

    // MARK: Instagram Sharing
    @objc func shareToInstagramFromUrl(_ call: CAPPluginCall) {
        guard let urlString = call.getString("url"),
              let destination = call.getString("destination"),
              let mediaURL = URL(string: urlString) else {
            call.reject("Missing or invalid URL or destination")
            return
        }

        let contentUrl = call.getString("content_url") // not officially supported on iOS

        downloadMedia(from: mediaURL, filename: "shared_instagram_content") { localURL, uti in
            guard let localURL = localURL else {
                call.reject("Download failed")
                return
            }

            DispatchQueue.main.async {
                self.share(localURL: localURL, uti: uti, destination: destination, app: "instagram", call: call)
            }
        }
    }

    // MARK: Facebook Sharing
    @objc func shareToFacebookFromUrl(_ call: CAPPluginCall) {
        guard let urlString = call.getString("url"),
              let destination = call.getString("destination"),
              let mediaURL = URL(string: urlString) else {
            call.reject("Missing or invalid URL or destination")
            return
        }

        downloadMedia(from: mediaURL, filename: "shared_facebook_content") { localURL, uti in
            guard let localURL = localURL else {
                call.reject("Download failed")
                return
            }

            DispatchQueue.main.async {
                if destination.lowercased() == "story" {
                    self.shareToFacebookStory(localURL: localURL, uti: uti, call: call)
                } else {
                    self.share(localURL: localURL, uti: uti, destination: destination, app: "facebook", call: call)
                }
            }
        }
    }

    // MARK: Media Download
    private func downloadMedia(from url: URL, filename: String, completion: @escaping (URL?, String) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL = tempURL, error == nil else {
                completion(nil, "")
                return
            }

            let ext = url.pathExtension.lowercased()
            let uti = (ext == "mp4") ? "com.apple.quicktime-movie" : "public.jpeg"
            let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(filename).\(ext)")

            do {
                try? FileManager.default.removeItem(at: localURL)
                try FileManager.default.copyItem(at: tempURL, to: localURL)
                completion(localURL, uti)
            } catch {
                completion(nil, "")
            }
        }
        task.resume()
    }

    // MARK: Instagram/Facebook Post Sharing
    private func share(localURL: URL, uti: String, destination: String, app: String, call: CAPPluginCall) {
        documentController = UIDocumentInteractionController(url: localURL)
        documentController?.uti = uti
        documentController?.delegate = self
        documentController?.annotation = [:]

        let view = self.bridge?.viewController?.view ?? UIView()

        if !documentController!.presentOpenInMenu(from: view.frame, in: view, animated: true) {
            call.reject("\(app.capitalized) not available")
        } else {
            call.resolve()
        }
    }

    // MARK: Facebook Story Sharing (via URL scheme)
    private func shareToFacebookStory(localURL: URL, uti: String, call: CAPPluginCall) {
        guard let pasteboardItems = try? Data(contentsOf: localURL) else {
            call.reject("Unable to read file for Facebook story")
            return
        }

        let ext = localURL.pathExtension.lowercased()
        let mimeType = (ext == "mp4") ? "video/mp4" : "image/jpeg"

        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(300)]
        UIPasteboard.general.setItems([[mimeType: pasteboardItems]], options: pasteboardOptions)

        if let url = URL(string: "facebook-stories://share") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { _ in
                    call.resolve()
                }
            } else {
                call.reject("Facebook app not installed or does not support stories")
            }
        } else {
            call.reject("Invalid Facebook URL scheme")
        }
    }
}
