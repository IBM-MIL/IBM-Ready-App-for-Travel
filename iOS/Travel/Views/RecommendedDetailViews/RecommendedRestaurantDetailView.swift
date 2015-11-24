/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedRestaurantDetailView: UIView {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var priceRangeHeaderLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var reviewHighlightHeaderLabel: UILabel!
    @IBOutlet weak var reviewHighlightLabel: UILabel!
    @IBOutlet weak var preferredView: UIView!
    @IBOutlet weak var preferredLabel: UILabel!
    @IBOutlet weak var preferredImageView: UIImageView!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    
    /**
    Method that returns an instance from nib of the RecommendedRestaurantDetailView
    
    - returns: RecommendedRestaurantDetailView
    */
    class func instanceFromNib() -> RecommendedRestaurantDetailView {
        return UINib(nibName: "RecommendedRestaurantDetailView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RecommendedRestaurantDetailView
    }
    
    /**
    Method is called when we wake from nib and sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        preferredView.backgroundColor = UIColor(hex: "323232")
        preferredLabel.textColor = UIColor.whiteColor()
        preferredLabel.font = UIFont.travelRegular(11)
        
        restaurantTypeLabel.textColor = UIColor.travelLightMainFontColor()
        restaurantTypeLabel.font = UIFont.travelRegular(12)
        
        locationNameLabel.textColor = UIColor.travelDarkMainFontColor()
        locationNameLabel.font = UIFont.travelRegular(31)
        
        locationHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        locationHeaderLabel.font = UIFont.travelSemiBold(11)
        
        locationAddressLabel.textColor = UIColor.travelDarkMainFontColor()
        locationAddressLabel.font = UIFont.travelRegular(14)
        
        priceRangeHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        priceRangeHeaderLabel.font = UIFont.travelSemiBold(11)
        
        priceRangeLabel.textColor = UIColor.travelDarkMainFontColor()
        priceRangeLabel.font = UIFont.travelRegular(14)
        
        visitWebsiteButton.titleLabel?.textColor = UIColor.travelMainColor()
        visitWebsiteButton.titleLabel?.font = UIFont.travelBold(11)
        
        reviewHighlightHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        reviewHighlightHeaderLabel.font = UIFont.travelSemiBold(11)
        
        reviewHighlightLabel.textColor = UIColor.travelDarkMainFontColor()
        reviewHighlightLabel.font = UIFont.travelRegular(14)
        
        visitWebsiteButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
        
    }
    
    /**
    Method to set up the data for the view
    
    - parameter isPreferred:      Bool?
    - parameter typeOfRestaurant: String?
    - parameter locationName:     String?
    - parameter locationAddress:  String?
    - parameter city:             String?
    - parameter priceLevel:       Double?
    - parameter rating:           Double?
    - parameter reviewHighlight:  String?
    - parameter reviewer:         String?
    - parameter reviewerTime:     String?
    */
    func setupData(isPreferred : Bool?, typeOfRestaurant : String?, locationName : String?, locationAddress : String?, city : String?, priceLevel : Double?, rating : Double?, reviewHighlight : String?, reviewer : String?, reviewerTime : String?){
        
        var isPreferredBool : Bool = false
        if let isPref = isPreferred {
            isPreferredBool = isPref
        }
        preferredView.hidden = !isPreferredBool
        
        restaurantTypeLabel.text = typeOfRestaurant ?? ""
        locationNameLabel.text = locationName ?? ""
        
        let locAddress = locationAddress ?? ""
        let locCity = city ?? ""
        locationAddressLabel.text = "\(locAddress) \(locCity)"
        
        
        let p_Level = priceLevel ?? 0
        priceRangeLabel.text = Utils.generateExpensiveString(Int(p_Level))
        
        let r = rating ?? 0.0
        Utils.setUpStarStackView(r, starStackView: starStackView)
        
        let reviewerHighlightString = reviewHighlight ?? ""
        let reviewerName = reviewer ?? ""
        let reviewerTimeString = reviewerTime ?? ""
     
        let string = "\"\(reviewerHighlightString)\" \(reviewerName) \(reviewerTimeString)"
        let attributedString = NSMutableAttributedString(string: string as String)
        
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\"\(reviewerHighlightString)\" "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelBold(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(reviewerName) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(reviewerTimeString)"))
        
         reviewHighlightLabel.attributedText = attributedString
        
    }
    
    
    
    
    
}
