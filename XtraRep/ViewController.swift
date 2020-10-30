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
    var ref: DocumentReference? = nil
    var exerciseData: [String:Any]? = nil
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
        }
    }
    @IBAction func sendNameToWatch(_ sender: UIButton) {
        if let exerciseType = exerciseTypeTextField.text{
            let message = ["exerciseType": exerciseType]
            wcSession.sendMessage(message, replyHandler: nil, errorHandler: {(error) in
                print(error.localizedDescription)
            })
        }
    }
    
}

extension ViewController: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //idc
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        exerciseData = message
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //idc
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //idc
    }
    
    
}

