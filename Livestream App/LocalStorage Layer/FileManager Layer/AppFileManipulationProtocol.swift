//
//  AppFileManipulationProtocol.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol AppFileManipulation : AppDirectoryNames{
    
    ///Create a file containing text
    ///
    /// Use this method to create a file in a Driectory containing the passed string
    ///
    /// - Parameter containing: String you want to store in the file TextFile  created
    /// - Parameter to: To define the Directory, i.e., where to store the File created
    /// - Parameter withName : To define the name of the File( name + extension)
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    
    ///Create a file with Data
    ///
    /// Use this method to create a file in a Driectory containing the passed Data
    ///
    /// - Parameter containing: Data you want to store in the file File  created
    /// - Parameter to: To define the Directory, i.e., where to store the File created
    /// - Parameter withName : To define the name of the File( name + extension)
    func saveFile(containing: Data, to path: AppDirectories, withName name: String) -> Bool
    
    ///Create a file with Data
    ///
    /// Use this method to create a file in a desired Folder Path containing the passed Data
    ///
    /// - Parameter containing: Data you want to store in the file File  created
    /// - Parameter to: To define the Directory, i.e., where to store the File created
    /// - Parameter withName : To define the name of the File( name + extension)
    func saveFile(containing: Data, to path: URL, withName name: String) -> Bool
    
    ///Read the Data of a file
    ///
    /// Use this method to Get the file data stored in a Directory
    ///
    /// - Parameter at: To define the Directory where the File is stored
    /// - Parameter withName : To define the name of the File( name + extension)
    func readFile(at path: AppDirectories, withName name: String) -> Data?
    
    ///Read the Data of a file
    ///
    /// Use this method to Get the file data stored at the some Folder Path
    ///
    /// - Parameter at: To define the Folder Path where the File is stored
    /// - Parameter withName : To define the name of the File( name + extension)
    func readFile(at path: URL, withName name: String) -> Data?
    
    ///Delete a file
    ///
    /// Use this method to Delete a file stored in a Directory
    ///
    /// - Parameter at: To define the Directory where the File is stored
    /// - Parameter withName : To define the name of the File( name + extension)
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    
    ///Delete a file
    ///
    /// Use this method to Delete a file stored at some Folder path
    ///
    /// - Parameter at: To define the Folder Path where the File is stored
    /// - Parameter withName : To define the name of the File( name + extension)
    func deleteFile(at path: URL, withName name: String) -> Bool
    
    ///Rename a file
    ///
    /// Use this method to Rename a file stored in a Directory
    ///
    /// - Parameter at: To define the Directory where the File is stored
    /// - Parameter with : To define the Old Name of the File( name + extension)
    /// - Parameter to: To define the New Name of the File(name + extension
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    
    ///Rename a file
    ///
    /// Use this method to Rename a file stored in a some Folder Path
    ///
    /// - Parameter at: To define the Folder Path where the File is stored
    /// - Parameter with : To define the Old Name of the File( name + extension)
    /// - Parameter to: To define the New Name of the File(name + extension
    func renameFile(at path: URL, with oldName: String, to newName: String) -> Bool
    
    ///Move a file
    ///
    /// Use this method to Move a file stored in a Directory
    ///
    /// - Parameter withName : To define the name of the File( name + extension)
    /// - Parameter inDirectory : To define the Old Directory, where the file is currently Stored
    /// - Parameter toDirectory: To define the New Directory, where the file is needed to be moved
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    ///Move a file
    ///
    /// Use this method to Move a file stored at some Folder Path
    ///
    /// - Parameter withName : To define the name of the File( name + extension)
    /// - Parameter fromPath : To define the Old Folder Path, where the file is currently Stored
    /// - Parameter toPath: To define the New Folder Path, where the file is needed to be Moved
    func moveFile(withName name: String, fromPath: URL, toPath: URL) -> Bool
    
    ///Copy a file
    ///
    /// Use this method to Copy a file stored in a Directory to a new Directory
    ///
    /// - Parameter withName : To define the name of the File( name + extension)
    /// - Parameter inDirectory : To define the Old Directory, where the file is currently Stored
    /// - Parameter toDirectory: To define the New Directory, where the file is needed to be Copied
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    ///Copy a file
    ///
    /// Use this method to Copy a file stored in some Folder Path to a new Folder Path
    ///
    /// - Parameter withName : To define the name of the File( name + extension)
    /// - Parameter fromPath : To define the Old Folder Path, where the file is currently Stored
    /// - Parameter toPath: To define the New Folder Path, where the file is needed to be Copied
    func copyFile(withName name: String, fromPath: URL, toPath: URL) -> Bool
    
    ///Create a New Folder
    ///
    /// Use this method to Create a New Folder at some Folder Path
    ///
    /// - Parameter withName : To define the name of the Folder( name)
    /// - Parameter inPath : To define the Folder Path, where the Folder is to be created
    func createFolder(withName name: String, inPath path: URL) -> Bool
    
    ///Get the Path of Some Folder
    ///
    /// Use this method to Get the Path of a Folder stored at some Folder Path
    ///
    /// - Parameter withName : To define the name of the Folder
    /// - Parameter atPath : To define the Folder Path, where the Folder is Stored
    func getPathForFolder(withName name: String, atPath: URL) -> URL
    
    ///Get the Path of Some File
    ///
    /// Use this method to Get the Path of a FIle store at some Folder Path
    ///
    /// - Parameter withName : To define the name of the File( name + extension)
    /// - Parameter atPath : To define the Folder Path, where the File is Stored
    func getPathForFile(withName name: String, atPath: URL) -> URL
    
    ///Change the File Extension
    ///
    /// Use this method to Change the Extension of a File stored in a Directory
    ///
    /// - Parameter withName : To define the Old name of the File ( name + extension)
    /// - Parameter inDirectory : To define the Directory, where the File is Stored
    /// - Parameter toNewExtension : To define the New File Extension ( extension)
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
}
