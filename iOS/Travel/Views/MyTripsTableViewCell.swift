/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// My trips table view cell in trips tab
class MyTripsTableViewCell: UITableViewCell {
    
    /// title label
    @IBOutlet weak var titleLabel: UILabel!
    
    /// sub title label
    @IBOutlet weak var subTitleLabel: UILabel!
    
    /// background image view
    @IBOutlet weak var backgroundImageView: UIImageView!

    /// trip view object
    var tripView : TripView!
    
    /// height of cell
    let cellHeight : CGFloat = 150


    /**
    Method that is called when we wake from nib and sets up some of the UI
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.hidden = true
        subTitleLabel.hidden = true
        backgroundImageView.hidden = true

    }
    
    
    /**
    Method to setup tripview
    */
    func setupTripView(){
        
        if(tripView == nil){
            tripView = TripView.instanceFromNib()
            tripView.setText()
            tripView.setupTripDurationDateLabel()
            
            self.addSubview(tripView)
            
            tripView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            tripView.setUpView()
            
            tripView.userInteractionEnabled = false
        }
        else{
            tripView.hidden = false
        }
    }
    
    
    /**
    Method that sets the cell as selected
    
    - parameter selected: Bool
    - parameter animated: Bool
    */
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /**
    Method to setup the view's data
    
    - parameter title:           title of view
    - parameter subTitle:        sub title of view
    - parameter imageNameString: image name string
    */
    func setupData(title : String, subTitle: String, imageNameString: String){
        tripView.tripTitleLabel.text = title
        tripView.tripDetailLabel.text = subTitle
        tripView.backgroundImageView.image = UIImage(named: imageNameString)
    }
    
    
}
