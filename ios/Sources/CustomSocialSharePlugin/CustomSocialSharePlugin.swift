import Foundation
import Capacitor
import UIKit

@objc(CustomSocialSharePlugin)
public class CustomSocialSharePlugin: CAPPlugin, UIDocumentInteractionControllerDelegate {
    var documentController: UIDocumentInteractionController?

    @objc func shareToInstagramFromUrl(_ call: CAPPluginCall) {
        guard let urlString = call.getString("url"),
              let destination = call.getString("destination"),
              let mediaURL = URL(string: urlString) else {
            call.reject("Missing or invalid URL or destination")
            return
        }

        let contentUrl = call.getString("content_url") // usabile eventualmente nelle stories (non supportato ufficialmente da Instagram iOS)

        downloadMedia(from: mediaURL) { localURL, uti in
            guard let localURL = localURL else {
                call.reject("Download failed")
                return
            }

            DispatchQueue.main.async {
                self.share(localURL: localURL, uti: uti, destination: destination, call: call)
            }
        }
    }

    private func downloadMedia(from url: URL, completion: @escaping (URL?, String) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL = tempURL, error == nil else {
                completion(nil, "")
                return
            }

            let ext = url.pathExtension.lowercased()
            let uti = (ext == "mp4") ? "com.apple.quicktime-movie" : "public.jpeg"
            let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("shared_instagram_content.\(ext)")

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

    private func share(localURL: URL, uti: String, destination: String, call: CAPPluginCall) {
        documentController = UIDocumentInteractionController(url: localURL)
        documentController?.uti = uti
        documentController?.delegate = self
        documentController?.annotation = [:]

        // Le Stories supportano sticker background solo tramite scheme dedicati, non ufficialmente via UIDocumentInteractionController
        // In ogni caso, questo apre l’interfaccia Instagram e consente la scelta dell’azione (Post, Reel, Direct, ecc.)
        let view = self.bridge?.viewController?.view ?? UIView()

        if !documentController!.presentOpenInMenu(from: view.frame, in: view, animated: true) {
            call.reject("Instagram not available")
        } else {
            call.resolve()
        }
    }
}
