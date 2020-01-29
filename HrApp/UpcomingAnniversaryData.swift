//
//  UpcomingBirthdaysData.swift
//  HrApp
//
//  Created by Goldmedal on 1/15/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct UpcomingAnniversaryElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [UpcomingAnniversaryData]?
    let errors : [String]?

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
        data = try values.decodeIfPresent([UpcomingAnniversaryData].self, forKey: .data)
        errors = try values.decodeIfPresent([String].self, forKey: .errors)
    }

}


struct UpcomingAnniversaryData : Codable {
    let employeeName : String?
    let anniversarydate : String?

    enum CodingKeys: String, CodingKey {

        case employeeName = "EmployeeName"
        case anniversarydate = "Anniversarydate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employeeName = try values.decodeIfPresent(String.self, forKey: .employeeName)
        anniversarydate = try values.decodeIfPresent(String.self, forKey: .anniversarydate)
    }

}
