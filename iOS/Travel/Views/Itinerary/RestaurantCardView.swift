/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

class RestaurantCardView: UIView {

    /**
    Method that returns an instance of RestaurantCardView from nib
    
    - returns: RestaurantCardView
    */
    class func instanceFromNib() -> RestaurantCardView {
        return UINib(nibName: "RestaurantCardView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RestaurantCardView
    }

}
