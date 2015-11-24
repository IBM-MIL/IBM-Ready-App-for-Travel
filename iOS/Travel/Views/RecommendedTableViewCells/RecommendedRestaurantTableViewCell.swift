/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var preferredView: UIView!
    @IBOutlet weak var preferredLabel: UILabel!
    @IBOutlet weak var preferredImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var reviewsFromLabel: UILabel!
    @IBOutlet weak var expensiveLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!

    
    /**
    Method that is called when it wakes from nib and sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that sets the cell as selected and ensures the preferred view's background stays the same
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        let color = preferredView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            preferredView.backgroundColor = color
        }
    }
    
    
    /**
    Method that sets the cell as highlighted and ensures the preferred view's background stays the same
    
    - parameter highlighted: Bool
    - parameter animated:    Bool
    */
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = preferredView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            preferredView.backgroundColor = color
        }
    }
    
    
    /**
    Method that sets up the UI of the view
    */
    func setupView() {
        titleLabel.textColor = UIColor.travelDarkMainFontColor()
        titleLabel.font = UIFont.travelSemiBold(17)
        
        
        subTitleLabel.textColor = UIColor.travelLightMainFontColor()
        subTitleLabel.font = UIFont.travelRegular(11)
        
        reviewsFromLabel.textColor = UIColor.travelLightMainFontColor()
        reviewsFromLabel.font = UIFont.travelRegular(10)
        
        preferredView.backgroundColor = UIColor.travelDarkMainFontColor()
        preferredLabel.textColor = UIColor.whiteColor()
        preferredLabel.font = UIFont.travelRegular(11)
        
        expensiveLabel.textColor = UIColor.travelDarkMainFontColor()
        expensiveLabel.font = UIFont.travelRegular(17)
        
        distanceLabel.textColor = UIColor.travelDarkMainFontColor()
        distanceLabel.font = UIFont.travelRegular(11)
    }
    
    
    /**
    Method that sets up the data of the view
    
    - parameter restaurantTitle:  String?
    - parameter typeOfRestaurant: String?
    - parameter distance:         String?
    - parameter rating:           Double?
    - parameter expensiveness:    Double?
    - parameter imageURL:         String?
    - parameter isPreferred:      Bool?
    */
    func setUpData(restaurantTitle : String?, typeOfRestaurant : String?, distance : String?, rating : Double?, expensiveness : Double?, imageURL : String?, isPreferred : Bool?){
        
        titleLabel.text = restaurantTitle ?? ""
        
        subTitleLabel.text = typeOfRestaurant ?? ""
        
        distanceLabel.text = distance ?? ""
        
        if let r = rating {
            Utils.setUpStarStackView(r, starStackView: starStackView)
        }
        
        var expensiveString = ""
        if let e = expensiveness {
           expensiveString = Utils.generateExpensiveString(Int(e))
        }
        expensiveLabel.text = expensiveString
        
        
        var url = NSURL()
        if let i_URL = imageURL {
            url = NSURL(string: i_URL)!
        }
        
        restaurantImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "image_loading"))
        
        if let pref = isPreferred {
            if(pref == true){
                preferredView.hidden = false
                preferredView.backgroundColor = UIColor(hex: "323232")
                backgroundColor = UIColor(hex: "f2f2f2")
            }
            else{
                preferredView.hidden = true
            }
        }else{
            preferredView.hidden = true
        }
    }
}
