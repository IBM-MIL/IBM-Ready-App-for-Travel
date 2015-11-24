/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendedHotelDetailView: UIView {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var hotelSubtitleLabel: UILabel!
    @IBOutlet weak var partnerView: UIView!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var rationaleLabel: UILabel!
    @IBOutlet weak var locationHeaderLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    @IBOutlet weak var priceHeaderLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var visitWebsiteButton: UIButton!
    @IBOutlet weak var reviewHighlightHeaderLabel: UILabel!
    @IBOutlet weak var reviewHighlightLabel: UILabel!
    @IBOutlet weak var percentOffLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var reviewsFromLabel: UILabel!
 

    /**
    Method that returns an instance of RecommendedHotelDetailView from nib
    
    - returns: RecommendedHotelDetailView
    */
    class func instanceFromNib() -> RecommendedHotelDetailView {
        return UINib(nibName: "RecommendedHotelDetailView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RecommendedHotelDetailView
    }
    
    
    /**
    Method that is called when it wakes from nib and sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setupView() {
        partnerView.backgroundColor = UIColor(hex: "323232")
        partnerLabel.textColor = UIColor.whiteColor()
        partnerLabel.font = UIFont.travelRegular(11)
        
        locationNameLabel.textColor = UIColor.travelDarkMainFontColor()
        locationNameLabel.font = UIFont.travelRegular(31)
        
        hotelSubtitleLabel.textColor = UIColor.travelDarkMainFontColor()
        hotelSubtitleLabel.font = UIFont.travelRegular(11)
        
        rationaleLabel.textColor = UIColor.travelLightMainFontColor()
        rationaleLabel.font = UIFont.travelSemiBold(11)
        
        locationHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        locationHeaderLabel.font = UIFont.travelSemiBold(11)
        
        locationAddressLabel.textColor = UIColor.travelDarkMainFontColor()
        locationAddressLabel.font = UIFont.travelRegular(14)
        
        reviewsFromLabel.textColor = UIColor.travelLightMainFontColor()
        reviewsFromLabel.font = UIFont.travelRegular(10)
        
        priceHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        priceHeaderLabel.font = UIFont.travelSemiBold(11)
        
        priceLabel.textColor = UIColor.travelDarkMainFontColor()
        priceLabel.font = UIFont.travelRegular(17)
        
        originalPriceLabel.font = UIFont.travelRegular(11)
        originalPriceLabel.textColor = UIColor.travelDarkMainFontColor()
        
        percentOffLabel.textColor = UIColor.travelLightMainFontColor()
        percentOffLabel.font = UIFont.travelRegular(11)
        
        visitWebsiteButton.titleLabel?.textColor = UIColor.travelMainColor()
        visitWebsiteButton.titleLabel?.font = UIFont.travelBold(11)
        
        reviewHighlightHeaderLabel.textColor = UIColor.travelLightMainFontColor()
        reviewHighlightHeaderLabel.font = UIFont.travelSemiBold(11)
        
        reviewHighlightLabel.textColor = UIColor.travelDarkMainFontColor()
        reviewHighlightLabel.font = UIFont.travelRegular(14)
        
        visitWebsiteButton.setTitleColor(UIColor.travelMainColor(), forState: .Normal)
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter locationName:    String?
    - parameter hotelSubtitle:   String?
    - parameter isPartner:       Bool?
    - parameter rationale:       String?
    - parameter locationAddress: String?
    - parameter numberOfStars:   Double?
    - parameter price:           Double?
    - parameter originalPrice:   Double?
    - parameter reviewHighlight: String?
    - parameter reviewer:        String?
    - parameter reviewerTime:    String?
    */
    func setUpData(locationName : String?, hotelSubtitle : String?, isPartner: Bool?, rationale : String?, locationAddress : String?, numberOfStars : Double?, price : Double?, originalPrice : Double?, reviewHighlight : String?, reviewer : String?, reviewerTime : String?){
        
        var locationNameString = ""
        if let l_Name = locationName {
            locationNameString = l_Name
        }
        locationNameLabel.text = locationNameString
        
        
        var hotelSubtitleString = ""
        if let subtitle = hotelSubtitle {
            hotelSubtitleString = subtitle
        }
        hotelSubtitleLabel.text = hotelSubtitleString
        
        var rationaleString = ""
        if let r_String = rationale {
            rationaleString = r_String
        }
        rationaleLabel.text = rationaleString
        
        var isPartnerBool : Bool = false
        if let isPart = isPartner {
            isPartnerBool = isPart
        }
        partnerView.hidden = !isPartnerBool
        
        var locationAddressString = ""
        if let l_Address = locationAddress {
            locationAddressString = l_Address
        }
        locationAddressLabel.text = locationAddressString
        
        var numberOfStarsDouble : Double = 0
        if let n_Stars = numberOfStars {
            numberOfStarsDouble = n_Stars
        }
        Utils.setUpStarStackView(numberOfStarsDouble, starStackView: starStackView)
 
        
        var priceString = ""
        if let p = price {
            priceString = "\(LocalizationUtils.getLocalizedCurrencySymbol())\(Utils.removeTailingZero(p))"
        }
        priceLabel.text = priceString
        
        var originalPriceString = NSAttributedString(string: "")
        if let op = originalPrice {
            originalPriceString = Utils.strikeThroughString("\(LocalizationUtils.getLocalizedCurrencySymbol())\(Utils.removeTailingZero(op))")
        }
        originalPriceLabel.attributedText = originalPriceString
        
        
        var percentageOffString = ""
        if let p = price, let op = originalPrice {
            
           percentageOffString = Utils.percentageOffString(p, originalPrice: op)
            
        }
        percentOffLabel.text = percentageOffString
        
        
        var reviewHighlightString = ""
        if let r_Highlight = reviewHighlight {
            reviewHighlightString = r_Highlight
        }
        
        var reviewerName = ""
        if let r_Name = reviewer {
            reviewerName = r_Name
        }
        
        var reviewerTimeString = ""
        if let r_Time = reviewerTime {
            reviewerTimeString = r_Time
        }
        
        let string = "\"\(reviewHighlightString)\" \(reviewerName) \(reviewerTimeString)"
        let attributedString = NSMutableAttributedString(string: string as String)
        
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(14),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\"\(reviewHighlightString)\" "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelBold(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(reviewerName) "))
        attributedString.addAttributes([NSFontAttributeName: UIFont.travelRegular(11),  NSForegroundColorAttributeName: UIColor.travelDarkMainFontColor()], range: (string as NSString).rangeOfString("\(reviewerTimeString)"))
        
        reviewHighlightLabel.attributedText = attributedString
    }
    
    
    /**
    Method that configures the price cut strike through string
    
    - parameter text: String
    */
    func configurePriceCutStrikethrough(text: String!) {
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
        originalPriceLabel.attributedText = attributeString
        
    }
    
    
}
