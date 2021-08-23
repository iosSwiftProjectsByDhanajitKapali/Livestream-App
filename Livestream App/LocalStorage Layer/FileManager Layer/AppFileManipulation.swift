//
//  AppFileManipulation.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation


extension AppFileManipulation{
    
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool{
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        let isSaved = FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
        return isSaved
    }
    
    func createFolder(withName name: String, inPath path: URL) -> Bool{
        var isCreated = false
        let newFolderUrl = path.appendingPathComponent(name)
        do{
            try FileManager.default.createDirectory(at: newFolderUrl, withIntermediateDirectories: true, attributes: [:])
            isCreated = true
        }catch{
            print(Constant.FileManagerErrorMessage.ERROR_CREATING_THE_FOLDER ,error.localizedDescription)
        }
        return isCreated
    }
    
    func saveFile(containing: Data, to path: AppDirectories, withName name: String) -> Bool {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing
        let isSaved = FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
        return isSaved
    }
    
    func saveFile(containing: Data, to path: URL, withName name: String) -> Bool{
        var filePathInString = String(path.absoluteString) + name
        for _ in 0...6{
            filePathInString.removeFirst()
        }
        let isSaved = FileManager.default.createFile(atPath: filePathInString, contents: containing, attributes: nil)
        return isSaved
    }
    
    func readFile(at path: AppDirectories, withName name: String) -> Data?{
        let filePath = getURL(for: path).path + "/" + name
        let fileContents = FileManager.default.contents(atPath: filePath)
        return fileContents
    }
    
    func readFile(at path: URL, withName name: String) -> Data?{
        var originURL = String(self.getPathForFile(withName: name, atPath: path).absoluteString)
        for _ in 0...6{
            originURL.removeFirst()
        }
        let fileContents = FileManager.default.contents(atPath: originURL)
        return fileContents
    }
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool{
        var isDeleted = false
        let filePath = buildFullPath(forFileName: name, inDirectory: path)
        do {
            try FileManager.default.removeItem(at: filePath)
            isDeleted = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_DELETING_THE_FILE, error.localizedDescription)
        }
        return isDeleted
    }
    
    func deleteFile(at path: URL, withName name: String) -> Bool{
        var isDeleted = false
        let originURL = self.getPathForFile(withName: name, atPath: path)
        do {
            try FileManager.default.removeItem(at: originURL)
            isDeleted = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_DELETING_THE_FILE, error.localizedDescription)
        }
        return isDeleted
    }
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool{
        var isRenamed = false
        let oldPath = getURL(for: path).appendingPathComponent(oldName)
        let newPath = getURL(for: path).appendingPathComponent(newName)
        do {
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            isRenamed = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_RENAMING_THE_FILE, error.localizedDescription)
        }
        return isRenamed
    }
    
    func renameFile(at path: URL, with oldName: String, to newName: String) -> Bool{
        var isRenamed = false
        let oldPath = self.getPathForFile(withName: oldName, atPath: path)
        let newPath = self.getPathForFile(withName: newName, atPath: path)
        do {
            try FileManager.default.moveItem(at: oldPath, to: newPath)
            isRenamed = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_RENAMING_THE_FILE, error.localizedDescription)
        }
        return isRenamed
    }
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool{
        var isMoved = false
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        do {
            try FileManager.default.moveItem(at: originURL, to: destinationURL)
            isMoved = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_MOVING_THE_FILE, error.localizedDescription)
        }
        return isMoved
    }
    
    func moveFile(withName name: String, fromPath: URL, toPath: URL) -> Bool{
        var isMoved = false
        let originURL = self.getPathForFile(withName: name, atPath: fromPath)
        let destinationURL = self.getPathForFile(withName: name, atPath: toPath)
        do {
            try FileManager.default.moveItem(at: originURL, to: destinationURL)
            isMoved = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_MOVING_THE_FILE, error.localizedDescription)
        }
        return isMoved
    }
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool{
        var isCopied = false
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        do {
            try FileManager.default.copyItem(at: originURL, to: destinationURL)
            isCopied = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_COPYING_THE_FILE, error.localizedDescription)
        }
        return isCopied
    }
    
    func copyFile(withName name: String, fromPath: URL, toPath: URL) -> Bool{
        var isCopied = false
        do {
            try FileManager.default.copyItem(at: fromPath, to: toPath)
            isCopied = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_COPYING_THE_FILE, error.localizedDescription)
        }
        return isCopied
    }
    
    func getPathForFolder(withName name: String, atPath: URL) -> URL{
        let folderUrl = atPath.appendingPathComponent(name)
        return folderUrl
    }
    
    func getPathForFile(withName name: String, atPath: URL) -> URL{
        let fileUrl = atPath.appendingPathComponent(name)
        return fileUrl
    }
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool{
        var isFileExtensionChanged = false
        var newFileName = NSString(string:name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName:String =  String(newFileName)
        
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: finalFileName, inDirectory: inDirectory)
        
        do {
            try FileManager.default.moveItem(at: originURL, to: destinationURL)
            isFileExtensionChanged = true
        } catch let error {
            print(Constant.FileManagerErrorMessage.ERROR_WHILE_CHANGING_THE_FILE_EXTENSION, error.localizedDescription)
        }
        return isFileExtensionChanged
    }
} // end extension AppFileManipulation

