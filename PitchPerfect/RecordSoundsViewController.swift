//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Franziska Kammerl on 2/18/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Properties
    var audioRecorder: AVAudioRecorder!
    
    // Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioRecordTapped(isRecording: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }

// Actions
    @IBAction func RecordAudio(_ sender: Any) {
        
        audioRecordTapped(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        audioRecordTapped(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecordTapped(isRecording: Bool) {
            recordButton.isEnabled = !isRecording
            stopRecording.isEnabled = isRecording
            recordingLabel.text = isRecording ? "Recording in Process" : "Tap to Record"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

