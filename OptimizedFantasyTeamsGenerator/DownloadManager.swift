//
//  DownloadManager.swift
//  OptimizedFantasyTeamsGenerator
//
//  Created by Ron Jurincie on 8/14/23.
//

import Foundation
import SwiftUI

class DownloadManager {
    var isDownloading:Bool = true
    
    func downloadStuff() {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("File already exists")
                isDownloading = false
            } else {
                let urlRequest = URLRequest(url: URL(string:"" )!)
                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        self.isDownloading = false
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                }
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                            }
                        }
                    } else {
                        print("URL access error")
                        self.isDownloading = false
                    }
                }
                dataTask.resume()
            }
        }
    }
}
