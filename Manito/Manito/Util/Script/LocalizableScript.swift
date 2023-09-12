//
//  LocalizableScript.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/09/12.
//

import Foundation

private let semaphore = DispatchSemaphore(value: 0)
private let sheetURL = URLLiteral.localizableURL
private let stringFilePath = URLLiteral.filePath

final class DataDelegate: NSObject, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let csvString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\r", with: "") else { return }
        let stringsDictionary = self.csvToStrings(csvString: csvString)
        self.createStringsFile(dictionary: stringsDictionary)
        semaphore.signal()
    }

    private func csvToStrings(csvString: String) -> [[String: String]] {
        let csv = csvString.components(separatedBy: "\n")
        let keyIndex: Int = 1, koreanIndex: Int = 2
        var dictionary: [[String: String]] = []

        for rowIndex in csv.indices {
            let row = csv[rowIndex].components(separatedBy: ",")

            dictionary.append(["key": row[keyIndex], "kr": row[koreanIndex]])
        }

        return dictionary
    }

    private func createStringsFile(dictionary: [[String: String]]) {
        var csvString = ""
        for item in dictionary {
            guard let key = item["key"] else { return }
            guard let kr = item["kr"] else { return }

            csvString.append("\"\(key)\" = \"\(kr)\";\n")
        }

        let fileManager = FileManager()
        guard let desktopDir = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first else { return }
        do {
            let stringFilePath = desktopDir.appendingPathComponent(stringFilePath)
            do {
                try csvString.write(to: stringFilePath, atomically: false, encoding: .utf8)
            }
        } catch let error as NSError {
            Logger.debugDescription("Error Writing File: \(error.localizedDescription)")
        }
    }
}

private func runScript() {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: DataDelegate(), delegateQueue: nil)
    guard let url = URL(string: sheetURL) else {
        fatalError("구글 시트에서 Localizable 파일을 불러올 수 없습니다.")
    }

    session.dataTask(with: url).resume()
    semaphore.wait()
}
