//
//  ProfileController.swift
//  HrApp
//
//  Created by Goldmedal on 04/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var profileCard : UIView!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var employeeCodeLbl: UILabel!
    @IBOutlet weak var officeEmailLbl: UILabel!
    @IBOutlet weak var joiningDateLbl: UILabel!
    @IBOutlet weak var DOBLbl: UILabel!
    @IBOutlet weak var reportingPersonLbl: UILabel!
    @IBOutlet weak var branchLbl: UILabel!
    @IBOutlet weak var officeAddressLbl: UILabel!
    @IBOutlet weak var homeAddressLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    
    @IBOutlet weak var employeeNameLbl: UILabel!
    @IBOutlet weak var employeeDesignationLbl: UILabel!
    
    @IBAction func changePasswordClicked(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vcChangePassword = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
        vcChangePassword.callFrom = "ChangePassword"
        
        let navController = UINavigationController(rootViewController: vcChangePassword)
        self.navigationController?.present(navController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginData =  UserDefaults.standard.value(forKey: "loginData") as? Dictionary ?? [:]
        
        employeeNameLbl.text = loginData["EmployeeFullName"] as? String ?? "-"
        employeeDesignationLbl.text = "\(loginData["Department"] as? String ?? "-") - \(loginData["Designation"] as? String ?? "-")"
        
        profileImage.sd_setImage(with: URL(string: loginData["ProfilePicture"] as? String ?? ""), placeholderImage: UIImage(named: "profile.png"))
        
        employeeCodeLbl.text = loginData["EmployeeCode"] as? String ?? "-"
        officeEmailLbl.text = loginData["Officialemail"] as? String ?? "-"
        joiningDateLbl.text = loginData["joiningDate"] as? String ?? "-"
        DOBLbl.text = loginData["DateOfBirth"] as? String ?? "-"
        reportingPersonLbl.text = loginData["ReportingPerson"] as? String ?? "-"
        branchLbl.text = loginData["BranchName"] as? String ?? "-"
        officeAddressLbl.text = loginData["OfficeAddress"] as? String ?? "-"
        homeAddressLbl.text = loginData["HomeAddress"] as? String ?? "-"
        
        versionLbl.text = AppConstants.APP_VERSION
    }
    
}
