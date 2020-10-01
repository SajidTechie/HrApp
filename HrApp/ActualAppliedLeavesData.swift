//
//  ActualAppliedLeavesData.swift
//  HrApp
//
//  Created by Goldmedal on 06/02/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct ActualAppliedLeavesElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [ActualAppliedLeavesData]?
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
        data = try values.decodeIfPresent([ActualAppliedLeavesData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}



struct ActualAppliedLeavesData : Codable {
    let actualLeaveday : String?
    let appliedLeaveDays : String?

    enum CodingKeys: String, CodingKey {

        case actualLeaveday = "ActualLeaveday"
        case appliedLeaveDays = "AppliedLeaveDays"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actualLeaveday = try values.decodeIfPresent(String.self, forKey: .actualLeaveday)
        appliedLeaveDays = try values.decodeIfPresent(String.self, forKey: .appliedLeaveDays)
    }

}
