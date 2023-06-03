//
//  BlocksMissionPropertiesModel.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties view

class BlocksMissionPropertiesModel: ObservableObject {
    @AppStorage("importedWorlds") @Storage var importedWorlds = [String]()
    @Published var importedPresets = [WorldPreset]()

    let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
    @Published var code = ""

    @Published var errorString: String?

    @Published var importing = false

    func updatePresetsFromImportedWorlds(worlds: [String]) {
        let importedPresets = worlds.filter { !$0.isEmpty }.compactMap { WorldParser.getPreset(string: $0) }
        self.importedPresets = importedPresets
    }

    func importFromCode(code: String) {
        if code.count != 6 {
            errorString = "Code must be 6 digits."
            return
        }

        let characterSet = CharacterSet(charactersIn: code)
        if !allowedCharacters.isSuperset(of: characterSet) {
            errorString = "Code must be alphanumeric (0-9, A-Z)."
            return
        }

        withAnimation {
            importing = true
        }

        downloadWithCode(code: code) { [weak self] string in
            guard let self else { return }

            DispatchQueue.main.async {
                withAnimation {
                    self.importing = false
                }

                if let string {
                    if self.importedWorlds.contains(where: { $0.getImportedWorldName() == string.getImportedWorldName() }) {
                        print("Already contains.")
                        self.errorString = "You've already imported this world."
                        return
                    }

                    self.code = ""
                    self.importedWorlds.append(string)
                }
            }
        }
    }

    func checkServerAvailability(completion: @escaping ((Bool, String?) -> Void)) {
        let baseURL = URL(string: "https://midnight-builds-api.vercel.app/api")!
        let finalURL = baseURL.appending(path: "active")

        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in

            DispatchQueue.main.async {
                if
                    let data,
                    let string = String(data: data, encoding: .utf8)
                {
                    if string.hasPrefix("true") {
                        let components = string.components(separatedBy: ",")
                        
                        let serverID: String? = {
                            if components.indices.contains(1) {
                                let serverID = components[1]
                                return serverID
                            }
                            return nil
                        }()
                        
                        completion(true, serverID)
                        
                        return
                    }
                }
                
                completion(false, nil)
            }
        }

        task.resume()
    }

    func downloadWithCode(code: String, completion: @escaping ((String?) -> Void)) {
        let baseURL = URL(string: "https://midnight-builds-api.vercel.app/api")!
        let finalURL = baseURL.appending(path: code)

        let task = URLSession.shared.dataTask(with: finalURL) { [weak self] data, response, error in
            guard let self else { return }

            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)

                    switch httpResponse.statusCode {
                    case 200:
                        break
                    case 404:
                        self.errorString = "Code '\(code)' not found. Make sure you've copied it right."
                        return
                    default:
                        self.errorString = "Server error."
                        return
                    }
                }

                if let data {
                    if let string = String(data: data, encoding: .utf8) {
                        completion(string)
                        return
                    }
                }

                completion(nil)
            }
        }

        task.resume()
    }
}
