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
    var i = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var pastExercises: [String] = []
    
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
            tableView.dataSource = self
            tableView.delegate = self
            exerciseTypeTextField.delegate = self
            wcSession.activate()
            print("WCsession set up properly")
            
        }
    }
    
    @IBAction func clearExercisesPressed(_ sender: UIButton) {
        pastExercises = []
    }
    
    @IBAction func sendNameToWatch(_ sender: UIButton) {
        if let exerciseType = exerciseTypeTextField.text{
            print(wcSession.isReachable)
            if !pastExercises.contains(exerciseType){
                pastExercises.insert(exerciseType, at: 0)
                self.tableView.reloadData()
            }
            print(pastExercises)
            let message = ["exerciseType": exerciseType]
            print(message)
            wcSession.sendMessage(message, replyHandler: nil, errorHandler: {(error) in
                print(error)
                print(error.localizedDescription)
            })
        }
    }
    func getCurrentExercise()->String? {
        return exerciseTypeTextField.text
    }
    
}

extension ViewController: WCSessionDelegate{
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //idc
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        //let decoder = JSONDecoder()
        print(messageData)
        /*do{
         try print(decoder.decode(ExerciseDataModel.self, from: messageData))
         }catch{
         print("error decoding data")
         }*/
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //can just use message but ima keep this line for now
        
        print("I got the message")
        DispatchQueue.main.async {
            if message["status"] != nil {
                if let exerciseType = self.getCurrentExercise(){
                    print(self.wcSession.isReachable)
                    if !self.pastExercises.contains(exerciseType) {
                        self.pastExercises.insert(exerciseType, at: 0)
                        self.tableView.reloadData()
                    }
                    
                    let message = ["exerciseType": exerciseType]
                    self.wcSession.sendMessage(message, replyHandler: nil, errorHandler: {(error) in
                        print(error)
                        print(error.localizedDescription)
                    })
                }
                
            } else{
                
                func addNewData(dictionaryKey:String){
                    let newData = message[dictionaryKey] as? [String:[Double]]
                    var currentData = self.exerciseData![dictionaryKey] as? [String:[Double]]
                    if (dictionaryKey == "attitudeData"){
                        for element in (newData!["pitch"])!{
                            currentData?["ptich"]?.append(element)
                        }
                        for element in (newData?["yaw"])!{
                            currentData?["yaw"]?.append(element)
                        }
                        for element in (newData?["yaw"])!{
                            currentData?[" yaw"]?.append(element)
                        }
                        for element in (newData?["t"])!{
                            currentData?["t"]?.append(element)
                        }
                    }else {
                        for element in (newData!["x"])!{
                            currentData?["x"]?.append(element)
                        }
                        for element in (newData?["y"])!{
                            currentData?["y"]?.append(element)
                        }
                        for element in (newData?["z"])!{
                            currentData?["z"]?.append(element)
                        }
                        for element in (newData?["t"])!{
                            currentData?["t"]?.append(element)
                        }
                    }
                    self.exerciseData![dictionaryKey] = currentData
                }

                if let date = message["date"]{
                    if self.exerciseData != nil {
                        self.exerciseData?["date"] = date
                        addNewData(dictionaryKey: "accelData")
                        addNewData(dictionaryKey: "gravityData")
                        addNewData(dictionaryKey: "rotationData")
                        addNewData(dictionaryKey: "attitudeData")
                    } else {
                        self.exerciseData = message
                    }
                    let workoutRef = self.db.collection("awaldron12@outlook.comNEW").document("workouts").collection(self.exerciseData?["exerciseType"] as! String)
                    workoutRef.addDocument(data: self.exerciseData!) { (error) in
                        if let e = error {
                            self.errorLabel.text = e.localizedDescription
                            print("there was an issue adding data to fire store \(e.localizedDescription)")
                        } else{
                            self.i += 1
                            self.errorLabel.text = "Firebase: Success \(self.i)"
                            print("SUCCESS")
                            
                        }
                    }
                    
                    self.exerciseData = nil
                    print(date)
                } else{
                    
                    print("no date")
                    if self.exerciseData != nil{
                        addNewData(dictionaryKey: "accelData")
                        addNewData(dictionaryKey: "gravityData")
                        addNewData(dictionaryKey: "rotationData")
                        addNewData(dictionaryKey: "attitudeData")
                        
                    } else{
                        self.exerciseData = message
                    }
                    
                }
                
                
                self.errorLabel.text = "Firebase: Success \(self.i)"
                
            }
        }
        
        /*
         //push to firebase
         */
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //idc
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //idc
    }
    
    
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = pastExercises[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseTypeTextField.text = pastExercises[indexPath.row]
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        exerciseTypeTextField.endEditing(true)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        exerciseTypeTextField.endEditing(true)
        return true
    }
}

