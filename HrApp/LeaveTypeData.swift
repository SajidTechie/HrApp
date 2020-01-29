//
//  LeaveTypeData.swift
//  HrApp
//
//  Created by Goldmedal on 1/27/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct LeaveTypeElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [LeaveTypeData]?
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
        data = try values.decodeIfPresent([LeaveTypeData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}

struct LeaveTypeData : Codable {
    let leaveTypeID : String?
    let leaveTypeName : String?
    let leaveTypeColour : String?

    enum CodingKeys: String, CodingKey {

        case leaveTypeID = "LeaveTypeID"
        case leaveTypeName = "LeaveTypeName"
        case leaveTypeColour = "LeaveTypeColour"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
         leaveTypeID = try values.decodeIfPresent(String.self, forKey: .leaveTypeID)
         leaveTypeName = try values.decodeIfPresent(String.self, forKey: .leaveTypeName)
         leaveTypeColour = try values.decodeIfPresent(String.self, forKey: .leaveTypeColour)
    }

}
