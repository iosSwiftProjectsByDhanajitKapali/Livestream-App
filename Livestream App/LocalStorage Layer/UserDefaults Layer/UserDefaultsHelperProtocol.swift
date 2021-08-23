//
//  LocalStorageProtocol.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

protocol UserDefaultsKeysProtocol {
    var rawValue: String { get }
}

//To save an Object of a Class in the UserDefaults, the class must conform to this <Storeable> protocol
protocol Storeable {
    var storeData: Data? { get }
    init?(storeData: Data?)
}

protocol UserDefaultsHelperProtocol {
    func value<T>(key: UserDefaultsKeysProtocol) -> T?
    func write<T>(key: UserDefaultsKeysProtocol, value: T?)
    func remove(key: UserDefaultsKeysProtocol)
    
    func valueStoreable<T>(key: UserDefaultsKeysProtocol) -> T? where T: Storeable
    func writeStoreable<T>(key: UserDefaultsKeysProtocol, value: T?) where T: Storeable
}

/*
 Example:- Conform a class/struct with <Storeable> protocol like this, if you want to store its Object to UserDefaults
 
    struct User: Codable, Storeable {
        let name: String
        let lastName: String
        
        var storeData: Data? {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(self)
            return encoded
        }
        
        init(name: String, lastName: String) {
            self.name = name
            self.lastName = lastName
        }
        
        init?(storeData: Data?) {
            guard let storeData = storeData else { return nil }
            let decoder = JSONDecoder()
            guard let decoded = try? decoder.decode(User.self, from: storeData) else { return nil }
            self = decoded
        }
    }

*/
