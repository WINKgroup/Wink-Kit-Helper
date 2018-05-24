//
//  XcodePluginViewController.swift
//  Wink Project Helper
//
//  Created by Rico Crescenzio on 30/03/18.
//  Copyright © 2018 wink srl. All rights reserved.
//

import Cocoa
import Zip
import LocalAuthentication
import Security

class XcodePluginViewController: NSViewController {
    
    @IBOutlet private weak var installButton: NSButton!
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    
    private var home: URL {
        let pw = getpwuid(getuid());
        let home = pw?.pointee.pw_dir
        let homePath = FileManager.default.string(withFileSystemRepresentation: home!, length: Int(strlen(home)))
        return URL(fileURLWithPath: homePath)
    }
    private var fileTemplatePath: URL {
        return home.appendingPathComponent("Library/Developer/Xcode/Templates/File Templates/Wink Kit")
    }
    private var projectTemplatePath: URL {
        return home.appendingPathComponent("Library/Developer/Xcode/Templates/Project Templates/Wink Kit")
    }
    
    @IBAction func installButtonDidClick(_ sender: Any) {
        do {
            let templateNames = [("Files", fileTemplatePath), ("Project", projectTemplatePath)]
            try templateNames.forEach { template, destination in
                let filePath = Bundle.main.url(forResource: template, withExtension: "zip")!
                let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
                try copyFolders(folderPath: unzipDirectory.appendingPathComponent("Wink Kit").path, destination: destination.path)
            }
            
            dialogOK(question: "Success", text: "Templates successfully installed!")
        }
        catch let e {
            presentError(e)
            print("Something went wrong \(e)")
        }
    }
    
    
    func copyFolders(folderPath: String, destination: String) throws {
        try copyFiles(pathFromBundle: folderPath, destination: destination)
    }
    
    func copyFiles(pathFromBundle: String, destination: String) throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: destination) {
            try FileManager.default.createDirectory(atPath: destination, withIntermediateDirectories: true, attributes: nil)
        }
        let filelist = try fileManager.contentsOfDirectory(atPath: pathFromBundle)
        try? fileManager.copyItem(atPath: pathFromBundle, toPath: destination)
        
        for filename in filelist {
            try? fileManager.copyItem(atPath: "\(pathFromBundle)/\(filename)", toPath: "\(destination)/\(filename)")
        }
    }
    
    func dialogOK(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
}
