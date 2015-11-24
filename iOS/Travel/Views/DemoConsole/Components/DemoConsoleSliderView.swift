/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer (a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product, either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's own products.
*/

import Foundation
import UIKit

/**

MARK: Sub-Component Constants

*/
extension DemoConsoleSliderView {
    
    // height (.10 --> .35)
    var iconY: CGFloat { return self.height * (0.1) }
    var iconHeight: CGFloat { return self.height * (0.25) }
    
    // height (.40 --> .75)
    var sliderY: CGFloat { return self.height * (0.35) }
    var sliderHeight: CGFloat { return self.height * (0.35) }
    
    // height (.80 --> 1.00)
    var labelY: CGFloat { return self.height * (0.75) }
    var labelHeight: CGFloat { return self.height * (0.25) }
    
}


/**

**DemoConsoleSliderView**

1. Icon Row (10% Height --> 35% Height)

2. Slider (40% Height --> 75% Height)

3. Label Row (80% Height --> 100% Height)

*/
class DemoConsoleSliderView: UIView {
    
    // data tracking
    var demoConsoleDataProvider: DemoConsoleDataProviderProtocol!
    
    // temporary hold on value, only "confirm" sets it
    var uncommittedDayValue: Int!
    
    // sizing
    var quantityIncrements: CGFloat = 3
    var widthIncrement: CGFloat { return width / (quantityIncrements) }
    
    var sliderStartX: CGFloat { return width * (1.0 / (quantityIncrements * 2.0)) }
    var sliderEndX: CGFloat { return width - sliderStartX }
    
    // sub-components
    var iconRow: UIView!
    var slider: UISlider!
    var labelRow: UIView!
    var labelsInLabelRow: [UILabel]! = []
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(frame: CGRect, demoConsoleDataProvider: DemoConsoleDataProviderProtocol) {
        
        super.init(frame: frame)
        
        self.demoConsoleDataProvider = demoConsoleDataProvider
        
        configureSlider()
        
        configureLabelRow()
        populateLabelRow()
        correctLabelHighlighting(1)
        
        highlightAppropriateItem()
        
    }
    
    
    /**
    Method configures the icon row
    */
    private func configureIconRow() {
        
        let frame = CGRect(
            x: 0.0,
            y: self.iconY,
            width: self.width,
            height: self.iconHeight
        )
        
        self.iconRow = UIView(frame: frame)
        self.addSubview(iconRow)
        
    }
    
    
    /**
    Method populates the icon row
    */
    private func populateIconRow() {
        
        let labels = [
            
            "STORM"
            
        ]
        
        let label = UILabel(frame: CGRect(
            x: 1.0 * self.widthIncrement,
            y: 0.0,
            width: self.widthIncrement,
            height: self.iconHeight
            ))
        
        label.text = labels.first!
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Arial", size: 12.0)
        
        self.iconRow.addSubview(label)
        
    }
    
    
    /**
    Method configures the slider
    */
    private func configureSlider() {
        
        let frame = CGRect(
            x: self.sliderStartX,
            y: self.sliderY,
            width: (self.sliderEndX - self.sliderStartX),
            height: self.sliderHeight
        )
        
        self.slider = UISlider(frame: frame)
        self.slider.tintColor = UIColor.lightGrayColor()
        
        // 1 -> quantity labels
        self.slider.minimumValue = 0.0
        self.slider.maximumValue = 2.0
        
        // call method that rounds to nearest increment and highlights
        self.slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.addSubview(slider)
        
    }
    
    
    /**
    Method configures the label row
    */
    private func configureLabelRow() {
        
        let frame = CGRect(
            x: 0.0,
            y: self.labelY,
            width: self.width,
            height: self.labelHeight
        )
        
        self.labelRow = UIView(frame: frame)
        self.addSubview(labelRow)
        
    }
    
    
    /**
    Method populates the label row
    */
    private func populateLabelRow() {
        
        let labels = [
            
            "Hotel",
            "Bad Weather",
            "Transportation"
            
        ]
        
        for var i=0; i < Int(self.quantityIncrements); i++ {
            
            let label = UILabel(frame: CGRect(
                x: CGFloat(i) * self.widthIncrement,
                y: 0.0,
                width: self.widthIncrement,
                height: self.labelHeight
                ))
            
            label.text = labels[i]
            label.lineBreakMode = .ByWordWrapping
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Center
            
            label.font = UIFont(name: "Arial", size: 10.0)
            
            self.labelRow.addSubview(label)
            
            self.labelsInLabelRow.append(label)
            
        }
    }
    
    
    /**
    Method bolds labels in label row
    */
    private func boldLabelsInLabelRow() {
        
        for label in self.labelsInLabelRow {
            
            let fontSize = CGFloat(12.0)
            
            let string: NSString = label.text!
            
            _ = [
                
                NSFontAttributeName : UIFont.systemFontOfSize(fontSize)
                
            ]
            
            _ = [
                
                NSFontAttributeName : UIFont.boldSystemFontOfSize(fontSize)
                
            ]
            
            _ = string.rangeOfString("\n")
            
        }
        
        self.labelsInLabelRow.first?.textColor = UIColor.blackColor()
        
    }
    
    
    /**
    Method highlights the appropriate item
    */
    private func highlightAppropriateItem() {
        
        let currentItinerary = self.demoConsoleDataProvider.viewModel.currentItinerary()

            let sliderIndex : Int!
            if(currentItinerary == TravelDataManager.SharedInstance.getBeginningItineraryIndex()){
                sliderIndex = 0
                setSliderToNearestIncrement(sliderIndex, slider: self.slider)
                correctLabelHighlighting(sliderIndex)
            }
            else if(currentItinerary == TravelDataManager.SharedInstance.getWeatherItineraryIndex()){
                sliderIndex = 1
                setSliderToNearestIncrement(sliderIndex, slider: self.slider)
                correctLabelHighlighting(sliderIndex)
            }
            else if currentItinerary == TravelDataManager.SharedInstance.getTransportationItineraryIndex(){
                sliderIndex = 2
                setSliderToNearestIncrement(sliderIndex, slider: self.slider)
                correctLabelHighlighting(sliderIndex)
            }
    }
    
}


/**

MARK: Handling slider value changes

* Locking to increments

*/
extension DemoConsoleSliderView {
    
    /**
    Method rounds to nearest increment, highlights text, and updates time value in TravelDataManager appropriately
    
    - parameter sender: UISlider
    */
    func sliderValueChanged(sender: UISlider) {
        
        let index = Int(slider.value + 0.5)
        
        setSliderToNearestIncrement(index, slider: slider)
        correctLabelHighlighting(index)
        
        
        updatedUncommittedStateInViewModel(index)
        
    }
    
    /**
    Method sets the slider ot the nearest increment
    
    - parameter index:  Int
    - parameter slider: UISlider
    */
    private func setSliderToNearestIncrement(index: Int, slider: UISlider) {
        slider.setValue(Float(index), animated: false)
    }
    
    
    /**
    Method sets the correct label highlighting
    
    - parameter index: Int
    */
    private func correctLabelHighlighting(index: Int) {
        for label in self.labelsInLabelRow {
            label.textColor = UIColor(hex: "#9A9A9A")
        }
        
        self.labelsInLabelRow[index].textColor = UIColor(hex: "#323232")
    }
    
    
    /**
    Method update the uncommited state in the view model
    
    - parameter index: Int
    */
    private func updatedUncommittedStateInViewModel(index: Int) {
        let currentItineraryIndex : Int!
        if(index == 0){
            currentItineraryIndex = TravelDataManager.SharedInstance.getBeginningItineraryIndex()
        }
        else if(index == 1){
            currentItineraryIndex = TravelDataManager.SharedInstance.getWeatherItineraryIndex()
        }
        else{
            currentItineraryIndex = TravelDataManager.SharedInstance.getTransportationItineraryIndex()
        }
    
        self.demoConsoleDataProvider.viewModel.setUncommittedItinerary(currentItineraryIndex)
    }
    
}
