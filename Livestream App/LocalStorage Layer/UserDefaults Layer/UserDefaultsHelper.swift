//
//  LocalStorage.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

//UserDefaultsKeys Will be Used to uniquely identify an Object from UserDefaults
enum UserDefaultsKeys: String, UserDefaultsKeysProtocol {
    //Add Your Own Keys
    case sampleKey
}

class UserDefaultsHelper: UserDefaultsHelperProtocol {
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    ///Function to Read a Simple Object from the UserDefaults
    ///
    ///Use this Function to Read a Object of Primitive type to the UserDefaults
    ///
    ///     Example:-
    ///     let helper = UserDefaultsHelper()
    ///     let hello: String? = helper.value(key: UserDefaultsKeys.sampleKey)
    ///
    /// - Parameter key: The Key whose value is to Fetched
    ///
    func value<T>(key: UserDefaultsKeysProtocol) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    ///Function to Write a Simple Object to the UserDefaults
    ///
    ///Use this Function to Write a Object of Primitive type to the UserDefauts
    ///
    ///     Example:-
    ///     let helper = UserDefaultsHelper()
    ///     helper.write(key: UserDefaultsKeys.sampleKey, value: "TestData")
    ///
    /// - Parameter key: The Key whose value is to Written
    /// - Parameter value: The Value for the Given Key
    ///
    func write<T>(key: UserDefaultsKeysProtocol, value: T?) {
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    
    ///Function to Remove a Object from the UserDefaults
    ///
    ///Use this Function to Remove a Simple / Complex Object from the UserDefauts
    ///
    ///     Example:-
    ///     let helper = UserDefaultsHelper()
    ///     helper.remove(key: UserDefaultsKeys.sampleKey)
    ///
    /// - Parameter key: The Key whose value is to Removed
    ///
    func remove(key: UserDefaultsKeysProtocol) {
        self.userDefaults.set(nil, forKey: key.rawValue)
    }
    
    ///Function to Write a Complex Object to the UserDefaults
    ///
    ///Use this Function to Write a Complex Object to the UserDefauts
    ///
    ///     Example:-
    ///     let helper = UserDefaultsHelper()
    ///     let user: User = User(name: "Name", lastName: "LastName")
    ///     helper.writeStoreable(key: UserDefaultsKeys.sampleKey, value: user)
    ///
    /// - Parameter key: The Key whose value is to Written
    /// - Parameter value: The Value for the Given Key(Object of a Class, conforming to Storable Protocol)
    ///
    func writeStoreable<T>(key: UserDefaultsKeysProtocol, value: T?) where T: Storeable {
        self.userDefaults.set(value?.storeData, forKey: key.rawValue)
    }
    
    ///Function to Read a Complex Object from the UserDefaults
    ///
    ///Use this Function to Read a Complex Object from the UserDefauts
    ///
    ///     Example:-
    ///     let helper = UserDefaultsHelper()
    ///     let user: User = helper.valueStoreable(key: UserDefaultsKeys.sampleKey)
    ///
    /// - Parameter key: The Key whose value is to Fetched
    ///
    func valueStoreable<T>(key: UserDefaultsKeysProtocol) -> T? where T: Storeable {
        let data: Data? = self.userDefaults.data(forKey: key.rawValue)
        return T(storeData: data)
    }
}
