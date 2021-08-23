//
//  HttpResponseCodeChecker.swift
//  Vax Vision
//
//  Created by unthinkable-mac-0025 on 25/07/21.
//

import Foundation
import UIKit

struct HttpResponseCodeHanlder {
    
    func HttpResponseCodeChecker(_ httpResponse : HTTPURLResponse?) -> HttpResponseCode{
        if let httpResponse = httpResponse{
            if httpResponse.statusCode == 200{
                return .OKResponse
            }else if httpResponse.statusCode == 300 {
                return .AbmigousRequest
            }else if httpResponse.statusCode == 400 {
                return .BadRequest
            }else if httpResponse.statusCode == 401 {
                return .Unauthorized
            }else if httpResponse.statusCode == 403 {
                return .Forbidden
            }else if httpResponse.statusCode == 404 {
                return .NotFound
            }else if httpResponse.statusCode == 408 {
                return .RequestTimeout
            }else if httpResponse.statusCode == 500 {
                return .InternalServerError
            }else if httpResponse.statusCode == 502 {
                return .BadGateway
            }
        }
        return .InvalidResponse
    }
}

enum HttpResponseCode{
    case InvalidResponse
    case OKResponse
    case AbmigousRequest
    case BadRequest
    case Unauthorized
    case RequestTimeout
    case Forbidden
    case NotFound
    case InternalServerError
    case BadGateway
}
