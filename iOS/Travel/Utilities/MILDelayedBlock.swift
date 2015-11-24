/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation

/**

**MILDelayedBlock**

Delay method calls by

* seconds

* milliseconds

* microseconds

* nanoseconds


**Calls**

    MILDelayedBlock.Execute(secondsDelay: 1.5) {

        // code

    }

*/
public final class MILDelayedBlock {
    
    public static func Execute(secondsDelay secondsDelay: Double?, block: (()->())?) {
        
        Delay(time: secondsDelay, exponent: 9, block: block)
        
    }
    
    public static func Execute(millisecondsDelay millisecondsDelay: Double?, block: (()->())?) {
        
        Delay(time: millisecondsDelay, exponent: 6, block: block)
        
    }
    
    public static func Execute(microsecondsDelay microsecondsDelay: Double?, block: (()->())?) {
        
        Delay(time: microsecondsDelay, exponent: 3, block: block)
        
    }
    
    public static func Execute(nanosecondsDelay nanosecondsDelay: Double?, block: (()->())?) {
        
        Delay(time: nanosecondsDelay, exponent: 0, block: block)
        
    }
    
    
    private init(){} // no instances necessary
    
}


/// MARK: Implementation
private extension MILDelayedBlock {
    
    private static func Delay(time time: Double?, exponent: Double!, block: (()->())?) {
        
        if let time = time, let block = block {
                
                let delay = Int64(time * pow(10, exponent))
                
                let dispatch_delay = dispatch_time(DISPATCH_TIME_NOW, delay)
                
                dispatch_after(dispatch_delay, dispatch_get_main_queue()) {
                    
                    block()
                    
                }
            
            
        }
        
    }
    
}
