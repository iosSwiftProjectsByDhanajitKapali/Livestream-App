//
//  Model.swift
//  Livestream App
//
//  Created by unthinkable-mac-0025 on 31/08/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation
// MARK: - Welcome
struct MyTokenModel: Codable {
    let data: DataClass
    let status: String

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let channelName, accessToken, voiceAccessToken, userID: String

    enum CodingKeys: String, CodingKey {
        case channelName = "ChannelName"
        case accessToken = "AccessToken"
        case voiceAccessToken = "VoiceAccessToken"
        case userID = "UserId"
    }
}


