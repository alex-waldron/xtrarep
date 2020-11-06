//
//  InterfaceController.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/26/20.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    //intialize var to hold button state
    var buttonLabel = K.start
    
    //init string to hold user input
    var exerciseType:String? = nil
    
    //init motion manager for accell data
    let motionManager = CMMotionManager()
    
    //init logic controller "WatchBrain.swift"
    var watchBrain = WatchBrain()
    
    //init watch connectivity
    var wcSession: WCSession!
    
    let encoder = JSONEncoder()
    
    //Outlet for exercise label to change color when user forgets to input
    @IBOutlet weak var exerciseLabel: WKInterfaceLabel!
    
    //Outlet for type field to clear after the exercise has completed
    @IBOutlet weak var exerciseTypeField: WKInterfaceTextField!
    
    //Outlet for button to change text from start to stop and color
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    
    
    //text field action to get user input
    @IBAction func textField(_ value: NSString?) {
        //must unwrap text input to use String() function
        if let safeValue = value{
            exerciseType = String(safeValue)
        }
    }
    
    //func that comes with WachKit
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        //Programitically set button color to green
        self.startStopButton.setBackgroundColor(Colors.buttonGreen)
    }
    
    
    //func comes with WatchKit ... No idea what this shit does
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
        
        
    }
    
    
    //func comes with WatchKit
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    //Action to start stop button
    @IBAction func buttonPressed() {
        
        //check to see what the current state of the button is
        if buttonLabel == K.start{
            
            //if user hit the button while its state = start
            //check to see if the exercise type text field has been filled in
            if exerciseType != nil {
                
                //if the text field has some sort of text in it,
                //check to see if the accelerometer is available
                if motionManager.isAccelerometerAvailable{
                    
                    //if accell is available, start getting data from it
                    watchBrain.startCollectingData(exerciseName: exerciseType!, motionManager: motionManager)
                    
                    //change the button label and background color & state to "stop"
                    setButtonToStopState()
                    
                } else {
                    
                    //NEED TO LET THE USER KNOW THERE ACCEL IS NOT AVAILABLE
                    
                    exerciseTypeField.setText("Accel Not avail")
                    print("Accel not available")
                }
            } else {
                //remind user to input a type of exercise before starting workout
                remindUserToInputEx()
            }
            
        } else {
            //button state is stop
            
            motionManager.stopDeviceMotionUpdates()
            //get data received from last exercise
            let lastSetData = watchBrain.getExerciseData()
            watchBrain.resetExerciseData()   
            let lastSetDict = [
                "exerciseType": lastSetData?.exerciseType! as Any,
                "date": watchBrain.getCurrentDate() as Any,
                "times": lastSetData?.times as Any,
                "accelData" : lastSetData?.accelData as Any,
                "gravityData": lastSetData?.gravityData as Any,
                "attitudeData":lastSetData?.attitudeData as Any,
                "rotationData":lastSetData?.rotationData as Any
            ] as [String : Any]
            
            print(wcSession.isReachable)
            
            wcSession.sendMessage(lastSetDict, replyHandler: nil) { (error) in
                
                print(error.localizedDescription)
                
            }
 
            
            
            //clear text field and get ready for next exercise input
            resetScreen()
            
            //ghetto debug
            print("Stop collecting data")
            
            //change the button label and background color & state to "start"
            setButtonToStartState()
            
        }
    }
    
    
    
    //MARK: - FUNCTIONS
    
    func resetScreen() {
        
        
        //Reset placeholder to initial String in case the user had to be reminded to input an exercise type
        exerciseTypeField.setPlaceholder("Exercise Type")
        
        //reset exercise label incase they had to be reminded to input text
        exerciseLabel.setTextColor(.white)
    }
    func remindUserToInputEx(){
        
        //show user where the exercise needs to be inputted
        exerciseTypeField.setPlaceholder("Input Exercise!")
        
        //Chnage exercise label to red to show where the issue is
        exerciseLabel.setTextColor(.init(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0))
    }
    func setButtonToStopState(){
        
        //change button label to stop
        startStopButton.setTitle(K.stop)
        
        //change button state to stop
        buttonLabel = K.stop
        
        //change background of button to red
        startStopButton.setBackgroundColor(Colors.buttonRed)
    }
    func setButtonToStartState(){
        
        //change button label to start
        startStopButton.setTitle(K.start)
        
        //change button state to start
        buttonLabel = K.start
        
        //change button background to green
        startStopButton.setBackgroundColor(Colors.buttonGreen)
    }
}

//MARK: - WCSessionDelegate

extension InterfaceController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //dont do anything
    }
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]){
        exerciseTypeField.setText(message["exerciseType"] as? String)
        
        exerciseType = message["exerciseType"] as? String
    }
    
    /*func sendMessageToIOS(){
     wcSession.sendMessage(<#T##message: [String : Any]##[String : Any]#>, replyHandler: <#T##(([String : Any]) -> Void)?##(([String : Any]) -> Void)?##([String : Any]) -> Void#>, errorHandler: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
     }*/
    
    
    
}
