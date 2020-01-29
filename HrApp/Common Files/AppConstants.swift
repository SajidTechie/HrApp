//
//  AppConstants.swift
//  HrApp
//
//  Created by Goldmedal on 1/15/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import Foundation
struct AppConstants {
    
    //URLS - - -
    public static let PROD_BASE_URL  = "https://goldapi.goldmedalindia.in/api/hrm/v1.0/"
    public static let TESTING_BASE_URL = "https://goldapi.goldmedalindia.in/api/hrm/v1.0/"
    
    
    //CONTROLLERS - - -
    public static let LOGIN = "Login/authenticate"
    public static let GET_OTP = "otp/sendotp"
    public static let VERIFY_OTP = "otp/verifyotp"
    public static let RESET_PASSWORD = "password/forgetpassword"
    public static let UPCOMING_BIRTHDAYS = "events/getBirthdaysInWeek"
    public static let UPCOMING_ANNIVERSARY = "events/getAnniversaryInWeek"
    public static let UPCOMING_HOLIDAY = "events/getHolidayList"
}

