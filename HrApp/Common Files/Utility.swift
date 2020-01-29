//
//  CheckConnection.swift
//  DealorsApp
//
//  Created by Goldmedal on 4/26/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit


public class Utility {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    
    
    class func formatRupee(amount: Double) -> String{
        let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
        formatter.locale = Locale(identifier: "en_IN") // Here indian locale with english language is used
        formatter.numberStyle = .decimal               // Change to `.currency` if needed
        
        if(!amount.isNaN && amount.isFinite){
            let formattedAmount = "\u{20B9}" + formatter.string(from: NSNumber(value: Int(amount.rounded())))! // "10,00,000"
            return formattedAmount
        }
        else{
            return "-"
        }
    }
    
    class func formatRupeeWithDecimal(amount: Double) -> String{
        let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
        formatter.numberStyle = .decimal // Here indian locale with english language is used
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        formatter.locale = Locale.current
        
        if(!amount.isNaN && amount.isFinite){
            let formattedAmount = "\u{20B9}" + formatter.string(from: NSNumber(value: Double(amount)))!
            return formattedAmount
        }
        else{
            return "-"
        }
    }
    
    
    class func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return "-"
    }
    
    class func formattedDateTimeWorldCup(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return "-"
    }
    
    
    class func getDeviceId() -> String{
           var deviceId = ""
            deviceId = UIDevice.current.identifierForVendor!.uuidString
               if(deviceId.isEqual("")){
                   deviceId = "-"
               }
           return deviceId
       }
    
    
    class func currDate() -> String{
        //Get current date
        let currDate = Date()
        var dateFormatter = DateFormatter()
        var strCurrDate = ""
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        strCurrDate = dateFormatter.string(from: currDate)
        strCurrDate = Utility.formattedDateFromString(dateString: strCurrDate, withFormat: "MM/dd/yyyy")!
        
        return strCurrDate
    }
    
    //For downloading pdf file
    private static var session:URLSession = URLSession(configuration: .default)
    private static var downloadTask: URLSessionDownloadTask?
    
    private static func getLocalDirectory() -> URL? {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentPath = paths.first
        let directoryPath = documentPath?.appendingPathComponent("Downloads")
        
        guard let path = directoryPath else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            }catch {
                
            }
            
        }
        print("Path -- -- ",path)
        return path
    }
    
    
    
    public static func downloadFile(fileName:String, url:URL) {
        downloadTask = session.downloadTask(with: url, completionHandler: { (_location, _response, _error) in
            if _error == nil {
                guard  let location = _location, var folderPath = getLocalDirectory() else {
                    return
                }
                
                folderPath = folderPath.appendingPathComponent(fileName)
                folderPath.appendPathExtension(".pdf")
                
                print("Filename -- -- ",fileName," -- --",url)
                
                do {
                    try FileManager.default.moveItem(at: location, to: folderPath)
                }catch {
                    
                }
            }
        })
        
        downloadTask?.resume()
    }
    
    
    class func currFinancialYear() -> String{
        var finYear = "2018-2019"
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        if (month >= 4) {
            finYear = String(String(year) + "-" + String(year + 1))
        } else {
            finYear = String(String(year - 1) + "-" + String(year))
        }
        return finYear
    }
    
    
}

extension UIView{
    func GradientView() {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = self.frame
        let color1 = UIColor(red: 95.0/255.0, green: 106.0/255.0, blue: 175.0/255.0, alpha: 1)
        let color2 = UIColor(red: 63.0/255.0, green: 120.0/255.0, blue: 152.0/255.0, alpha: 1)
        let color3 = UIColor(red: 6.0/255.0, green: 151.0/255.0, blue: 114.0/255.0, alpha: 1)
        gradientColor.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientColor.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        self.layer.insertSublayer(gradientColor, at: 0)
    }
}


extension UIButton{
    func GradientButton() {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = self.frame
        let color1 = UIColor(red: 95.0/255.0, green: 106.0/255.0, blue: 175.0/255.0, alpha: 1)
        let color2 = UIColor(red: 63.0/255.0, green: 120.0/255.0, blue: 152.0/255.0, alpha: 1)
        let color3 = UIColor(red: 6.0/255.0, green: 151.0/255.0, blue: 114.0/255.0, alpha: 1)
        gradientColor.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
        self.layer.insertSublayer(gradientColor, at: 0)
        
        gradientColor.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
}

