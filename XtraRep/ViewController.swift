//
//  ViewController.swift
//  XtraRep
//
//  Created by Alex Waldron on 10/26/20.
//

import UIKit
import Firebase
import WatchConnectivity
class ViewController: UIViewController {
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var exerciseData: [String:Any]? = nil
    /*var exerciseData: [String:Any]? = [
        "exercise": "benchPress",
        "accelData": [
            ["x":1,"y":2,"z":3],
            ["x":1,"y":2,"z":3],
            ["x":1,"y":2,"z":3]
        ]
    ]*/
    var wcSession: WCSession! = nil
    @IBOutlet weak var exerciseTypeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set up for watch connectivity
        if WCSession.isSupported(){
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
            print("WCsession set up properly")
            
        }
    }
    @IBAction func sendNameToWatch(_ sender: UIButton) {
        if let exerciseType = exerciseTypeTextField.text{
            print(wcSession.isReachable)
            print(exerciseType)
            let message = ["exerciseType": exerciseType]
            print(message)
            wcSession.sendMessage(message, replyHandler: nil, errorHandler: {(error) in
                print(error)
                print(error.localizedDescription)
            })
        }
    }
    @IBAction func pushToFirebase(_ sender: UIButton) {
        db.collection(exerciseData?["exercise"] as! String).addDocument(data: exerciseData!, completion: {(error) in
                if let e = error {
                    print("there was an issue adding data to fire store \(e)")
                } else{
                    print("SUCCESS")
                }
            }
                
        )
        
    
    }
    
}

extension ViewController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //idc
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //can just use message but ima keep this line for now
        exerciseData = message
        print("I got the message")
        print(message)
        
        //push to firebase
        db.collection(exerciseData?["exerciseType"] as! String).addDocument(data: exerciseData!, completion: {(error) in
                if let e = error {
                    print("there was an issue adding data to fire store \(e)")
                } else{
                    print("SUCCESS")
                }
            }
                
        )
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //idc
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //idc
    }
    
    
}

