//
//  InterfaceController.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/26/20.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    var buttonLabel = K.start
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        startStopButton.setBackgroundColor(Colors.buttonGreen)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

 
    @IBAction func buttonPressed() {
        if buttonLabel == K.start{
            print("Start collecting data")
            startStopButton.setTitle(K.stop)
            buttonLabel = K.stop
            startStopButton.setBackgroundColor(Colors.buttonRed)
        } else {
            print("Stop collecting data")
            startStopButton.setTitle(K.start)
            buttonLabel = K.start
            startStopButton.setBackgroundColor(Colors.buttonGreen)
        }
    }
}
