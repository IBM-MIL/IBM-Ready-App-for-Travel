/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Horizontal one part stack view
class HorizontalOnePartStackView: UIView {
    /// location label
    @IBOutlet weak var locationLabel: UILabel!
    
    /// first header label
    @IBOutlet weak var firstHeaderLabel: UILabel!
    
    /// horizontal separator view
    @IBOutlet weak var horizontalSeparatorView: UIView!
    
    
    /**
    Method is called when we wake from nib and it sets up the view's UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    /**
    Method that returns an instance of HorizontalOnePartStackView from nib
    
    - returns: HorizontalOnePartStackView
    */
    class func instanceFromNib() -> HorizontalOnePartStackView {
        return UINib(nibName: "HorizontalOnePartStackView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! HorizontalOnePartStackView
    }
    
    
    /**
    Method to setup the view's UI
    */
    func setupView() {
        horizontalSeparatorView.backgroundColor = UIColor(hex: "c9c9c9")
        
        firstHeaderLabel.textColor = UIColor(hex: "9a9a9a")
        firstHeaderLabel.font = UIFont.travelSemiBold(11)
        
        locationLabel.textColor = UIColor.travelMainColor()
        locationLabel.font = UIFont.travelSemiBold(11)
        
    }
    
    
    /**
    Method to setup the data in the view
    
    - parameter replacementRestaurantName:        restaurant name
    - parameter replacementRestaurantCityCountry: city or country of restaurant
    */
    func setUpData(replacementRestaurantName : String?, replacementRestaurantCityCountry : String?){
        
        var locationLabelString = ""
        if let restaurantName = replacementRestaurantName, let cityCountry = replacementRestaurantCityCountry {
            locationLabelString = "\(restaurantName)\n\(cityCountry)"
        }
        
        locationLabel.text = locationLabelString
    
    }

}
