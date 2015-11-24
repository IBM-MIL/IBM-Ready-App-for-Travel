/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import UIKit

/// Third page of onboarding
class ThirdOnboardingViewController: UIViewController {

    /// index of page
    var pageIndex: Int! = 2
    
    @IBOutlet weak var titleLabel: UILabel!
    
    /**
    Method that is called upon view did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.textColor = UIColor.travelMainColor()
    }

    
    /**
    Method that is called when we receive a memory warning
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
