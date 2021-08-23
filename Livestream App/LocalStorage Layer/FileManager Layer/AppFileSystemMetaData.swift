//
//  AppFileSystemMetaData.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol AppFileSystemMetaData {
    func list(directory at: URL) -> [String]
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
}

extension AppFileSystemMetaData {
    func list(directory at: URL) -> [String] {
        var listing : [String] = []
        do{
            listing = try FileManager.default.contentsOfDirectory(atPath: at.path)
        }catch{
            print(Constant.FileManagerErrorMessage.ERROR_GETTING_THE_LIST_OF_CONTENTS_OF_FOLDER, error.localizedDescription)
        }
        return listing
        //Print the Listing[] to debug
//        if listing.count > 0 {
//            print("\n----------------------------")
//            print("LISTING: \(at.path)")
//            print("")
//            for file in listing{
//                print("File: \(file.debugDescription)")
//            }
//            print("")
//            print("----------------------------\n")
//            return listing
//        }
    }
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any] {
        return try! FileManager.default.attributesOfItem(atPath: atFullPath.path)
    }
} // end extension AppFileSystemMetaData

