//
//  LeaveReasonsData.swift
//  HrApp
//
//  Created by Goldmedal on 04/02/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct LeaveReasonsElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [LeaveReasonsData]?
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
        data = try values.decodeIfPresent([LeaveReasonsData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}


struct LeaveReasonsData : Codable {
    let leaveReasonID : String?
    let remarks : String?

    
    init(leaveReasonID: String, remarks: String) { // default struct initializer
      self.leaveReasonID = leaveReasonID
      self.remarks = remarks
     
    }
    
    enum CodingKeys: String, CodingKey {

        case leaveReasonID = "LeaveReasonID"
        case remarks = "Remarks"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        leaveReasonID = try values.decodeIfPresent(String.self, forKey: .leaveReasonID)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
    }

}
