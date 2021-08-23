//
//  NetworkManager.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    static var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func getAPICall<T: Decodable>(url: String, parameters: [String:Any], headers: HTTPHeaders, responseClass: T.Type , completion:@escaping (Result<T, NetworkingError>) -> Void) {
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            guard let _ = response.response?.statusCode else {
                completion(.failure(.noResponse))
                return
            }
            let status = HttpResponseCodeHanlder().HttpResponseCodeChecker(response.response)
            if status == .OKResponse{ // Success
                guard let jsonResponse = try? response.result.get() else {
                    completion(.failure(.noResponse))
                    return
                }
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    completion(.failure(.decodingError(err: Constant.NetworkingErrorMessage.JSON_PARSING_ERROR)))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(T.self, from: theJSONData) else {
                    completion(.failure(.decodingError(err: Constant.NetworkingErrorMessage.JSON_PARSING_ERROR)))
                    return
                }
                completion(.success(responseObj))
            }else{
                completion(.failure(.invalidResponse(type: status)))
            }
        }
    } //:getAPICall()
    
    func postAPICall<T: Decodable>(url: String, parameters: [String:Any], headers: HTTPHeaders, responseClass: T.Type , completion:@escaping (Result<T, NetworkingError>) -> Void) {
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            guard let _ = response.response?.statusCode else {
                completion(.failure(.noResponse))
                return
            }
            let status = HttpResponseCodeHanlder().HttpResponseCodeChecker(response.response)
            if status == .OKResponse{ // Success
                guard let jsonResponse = try? response.result.get() else {
                    completion(.failure(.noResponse))
                    return
                }
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    completion(.failure(.decodingError(err: Constant.NetworkingErrorMessage.JSON_PARSING_ERROR)))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(T.self, from: theJSONData) else {
                    completion(.failure(.decodingError(err: Constant.NetworkingErrorMessage.JSON_PARSING_ERROR)))
                    return
                }
                completion(.success(responseObj))
            }else{
                completion(.failure(.invalidResponse(type: status)))
            }
        }
    } //:postAPICall()
    
    func downloadFile(atURL: String, saveWithName: String, completion:@escaping (Result<String, NetworkingError>) -> Void){
        let destination : DownloadRequest.Destination = { _ , _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(saveWithName)
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            
        }
        AF.download(atURL, to: destination).downloadProgress(closure: { (prog) in
            //progress
        }).response { response in
            //debugPrint(response)

            if response.error == nil, let filePath = response.fileURL?.path {
                //print("***\(filePath)")
                completion(.success(filePath))
            }else{
                completion(.failure(.noResponse))
            }
        }
    } //:downloadFile()
    
}
