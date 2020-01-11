//
//  HomeController.swift
//  HrApp
//
//  Created by Goldmedal on 1/6/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class DashboardController: BaseViewController {

    let tabBarCnt = UITabBarController()

        override func viewDidLoad() {
            super.viewDidLoad()
            
             addSlideMenuButton()
            
            let imageView = UIImageView(image:UIImage(named: "dashboard_logo.png"))
                   self.navigationItem.titleView = imageView
            
            let notiImage = UIImage(named: "notification.png")
            let notiButton = UIBarButtonItem(image: notiImage,  style: .plain, target: self, action: #selector(didTapNotiButton))
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            navigationItem.rightBarButtonItems = [notiButton]
            
            // Do any additional setup after loading the view, typically from a nib.
            tabBarCnt.tabBar.tintColor = UIColor.cyan
            tabBarCnt.tabBar.unselectedItemTintColor = UIColor.lightGray
            tabBarCnt.tabBar.barTintColor = UIColor.black
            
            createTabBarController()
        }
    
        @objc func didTapNotiButton(sender: AnyObject){
              print("noti clicked")
          }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


          func createTabBarController() {
            
            let homeStoryBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let leaveStoryBoard: UIStoryboard = UIStoryboard(name: "Leaves", bundle: nil)
            
            let homeVc = homeStoryBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            homeVc.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "homeMenu"), tag: 0)
            
            let attdVc = leaveStoryBoard.instantiateViewController(withIdentifier: "CalendarLeaveController") as! CalendarLeaveController
            attdVc.tabBarItem = UITabBarItem.init(title: "Attendance", image: UIImage(named: "attendanceMenu"), tag: 1)
            
            let leaveVc = leaveStoryBoard.instantiateViewController(withIdentifier: "LeaveApplicationController") as! LeaveApplicationController
            leaveVc.tabBarItem = UITabBarItem.init(title: "Leaves", image: UIImage(named: "leavesMenu"), tag: 2)
            
            let profileVc = homeStoryBoard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
            profileVc.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage(named: "profileMenu"), tag: 3)

            let controllerArray = [homeVc,attdVc,leaveVc,profileVc]
            tabBarCnt.viewControllers = controllerArray.map{ UINavigationController.init(rootViewController: $0)}
            
            self.view.addSubview(tabBarCnt.view)
        }
        
    }
