/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Rail pass option table view cells
class RailPassOptionTableViewCell: UITableViewCell {

    /// preferred view
    @IBOutlet weak var preferredView: UIView!
    
    /// price label
    @IBOutlet weak var priceLabel: UILabel!
    
    /// class label
    @IBOutlet weak var classLabel: UILabel!
    
    /// title label
    @IBOutlet weak var titleLabel: UILabel!
    
    //sub title label
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /**
    Method to set the cell as selected and to ensure the preferredView background color stays the same
    
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
    Method to set the cell as highlighted and to ensure the preferredView background color stays the same
    
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
