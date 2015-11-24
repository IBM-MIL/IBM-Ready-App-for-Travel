/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/**

**HotelTableViewCell**

**References**

[1] http://stackoverflow.com/questions/13133014/uilabel-with-text-struck-through

*/
class RecommendedHotelTableViewCell: UITableViewCell {

    @IBOutlet weak var preferredView: UIView!
    @IBOutlet weak var preferredLabel: UILabel!
    @IBOutlet weak var preferredImageView: UIImageView!
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var reviewsFromLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceCutLabel: UILabel!
    @IBOutlet weak var starStackView:  UIStackView!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    
    /**
    Method called when the view wakes from nib and then sets up the view
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method used to setup the view
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
        
        priceLabel.textColor = UIColor.travelDarkMainFontColor()
        priceLabel.font = UIFont.travelRegular(17)
        
        priceCutLabel.textColor = UIColor.travelDarkMainFontColor()
        priceCutLabel.font = UIFont.travelRegular(11)
    }
    
    
    /**
    Method used to setup the star stack view
    
    - parameter numberOfStars: Int
    */
    func setUpStarStackView(numberOfStars : Int){
        for (index, element) in starStackView.subviews.enumerate() {
            if(index < numberOfStars){
                (element as! UIImageView).image = UIImage(named: "Star")
            }
            else{
                (element as! UIImageView).image = UIImage(named: "Star_empty")
            }
        }
    }
    
    
    /**
    Method to set up the data
    
    - parameter hotelTitle:       String?
    - parameter numberOfStars:    Double?
    - parameter rationale:        String?
    - parameter isTrustedPartner: Bool?
    - parameter discountPrice:    Double?
    - parameter previousPrice:    Double?
    - parameter imageURLString:   String?
    */
    func setUpData(hotelTitle : String?, numberOfStars : Double?, rationale : String?, isTrustedPartner : Bool?, discountPrice: Double?, previousPrice : Double?, imageURLString : String?){
        
        if let isTrusted = isTrustedPartner {
            if(isTrusted == true){
                preferredView.hidden = false
                preferredView.backgroundColor = UIColor(hex: "323232")
                backgroundColor = UIColor(hex: "f2f2f2")
            }
            else{
                preferredView.hidden = true
            }
        }
        else {
            preferredView.hidden = true
        }
        
        
        var titleLabelString = ""
        if let title = hotelTitle {
            titleLabelString = title
        }
        titleLabel.text = titleLabelString
        
        var rationaleString = ""
        if let r = rationale {
            rationaleString = r
        }
        subTitleLabel.text = rationaleString
        
        var numberOfStarsDouble : Double = 0
        if let n_stars = numberOfStars {
            numberOfStarsDouble = n_stars
        }
        Utils.setUpStarStackView(numberOfStarsDouble, starStackView : starStackView)
        
        
        var discountPriceString = ""
        if let d_Price = discountPrice {
            discountPriceString = "\(LocalizationUtils.getLocalizedCurrencySymbol())\(Utils.removeTailingZero(d_Price))"
        }
        priceLabel.text = discountPriceString
        
        if let p_Price = previousPrice {
            if(p_Price == 0){
                priceCutLabel.hidden = true
            }else{
                let string = "\(LocalizationUtils.getLocalizedCurrencySymbol())\(Utils.removeTailingZero(p_Price))"
                let attributedString = Utils.strikeThroughString(string)
                priceCutLabel.attributedText = attributedString
                priceCutLabel.hidden = false
            }
        }
        else {
            priceCutLabel.text = ""
        }
        
        var url = NSURL()
        if let imageURL = imageURLString {
            url = NSURL(string: imageURL)!
        }

        recommendationImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "image_loading"))
        
    }
    
    
    /**
    Method called that sets the cell as selected and ensures the preferred view's background stays the same
    
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
    Method called that sets the cell as highlighted and ensures the preferred view's background stays the same
    
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
    
}
