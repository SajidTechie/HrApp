
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
    
     @IBOutlet weak var imageSliderBirthDay: CPImageSlider!
     @IBOutlet weak var imageSliderAnniversary: CPImageSlider!
    
    let inset: CGFloat = 10
       let minimumLineSpacing: CGFloat = 10
       let minimumInteritemSpacing: CGFloat = 10
       let cellsPerRow = 2
       var itemWidth:Double = 0.0

    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCheckin.GradientButton()
        
        imageSliderBirthDay.autoSrcollEnabled = true
        imageSliderAnniversary.autoSrcollEnabled = true
        imageSliderBirthDay.showOnlyImages = false
        imageSliderAnniversary.showOnlyImages = false
        self.imageSliderBirthDay.images = ["attendance","report","approval","leaves","expense"]
        self.imageSliderAnniversary.images = ["attendance","report","approval","leaves","expense"]
      
        
        items = [Item(ImageName: "attendance", CatName: "Attendance"),
                 Item(ImageName: "report", CatName: "Report"),
                 Item(ImageName: "approval", CatName: "Approval"),
                 Item(ImageName: "leaves", CatName: "Leaves"),
                 Item(ImageName: "announcement", CatName: "Announcement"),
                 Item(ImageName: "expense", CatName: "Expenses")
        ]
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView.reloadData()

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
