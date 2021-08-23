//
//  NwetorkingError.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

enum NetworkingError : Error{
    case error(err : String)
    case noResponse
    case invalidResponse(type : HttpResponseCode)
    case invalidData
    case decodingError(err : String)
}
