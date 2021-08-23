//
//  DataBaseManager.swift
//  RealmDemo
//
//  Created by unthinkable-mac-0025 on 22/07/21.
//

import UIKit
import RealmSwift

/*
NOTE:-
    - Methods defined in DBManager Class may need an object of Object(RealmSwiftObject), i.e., Realm model object.
    - Before Using the function of this class, you may need to convert your Object(object of some class/struct) to Realm model object.
 
    Example:- You may refer the below example for Converting your object
        
         //Defining the Realm Model Class
         class RealmEmployee: Object {
             @objc dynamic var EmployeeID : UUID?
             @objc dynamic var EmployeeName : String?
             @objc dynamic var EmployeeEmail : String?
         }
        
         //Creating an Object of the class that you may have defined
         let employee = Employee(EmployeeID: UUID(), EmployeeName: "TestName", EmployeeEmail: "TestEmail")
 
         /*
            - Create an object of RealmEmployee type, and populate it with data from employee
            - Converting your object to Realm model object
         */
         let realmEmployee = RealmEmployee()
         realmEmployee.EmployeeID = employee.EmployeeID
         realmEmployee.EmployeeName = employee.EmployeeName
         realmEmployee.EmployeeEmail = employee.EmployeeEmail
         
         //Save the data to RealmDB
         DBManager.shared.saveObject(realmEmployee) { (result) in
             switch result{
             case .success(let isDone):
                 isSaved = isDone
             case .failure(let error):
                 print(error.localizedDescription)
             }
         }
 */

class DBManager {
    private let realm = try! Realm()
    
    //Singleton of DBManager Class
    static let shared = DBManager()
    private init(){}
    
    ///Save an Object to the DataBase.
    ///
    /// Use this method to add a Single Object to this Realm
    ///
    /// - Parameter object: The Object to be added in the Realm
    /// - Parameter completionHandler:The completion handler to return Result<Bool,RealmDatabse> when the write request is complete. This completion handler takes the following parameters: result
    func saveObject<T>(_ object: T, completionHandler : @escaping(Result<Bool,RealmDatabaseError>)-> Void) where T : Object {
        do {
            try realm.write {
                realm.add(object)
                completionHandler(.success(true))
            }
        } catch{
            print(Constant.RealmErrorMessage.ERROR_WHILE_SAVING,error)
            completionHandler(.failure(.errorWhileSaving(err: error.localizedDescription)))
        }
    }
    
    ///Remove an Object from Realm Database
    ///
    /// Use this method to remove a Single Object from this Realm
    ///
    /// - Parameter object: The Object to be removed in the Realm
    /// - Parameter completionHandler:The completion handler to return Result<Bool,RealmDatabse> when the write request is complete. This completion handler takes the following parameters: result
    func removeObject<T>(_ object: T, completionHandler : @escaping(Result<Bool,RealmDatabaseError>)-> Void) where T: Object {
        do {
            try realm.write {
                realm.delete(object)
                completionHandler(.success(true))
            }
        } catch{
            print(Constant.RealmErrorMessage.ERROR_WHILE_DELETING,error)
            completionHandler(.failure(.errorWhileDeleting(err: error.localizedDescription)))
        }
    }
    
    ///Delete all Objects From the Database
    ///
    /// Use this method to Clear the Database
    ///
    /// - Parameter completionHandler:The completion handler to return Result<Bool,RealmDatabse> when the write request is complete. This completion handler takes the following parameters: result
    func removeAll(completionHandler : @escaping(Result<Bool,RealmDatabaseError>)-> Void) {
        do {
            try realm.write {
                realm.deleteAll()
                completionHandler(.success(true))
            }
        } catch{
            print(Constant.RealmErrorMessage.ERROR_WHILE_DELETING, error)
            completionHandler(.failure(.errorWhileDeleting(err: error.localizedDescription)))
        }
    }
    
    ///Update the an Object in the Database
    ///
    /// Use this method to Update a Single Object according to the dictionary passed in this Realm
    ///
    /// - Parameter object: The Object to be added in the Realm
    /// - Parameter dictionary : The Dictionary with keys that are used in this Realm , with their updated values.
    /// - Parameter completionHandler:The completion handler to return Result<Bool,RealmDatabse> when the write request is complete. This completion handler takes the following parameters: result
    func update<T: Object>(_ object : T, with dictionary: [String:Any?], completionHandler : @escaping(Result<Bool,RealmDatabaseError>)-> Void){
        do {
            try realm.write{
                for (key, value) in dictionary{
                    object.setValue(value, forKey: key)
                }
                completionHandler(.success(true))
            }
        } catch{
            print(Constant.RealmErrorMessage.ERROR_WHILE_UPDATING, error)
            completionHandler(.failure(.errorWhileUpdating(err: error.localizedDescription)))
        }
    }
    
    ///Fetch Objects from the Database
    ///
    /// Use this method to get all the objects of a particular type from this Realm
    ///
    /// - Parameter type: To determine the  type of Object to fetch from this Realm
    func fetchObjects(_ type: Object.Type) -> [Object]? {
        let results = realm.objects(type)
        return Array(results)
    }
    
    ///Fetch Objects According to Predicate from the Database
    ///
    /// Use this method to Query objects of a particular type from this Realm
    ///
    /// - Parameter type: To determine the  type of Object to fetch from this Realm
    /// - Parameter predicate: To define the Query statement
    func fetchObjects<T>(_ type: T.Type, predicate: NSPredicate) -> [T]? where T: Object {
        return Array(realm.objects(type).filter(predicate))
    }
    
}

enum RealmDatabaseError : Error {
    case errorWhileSaving(err : String)
    case errorWhileUpdating(err : String)
    case errorWhileDeleting(err : String)
    case errorWhileFetching(err : String)
}


