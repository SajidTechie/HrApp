
import UIKit

class Item {
    var ImageName: String
    var CatName: String
    
    init(ImageName: String?, CatName: String?) {
        self.ImageName = ImageName ?? ""
        self.CatName = CatName ?? ""
    }
}

class HomeController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var catViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCheckin: RoundButton!
    let cellIdentifier = "ItemCollectionViewCell"
    
    @IBOutlet weak var imageSliderHoliday: CPImageSlider!
    @IBOutlet weak var imageSliderBirthDay: CPImageSlider!
    @IBOutlet weak var imageSliderAnniversary: CPImageSlider!
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 2
    var itemWidth:Double = 0.0
    
    var imgSliderArr = [String]()
    var items: [Item] = []
    
    var upcomingAnniversaryElementMain : UpcomingAnniversaryElement!
    var upcomingAnniversaryArray = [UpcomingAnniversaryData]()
    
    var upcomingBirthdaysElementMain : UpcomingBirthdayElement!
    var upcomingBirthdaysArray = [UpcomingBirthdayData]()
    
    var upcomingHolidaysElementMain : HolidayListElement!
    var upcomingHolidaysArray = [HolidayListData]()
    
    var errorData = [ErrorsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        
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
    func apiUpcomingAnniversaryList(){
        let json: [String: Any] = ["ClientID": "string","ClientSecret": "string"]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_ANNIVERSARY, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
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
        let json: [String: Any] = ["ClientID": "string","ClientSecret": "string"]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_HOLIDAY, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
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
        let json: [String: Any] = ["ClientID": "string","ClientSecret": "string"]
        
        DataManager.shared.makeAPICall(url: AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_BIRTHDAYS, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
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
