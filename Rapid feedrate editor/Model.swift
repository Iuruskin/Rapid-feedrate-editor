//
//  Find file from mac.swift
//  Rapid feedrate editor
//
//  Created by Кирилл Юрушкин on 13.03.2023.
//

import SwiftUI

func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.allowedFileTypes = ["txt", "tap", "ngc"]
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}


func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = ["ngc", "txt", "tap"]
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    savePanel.allowsOtherFileTypes = false
    savePanel.title = "Save your text"
    savePanel.message = "Choose a folder and a name to store your text."
    savePanel.nameFieldLabel = "File name:"
    let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
}




func saveGcode(url: URL?, gCode: String) {
    if let newUrl = url {
        let manager = FileManager.default
        manager.createFile(atPath: newUrl.path, contents: gCode.data(using: .utf8))
    }
}

func changeRapid(gCode : String, safeZ: Double, currentFeedrate: Int, newFeedrate: Int) -> (String, Int) {
    var counter = 0
    let strSafeZ = "Z\(safeZ)"
    let strCurrentFeedrate = "F\(currentFeedrate)."
    let strNewFeedrate = "F\(newFeedrate)."
    
    let gCodeByStr : [String] = gCode.components(separatedBy: "\n")
    var arraysArray : [[String]] = [[]]
    var resultArray : [String] = []
    
    for partCode in gCodeByStr {
        var array = partCode.components(separatedBy: " ")
        for (i, value) in array.enumerated() {
            if value == strSafeZ {
                print(array[i+1])
                print(strCurrentFeedrate)
                if array[i+1] == strCurrentFeedrate {
                    counter += 1
                    array[i+1] = strNewFeedrate
                }
            }
        }
        arraysArray.append(array)
    }
    for i in arraysArray {
        resultArray.append(i.joined(separator: " "))
    }
    return (resultArray.joined(separator: "\n"), counter)
}
