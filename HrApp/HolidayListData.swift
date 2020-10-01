//
//  HolidayListData.swift
//  HrApp
//
//  Created by Goldmedal on 1/27/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation

struct HolidayListElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [HolidayListData]?
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
        data = try values.decodeIfPresent([HolidayListData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}


struct HolidayListData : Codable {
    let holidayFromDate : String?
    let holidayToDate : String?
    let holidayName : String?
     let fromDateDay : String?
   
     let toDateDay : String?
     let fromDateFormat : String?
     let toDateFormat : String?
     let description : String?

    enum CodingKeys: String, CodingKey {

        case holidayFromDate = "HolidayFromDate"
        case holidayToDate = "HolidayToDate"
        case holidayName = "HolidayName"
        case fromDateDay = "FromDateDay"
        case toDateDay = "ToDateDay"
        case fromDateFormat = "FromDateFormat"
        case toDateFormat = "ToDateFormat"
        case description = "Description"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        holidayFromDate = try values.decodeIfPresent(String.self, forKey: .holidayFromDate)
        holidayToDate = try values.decodeIfPresent(String.self, forKey: .holidayToDate)
        holidayName = try values.decodeIfPresent(String.self, forKey: .holidayName)
        fromDateDay = try values.decodeIfPresent(String.self, forKey: .fromDateDay)
        toDateDay = try values.decodeIfPresent(String.self, forKey: .toDateDay)
        fromDateFormat = try values.decodeIfPresent(String.self, forKey: .fromDateFormat)
        toDateFormat = try values.decodeIfPresent(String.self, forKey: .toDateFormat)
        description = try values.decodeIfPresent(String.self, forKey: .description)
       
    }
}
