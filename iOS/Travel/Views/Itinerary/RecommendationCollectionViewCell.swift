/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var circleIconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var cardHolderView: UIView!
    
    
    /**
    Method that is called when we wake up from nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    
    /**
    Method that sets up the view's UI
    */
    func setUpView(){
        cardHolderView.layer.cornerRadius = 3
        
        titleLabel.font = UIFont.travelRegular(12)
        titleLabel.textColor = UIColor.travelMainColor()
        
        backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        cardHolderView.backgroundColor = UIColor.travelItineraryCellBackgroundColor()
        cardHolderView.layer.borderWidth = 1.0
        cardHolderView.layer.borderColor = UIColor.travelMainColor().CGColor
    }
    
    
    /**
    Method that sets up the data for the view
    
    - parameter title: String?
    */
    func setUpData(title : String?){
    
        var titleLabelString = ""
        if let t = title {
            titleLabelString = t
        }
        titleLabel.text = titleLabelString
    }

    

}
