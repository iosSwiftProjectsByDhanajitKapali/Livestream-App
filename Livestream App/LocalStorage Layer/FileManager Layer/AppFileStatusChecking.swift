//
//  AppFileStatusChecking.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol AppFileStatusChecking {
    func isWritable(file at: URL) -> Bool
    
    func isReadable(file at: URL) -> Bool
    
    func exists(file at: URL) -> Bool
}

extension AppFileStatusChecking {
    
    ///Use this fucntion to check is an URL path has write access or not
    func isWritable(file at: URL) -> Bool {
        if FileManager.default.isWritableFile(atPath: at.path) {
            print(at.path)
            return true
        }
        else {
            print(at.path)
            return false
        }
    }
    
    ///Use this fucntion to check is an URL path has read access or not
    func isReadable(file at: URL) -> Bool {
        if FileManager.default.isReadableFile(atPath: at.path) {
            print(at.path)
            return true
        }
        else {
            print(at.path)
            return false
        }
    }
    
    ///Use this fucntion to check if the URL path is valid or not
    func exists(file at: URL) -> Bool {
        if FileManager.default.fileExists(atPath: at.path) {
            return true
        }
        else {
            return false
        }
    }
} // end extension AppFileStatusChecking

