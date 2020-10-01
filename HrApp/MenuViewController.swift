//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
     func slideMenuItemSelectedAtIndex(_ sectionIndex : Int,_ itemIndex : Int,_ screen : String)
}

class MenuViewController: UIViewController {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    //  var arrayMenuOptions = [Dictionary<String,String>]()
    
    //var arrayMenuOptions = [NSMutableDictionary]()
    
    var expandData = [NSMutableDictionary]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imvProfileImage: UIImageView!
    
    var imageData: Data? = nil
    var strUserName = ""
    var screen = ""
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var itemIndex = -1
    var sectionIndex = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        self.imvProfileImage.layer.borderWidth = 2
        self.imvProfileImage.layer.masksToBounds = false
        self.imvProfileImage.layer.borderColor = UIColor.black.cgColor
        self.imvProfileImage.layer.cornerRadius = self.imvProfileImage.frame.size.width/2
        self.imvProfileImage.clipsToBounds = true
        
        
        if(imageData == nil)
        {
            imageData = UserDefaults.standard.object(forKey: "SavedImage") as? Data ?? nil
        }
        
        if(imageData != nil)
        {
            imvProfileImage.image = UIImage(data:imageData as! Data)
        }
    
        
        lblName.text = strUserName
       
        tblMenuOptions.sectionHeaderHeight = 50
        
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Home", "icon":"homeMenu","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Check In/Out", "icon":"location","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Leave History", "icon":"leaveRecord","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Attendance Stats", "icon":"attendanceMenu","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Holiday List", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Leave Approval", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Manager Account", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Notification", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"About Us", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Contact Us", "icon":"brand_loyalty_club_icon","data":[""]])
        self.expandData.append(["isCollapsible":"0","isOpen":"1","title":"Log Out", "icon":"brand_loyalty_club_icon","data":[""]])
    
      
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imvProfileImage.isUserInteractionEnabled = true
            imvProfileImage.addGestureRecognizer(tapGestureRecognizer)
            
            // let loginData =  UserDefaults.standard.value(forKey: "loginData") as? Dictionary ?? [:]
            self.tblMenuOptions.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0);
            
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            
        }
        
        
        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            let tappedImage = tapGestureRecognizer.view as! UIImageView
            let btn = UIButton(type: UIButton.ButtonType.custom)
            itemIndex = -2
            sectionIndex = -2

            self.onCloseMenuClick(btn)
            
            // Your action
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        @IBAction func onCloseMenuClick(_ button:UIButton!){
            btnMenu.tag = 0
            
            if (self.delegate != nil) {
                //  var index = Int32(button.tag)
                if(button == self.btnCloseMenuOverlay){
                    //  index = -1
                    sectionIndex = -1
                    itemIndex = -1
                }
                delegate?.slideMenuItemSelectedAtIndex(sectionIndex,itemIndex,screen)
            }
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
            })
        }
        
        class ExpandCell:UITableViewCell{
            @IBOutlet weak var expandLbl: UILabel!
        }
        
    }

    extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.expandData[section].value(forKey: "isOpen") as! String == "1"{
                return 0
            }else{
                let dataarray = self.expandData[section].value(forKey: "data") as! NSArray
                return dataarray.count
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return self.expandData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
            
            let dataarray = self.expandData[indexPath.section].value(forKey: "data") as! NSArray
            
            let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
            
            let vwMainRow : UIView = cell.contentView.viewWithTag(100) as! UIView
            
            lblTitle.text = (dataarray[indexPath.row] as? String)?.capitalized
            
            vwMainRow.backgroundColor = UIColor.white
          
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            headerView.backgroundColor = UIColor.white
            let separatorView = UIView(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width - 10, height: 1))
            if #available(iOS 11.0, *) {
                separatorView.backgroundColor = UIColor.init(named: "Primary")
            } else {
               separatorView.backgroundColor = UIColor.gray
            }
            if section != 0 {
                headerView.addSubview(separatorView)
            }
            
            let imgIcon = UIImageView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
            let imageIcon = UIImage(named: self.expandData[section].value(forKey: "icon") as! String);
            imgIcon.image = imageIcon;
            headerView.addSubview(imgIcon)
            
            let imgDropdownArrow = UIImageView(frame: CGRect(x: headerView.frame.size.width - 25, y: 17.5, width: 15, height: 15))
            
    //        if (section == 1 || section == 2)
    //        {
    //            let imageArrow = UIImage(named: "arrow_down");
    //            imgDropdownArrow.image = imageArrow;
    //            headerView.addSubview(imgDropdownArrow)
    //        }
         
            
            let label = UILabel(frame: CGRect(x: 50, y: 15, width: headerView.frame.size.width - 50, height: 20))
            label.text = (expandData[section]["title"]! as? String)?.capitalized
            label.font = UIFont(name: "Roboto-Regular", size: 13)
            headerView.addSubview(label)
            
            headerView.tag = section
            
            let tapgesture = UITapGestureRecognizer(target: self , action: #selector(self.sectionTapped(_:)))
            
            headerView.addGestureRecognizer(tapgesture)
            
            
            return headerView
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
        
        
        @objc func sectionTapped(_ sender: UITapGestureRecognizer){
            
            print("---------------INDEX FOR HEADER----------",(sender.view?.tag)!)
            
            if self.expandData[(sender.view?.tag)!].value(forKey: "isCollapsible") as! String == "1"{
                if(self.expandData[(sender.view?.tag)!].value(forKey: "isOpen") as! String == "1"){
                    self.expandData[(sender.view?.tag)!].setValue("0", forKey: "isOpen")
                }else{
                    self.expandData[(sender.view?.tag)!].setValue("1", forKey: "isOpen")
                }
                self.tblMenuOptions.reloadSections(IndexSet(integer: (sender.view?.tag)!), with: .automatic)
            }else{
                let btn = UIButton(type: UIButton.ButtonType.custom)
                btn.tag = (sender.view?.tag)!
                sectionIndex = (sender.view?.tag)!
                screen = self.expandData[sectionIndex].value(forKey: "title") as! String
                
                self.onCloseMenuClick(btn)
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let btn = UIButton(type: UIButton.ButtonType.custom)
            itemIndex = indexPath.row
            sectionIndex = indexPath.section
            screen = self.expandData[indexPath.section].value(forKey: "title") as! String
            print("didSelectRowAt - -- - - - -",screen)
        }

    }
