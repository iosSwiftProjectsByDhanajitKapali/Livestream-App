//
//  Model.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 28/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

/*
 This Model will be used to Parse the JSON data revcieved from API calls
 
 Note:- Create Your Own Model
 */
struct MyModel: Codable {
    
}

struct LiveCommentModel  {
    let userName : String
    let userComment : String
}

