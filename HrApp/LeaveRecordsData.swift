//
//  LeaveRecordsElement.swift
//  HrApp
//
//  Created by Goldmedal on 29/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//


import Foundation
struct LeaveRecordsElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [LeaveRecordsData]?
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
        data = try values.decodeIfPresent([LeaveRecordsData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}


struct LeaveRecordsData : Codable {
    let employeeID : String?
    let leaveType : String?
    let appliedDate : String?
    let startDate : String?
    let endDate : String?
    let status : String?
    let leaveDays : Int?

    enum CodingKeys: String, CodingKey {

        case employeeID = "EmployeeID"
        case leaveType = "LeaveType"
        case appliedDate = "AppliedDate"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case status = "Status"
        case leaveDays = "LeaveDays"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employeeID = try values.decodeIfPresent(String.self, forKey: .employeeID)
        leaveType = try values.decodeIfPresent(String.self, forKey: .leaveType)
        appliedDate = try values.decodeIfPresent(String.self, forKey: .appliedDate)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        leaveDays = try values.decodeIfPresent(Int.self, forKey: .leaveDays)
    }

}
