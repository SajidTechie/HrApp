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
import CoreData

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
    
    
    class func getIPAddress() -> String? {
           var address : String?
           
           // Get list of all interfaces on the local machine:
           var ifaddr : UnsafeMutablePointer<ifaddrs>?
           guard getifaddrs(&ifaddr) == 0 else { return nil }
           guard let firstAddr = ifaddr else { return nil }
           
           // For each interface ...
           for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
               let interface = ifptr.pointee
               
               // Check for IPv4 or IPv6 interface:
               let addrFamily = interface.ifa_addr.pointee.sa_family
               if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                   
                   // Check interface name:
                   let name = String(cString: interface.ifa_name)
                   if  name == "en0" || name == "pdp_ip0" {
                       
                       // Convert interface address to a human readable string:
                       var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                       getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                   &hostname, socklen_t(hostname.count),
                                   nil, socklen_t(0), NI_NUMERICHOST)
                       address = String(cString: hostname)
                   }
               }
           }
           freeifaddrs(ifaddr)
           
           return (address ?? "")!
       }
    
    
    // - - - - - - - - Function to compress image -  - - - - - - - - -- -
    class func compressImage (_ image: UIImage) -> Data {
          
          let actualHeight:CGFloat = image.size.height
          let actualWidth:CGFloat = image.size.width
          let imgRatio:CGFloat = actualWidth/actualHeight
          let maxWidth:CGFloat = 1024.0
          let resizedHeight:CGFloat = maxWidth/imgRatio
          let compressionQuality:CGFloat = 0.5
          
          let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
          UIGraphicsBeginImageContext(rect.size)
          image.draw(in: rect)
          let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
          
        let imageData:Data = img.jpegData(compressionQuality: compressionQuality)!
          UIGraphicsEndImageContext()
          
          return imageData
          
      }
    
}


