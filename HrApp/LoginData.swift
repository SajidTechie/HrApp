//
//  LoginData.swift
//  HrApp
//
//  Created by Goldmedal on 1/15/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

struct LoginElement : Codable {
    let version : String?
    let statusCode : Int?
    let statusCodeMessage : String?
    let timestamp : String?
    let size : Int?
    let data : [LoginData]?
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
        data = try values.decodeIfPresent([LoginData].self, forKey: .data)
        errors = try values.decodeIfPresent([ErrorsData].self, forKey: .errors)
    }

}


struct LoginData : Codable {
    
    let uniqueUserID : Int?
    let isHr : Int?
    let employeeID : String?
    let employeeFullName : String?
    let profilePicture : String?
    let officialemail : String?
    let joiningDate : String?
    let firstName : String?
    let middleName : String?
    let lastName : String?
    let nickName : String?
    let dateOfBirth : String?
    let employeeCode : String?
    let designation : String?
    let reportingPerson : String?
    let department : String?
    let branchName : String?
    let officeAddress : String?
    let officePincode : String?
    let officeConNumber : String?
    let gender : String?
    let genderid : Int?
    let maritalStatus : String?
    let maritalID : Int?
    let homeAddress : String?

    enum CodingKeys: String, CodingKey {

        case uniqueUserID = "ID"
        case isHr = "ISHr"
        case employeeID = "EmployeeID"
        case employeeFullName = "EmployeeFullName"
        case profilePicture = "ProfilePicture"
        case officialemail = "Officialemail"
        case joiningDate = "joiningDate"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case nickName = "NickName"
        case dateOfBirth = "DateOfBirth"
        case employeeCode = "EmployeeCode"
        case designation = "Designation"
        case reportingPerson = "ReportingPerson"
        case department = "Department"
        case branchName = "BranchName"
        case officeAddress = "OfficeAddress"
        case officePincode = "OfficePincode"
        case officeConNumber = "OfficeConNumber"
        case gender = "Gender"
        case genderid = "Genderid"
        case maritalStatus = "MaritalStatus"
        case maritalID = "MaritalID"
        case homeAddress = "HomeAddress"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
         uniqueUserID = try values.decodeIfPresent(Int.self, forKey: .uniqueUserID)
         isHr = try values.decodeIfPresent(Int.self, forKey: .isHr)
         employeeID = try values.decodeIfPresent(String.self, forKey: .employeeID)
        employeeFullName = try values.decodeIfPresent(String.self, forKey: .employeeFullName)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        officialemail = try values.decodeIfPresent(String.self, forKey: .officialemail)
        joiningDate = try values.decodeIfPresent(String.self, forKey: .joiningDate)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        middleName = try values.decodeIfPresent(String.self, forKey: .middleName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
        employeeCode = try values.decodeIfPresent(String.self, forKey: .employeeCode)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        reportingPerson = try values.decodeIfPresent(String.self, forKey: .reportingPerson)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        branchName = try values.decodeIfPresent(String.self, forKey: .branchName)
        officeAddress = try values.decodeIfPresent(String.self, forKey: .officeAddress)
        officePincode = try values.decodeIfPresent(String.self, forKey: .officePincode)
        officeConNumber = try values.decodeIfPresent(String.self, forKey: .officeConNumber)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        genderid = try values.decodeIfPresent(Int.self, forKey: .genderid)
        maritalStatus = try values.decodeIfPresent(String.self, forKey: .maritalStatus)
        maritalID = try values.decodeIfPresent(Int.self, forKey: .maritalID)
        homeAddress = try values.decodeIfPresent(String.self, forKey: .homeAddress)
    }

}
