
import UIKit

class Item {
    var ImageName: String
    var CatName: String
    
    init(ImageName: String?, CatName: String?) {
        self.ImageName = ImageName ?? ""
        self.CatName = CatName ?? ""
    }
}

class HomeController: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCheckin: RoundButton!
    let cellIdentifier = "ItemCollectionViewCell"
    
    @IBOutlet weak var imageSliderHoliday: CPImageSlider!
    @IBOutlet weak var imageSliderBirthDay: CPImageSlider!
    @IBOutlet weak var imageSliderAnniversary: CPImageSlider!
    
    @IBOutlet weak var lblCheckInMonth: UILabel!
    @IBOutlet weak var lblcheckInDate: UILabel!
    @IBOutlet weak var lblLastCheckInTime: UILabel!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var vwCheckIn: UIView!
    @IBOutlet weak var vwCheckOut: UIView!
    
    var strActualPunchInTime = ""
    
    var timer = Timer()
    var (hours,minutes,seconds) = (0,0,0)
    
    var imgSliderArr = [String]()
    var items: [Item] = []
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 2
    var itemWidth:Double = 0.0
    
    var PunchStatusElementMain : PunchStatusElement!
    var PunchStatusDataMain = [PunchStatusData]()
    
    var upcomingAnniversaryElementMain : UpcomingAnniversaryElement!
    var upcomingAnniversaryArray = [UpcomingAnniversaryData]()
    
    var upcomingBirthdaysElementMain : UpcomingBirthdayElement!
    var upcomingBirthdaysArray = [UpcomingBirthdayData]()
    
    var upcomingHolidaysElementMain : HolidayListElement!
    var upcomingHolidaysArray = [HolidayListData]()
    
    var errorData = [ErrorsData]()
    
    var checkPunchStatus = false
    
    var ifAttendanceAllowed = String()
    
    var punchInTime = 0
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        let loginData =  UserDefaults.standard.value(forKey: "loginData") as? Dictionary ?? [:]
         userId = loginData["EmployeeID"] as? String ?? "-"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        
        var showCurrDate = dateFormatterPrint.string(from: Date()).components(separatedBy: " ")
        var strMonthName = showCurrDate[0]
        var strDate = showCurrDate[1]
        
        lblCheckInMonth.text = strMonthName
        lblcheckInDate.text = strDate
        
        checkPunchStatus = (UserDefaults.standard.bool(forKey: "punchStatus") as! Bool)
        
        if(UserDefaults.standard.value(forKey: "punchInTime") != nil){
            strActualPunchInTime = UserDefaults.standard.value(forKey: "punchInTime") as! String
        }
        
        if (!checkPunchStatus){
            self.btnCheckin.setTitle("Check In", for: .normal)
            vwCheckIn.isHidden = false
            vwCheckOut.isHidden = true
        }else{
            self.btnCheckin.setTitle("Check Out", for: .normal)
            vwCheckIn.isHidden = true
            vwCheckOut.isHidden = false
        }
        
        let imageView = UIImageView(image:UIImage(named: "dashboard_logo.png"))
        self.navigationItem.titleView = imageView
        
        let notiImage = UIImage(named: "notification.png")
        let notiButton   = UIBarButtonItem(image: notiImage,  style: .plain, target: self, action: #selector(didTapNotiButton))
        
        navigationItem.rightBarButtonItems = [notiButton]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        if(UserDefaults.standard.value(forKey: "punchInTime") != nil){
            strActualPunchInTime = UserDefaults.standard.value(forKey: "punchInTime") as! String
        }
        
        imageSliderBirthDay.showOnlyImages = false
        imageSliderAnniversary.showOnlyImages = false
        imageSliderHoliday.showOnlyImages = false
        
        imageSliderBirthDay.autoSrcollEnabled = true
        imageSliderAnniversary.autoSrcollEnabled = true
        imageSliderHoliday.autoSrcollEnabled = true
        
        imageSliderBirthDay.isBirthday = 0
        imageSliderAnniversary.isBirthday = 1
        imageSliderHoliday.isBirthday = 2
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView.reloadData()
        
        if (Utility.isConnectedToNetwork()) {
            apiPunchStatus()
            apiUpcomingAnniversaryList()
            apiUpcomingBirthdaysList()
            apiUpcomingHolidayList()
        }
        else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
            let anniversaryData =  UserDefaults.standard.value(forKey: "anniversaryData") as? [NSDictionary] ?? []
            let birthdayData =  UserDefaults.standard.value(forKey: "birthdayData") as? [NSDictionary] ?? []
            let holidayData =  UserDefaults.standard.value(forKey: "holidayData") as? [NSDictionary] ?? []
            
            mergeAnniversaryData(arr: anniversaryData)
            mergeHolidayData(arr: holidayData)
            mergeBirthdayData(arr: birthdayData)
            
            if(!strActualPunchInTime.isEmpty){
                setTotalPunchTime(strPunchIn: strActualPunchInTime)
            }
        }
        
    }
    
    
    func setTotalPunchTime(strPunchIn:String){
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        let dateFormatterShow = DateFormatter()
        dateFormatterShow.dateFormat = "hh:mm:ss a"
        
        let dateInput: Date? = dateFormatterGet.date(from: strPunchIn)
        
        var time1Str = dateFormatterShow.string(from: dateInput!)
        print("Time 1 **********",time1Str)
        var todaysDate = Date()
        
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm:ss a"
        
        var time2Str = timeformatter.string(from: todaysDate)
        print("Time 2 **********",time2Str)
        
        var time1 = timeformatter.date(from: time1Str)
        var time2 = timeformatter.date(from: time2Str)
        punchInTime = Int(time2!.timeIntervalSince(time1!))
        print("punchInTime  -- - ",punchInTime)
        
        // timer logic
        if(dateInput == todaysDate){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showTime), userInfo: nil, repeats: true)
        }else{
            print("Date mismatch")
            return
        }
        
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d",hours, minutes, seconds)
    }
    
    @objc func showTime(){
        lblTimer.text = "\(timeFormatted(punchInTime))"
        
        punchInTime += 1
    }
    
    
    @objc func didTapNotiButton(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Notification")
    }
    
    
    @IBAction func click_checkIn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PunchInOut", bundle: nil)
        let vcMap = storyBoard.instantiateViewController(withIdentifier: "MapPunchInOutController") as! MapPunchInOutController
       let navController = UINavigationController(rootViewController: vcMap)
        self.navigationController?.present(navController, animated: true, completion: nil)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
            self.catViewHeight.constant = CGFloat((self.itemWidth + 20.0) * ceil(Double(Double(self.items.count)/2.0)))
            print("Height - - - -",self.itemWidth," - - - - ",ceil(Double(Double(self.items.count)/2.0))," - - - ",self.catViewHeight.constant)
        }
    }
    
    //API CALL for anniversary list - - - - - - - -
    func apiPunchStatus(){
        let json: [String: Any] = ["UserID": userId,"ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.GET_PUNCH_STATUS, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            print("status punch - - -",json)
            
            DispatchQueue.main.async {
                
                do {
                    self.PunchStatusElementMain = try JSONDecoder().decode(PunchStatusElement.self, from: data!)
                    self.PunchStatusDataMain = self.PunchStatusElementMain.data ?? []
                    
                    self.errorData = self.PunchStatusElementMain.errors ?? []
                    
                    if (self.PunchStatusElementMain.statusCode == 200){
                        self.checkPunchStatus = self.PunchStatusDataMain[0].status ?? false
                        
                        UserDefaults.standard.set(self.checkPunchStatus, forKey: "punchStatus")
                        
                        if(self.checkPunchStatus){
                            self.btnCheckin.setTitle("Check Out", for: .normal)
                            self.vwCheckIn.isHidden = true
                            self.vwCheckOut.isHidden = false
                        }else{
                            self.btnCheckin.setTitle("Check In", for: .normal)
                            self.vwCheckIn.isHidden = false
                            self.vwCheckOut.isHidden = true
                        }
                        
                    }
                    if(!self.strActualPunchInTime.isEmpty){
                        self.setTotalPunchTime(strPunchIn: self.strActualPunchInTime)
                    }
                    
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                    if(!self.strActualPunchInTime.isEmpty){
                        self.setTotalPunchTime(strPunchIn: self.strActualPunchInTime)
                    }
                }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            if(!self.strActualPunchInTime.isEmpty){
                self.setTotalPunchTime(strPunchIn: self.strActualPunchInTime)
            }
        }
        
    }
    
    //API CALL for anniversary list - - - - - - - -
    func apiUpcomingAnniversaryList(){
        let json: [String: Any] = ["ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_ANNIVERSARY, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            print("anniversary - - -",json)
            
            DispatchQueue.main.async {
                
                do {
                    let responseData =   try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.upcomingAnniversaryElementMain = try JSONDecoder().decode(UpcomingAnniversaryElement.self, from: data!)
                    
                    self.errorData = self.upcomingAnniversaryElementMain.errors ?? []
                    
                    if (self.upcomingAnniversaryElementMain.statusCode == 200){
                        let arr = (responseData as? NSDictionary)?["Data"] as? [NSDictionary]
                        UserDefaults.standard.set(arr, forKey: "anniversaryData")
                        print("anniversaryData - - ",arr?.count)
                        
                        self.mergeAnniversaryData(arr: arr!)
                    }
                    
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
        }
    }
    
    // Api call for holiday list  - - - - - - - - -
    func apiUpcomingHolidayList(){
        let json: [String: Any] = ["ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_HOLIDAY, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            print("Holiday", json)
            
            DispatchQueue.main.async {
                
                do {
                    let responseData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.upcomingHolidaysElementMain = try JSONDecoder().decode(HolidayListElement.self, from: data!)
                    
                    self.errorData = self.upcomingHolidaysElementMain.errors ?? []
                    
                    if (self.upcomingHolidaysElementMain.statusCode == 200){
                        let arr = (responseData as? NSDictionary)?["Data"] as? [NSDictionary]
                        UserDefaults.standard.set(arr, forKey: "holidayData")
                        print("holidayData - - ",arr?.count)
                        
                        self.mergeHolidayData(arr: arr!)
                        
                    }
                    
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                }
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            
        }
    }
    
    
    // Api call for birthday list  - - - - - - - - -
    func apiUpcomingBirthdaysList(){
        let json: [String: Any] = ["ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_BIRTHDAYS, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            print("birthday - - -",json)
            
            DispatchQueue.main.async {
                
                do {
                    let responseData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    self.upcomingBirthdaysElementMain = try JSONDecoder().decode(UpcomingBirthdayElement.self, from: data!)
                    self.upcomingBirthdaysArray = self.upcomingBirthdaysElementMain.data ?? []
                    self.errorData = self.upcomingBirthdaysElementMain.errors ?? []
                    
                    if (self.upcomingBirthdaysElementMain.statusCode == 200){
                        let arr = (responseData as? NSDictionary)?["Data"] as? [NSDictionary]
                        UserDefaults.standard.set(arr, forKey: "birthdayData")
                        print("birthdayData - - ",arr?.count)
                        
                        self.mergeBirthdayData(arr: arr!)
                        
                    }
                    
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            
        }
    }
    
    
    func mergeBirthdayData(arr:[NSDictionary]){
        var BirthNameArray: [String] = []
        var BirthDateArray: [String] = []
        
        for (birth) in arr {
            let BirthName: String? = birth.value(forKey: "EmployeeName") as? String
            BirthNameArray.append(BirthName ?? "-")
            
            let BirthDate: String? = birth.value(forKey: "Birthdate") as? String
            BirthDateArray.append(BirthDate ?? "-")
        }
        
        self.imageSliderBirthDay.labelStr = BirthNameArray
        self.imageSliderBirthDay.labelDate = BirthDateArray
        self.imageSliderBirthDay.images = BirthDateArray
    }
    
    func mergeAnniversaryData(arr:[NSDictionary]){
        var annvNameArray: [String] = []
        var annvDateArray: [String] = []
        
        for (anniversary) in arr {
            let annvName: String? = anniversary.value(forKey: "EmployeeName") as? String
            annvNameArray.append(annvName ?? "-")
            
            let annvDate: String? = anniversary.value(forKey: "Anniversarydate") as? String
            annvDateArray.append(annvDate ?? "-")
        }
        
        self.imageSliderAnniversary.labelStr = annvNameArray
        self.imageSliderAnniversary.labelDate = annvDateArray
        self.imageSliderAnniversary.images = annvNameArray
    }
    
    func mergeHolidayData(arr:[NSDictionary]){
        var holNameArray: [String] = []
        var holDateArray: [String] = []
        
        for (holiday) in arr {
            let holName: String? = holiday.value(forKey: "HolidayName") as? String
            holNameArray.append(holName ?? "-")
            
            let holDate: String? = holiday.value(forKey: "HolidayFromDate") as? String
            holDateArray.append(holDate ?? "-")
        }
        
        self.imageSliderHoliday.labelStr = holNameArray
        self.imageSliderHoliday.labelDate = holDateArray
        self.imageSliderHoliday.images = holNameArray
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        
        cell.catName.text = items[indexPath.item].CatName
        cell.imageView.image = UIImage(named:items[indexPath.item].ImageName)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index(/indexPath)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        itemWidth = Double(((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down))
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
}




class IntrinsicCollectionView: UICollectionView {
    var showNoData = false
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        return CGSize(width: UIView.noIntrinsicMetric, height: (showNoData) ? 300 : contentSize.height)
    }
    
}


class IntrinsicTableView: UITableView {
    var showNoData = false
    var height: CGFloat = 0.0
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        if(showNoData){
            height = 300
        }
        
        
        return CGSize(width: UIView.noIntrinsicMetric, height: (showNoData) ? height : contentSize.height)
    }
}
