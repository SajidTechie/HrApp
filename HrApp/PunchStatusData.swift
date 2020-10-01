//
//  PunchStatusData.swift
//  HrApp
//
//  Created by Goldmedal on 2/1/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct PunchStatusElement : Codable {
 let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [PunchStatusData]?
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
        data = try values.decodeIfPresent([PunchStatusData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}

struct PunchStatusData : Codable {
   
    let status : Bool?
    let officeLat : String?
    let officeLong : String?
    let isAtteandanceValid : String?
    let isGeoFenceLock : String?
    

    enum CodingKeys: String, CodingKey {
   
         case status = "Status"
         case officeLat = "OfficeLat"
         case officeLong = "OfficeLong"
         case isAtteandanceValid = "IsAtteandanceValid"
         case isGeoFenceLock = "IsGeoFenceLock"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        officeLat = try values.decodeIfPresent(String.self, forKey: .officeLat)
        officeLong = try values.decodeIfPresent(String.self, forKey: .officeLong)
        isAtteandanceValid = try values.decodeIfPresent(String.self, forKey: .isAtteandanceValid)
        isGeoFenceLock = try values.decodeIfPresent(String.self, forKey: .isGeoFenceLock)
    }

}


