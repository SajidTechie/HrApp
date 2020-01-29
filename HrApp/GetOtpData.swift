//
//  GetOtpData.swift
//  HrApp
//
//  Created by Goldmedal on 1/27/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct GetOtpElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [GetOtpData]?
    let errors : [ErrorsData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case statusCodeMessage = "StatusCodeMessage"
        case timestamp = "Timestamp"
        case size = "Size"
        case data = "Data"
        case errors = "Errors"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        statusCodeMessage = try values.decodeIfPresent(String.self, forKey: .statusCodeMessage)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
        data = try values.decodeIfPresent([GetOtpData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}

struct GetOtpData : Codable {
    let statusCode : Int?
    let statusMessage : String?

    enum CodingKeys: String, CodingKey {

        case statusCode = "StatusCode"
        case statusMessage = "StatusMessage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        statusMessage = try values.decodeIfPresent(String.self, forKey: .statusMessage)
    }

}
