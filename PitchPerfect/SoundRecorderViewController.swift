//
//  SoundRecorderViewController.swift
//  PitchPerfect
//
//  Created by Michael Main on 2/16/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import UIKit
import AVFoundation

class SoundRecorderViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var soundRecording:SoundRecording!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reset all UI elements whenever this view is about to appear
        resetUI()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool) {
        // On successful completion of audio recording, segue to the listen screen, passing the url of the recorded audio
        if (flag) {
            soundRecording = SoundRecording(filePath: recorder.url, title: recorder.url.lastPathComponent)
            performSegueWithIdentifier("recordingToPlaying", sender: soundRecording)
            print("Recording finished")
        } else {
            resetUI()
        }
    }
    
    func resetUI() {
        // Return all UI elements to original state
        recordButton.enabled = true
        stopButton.hidden = true
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to record"
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Now recording"
        recordButton.enabled = false
        stopButton.hidden = false
        
        // Search for document directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Build the filepath to where we will be storing the recording
        let recordingName = "pp_cache.wav"
        let pathArray = [dirPath, recordingName]
        let audioFilePath = NSURL.fileURLWithPathComponents(pathArray)
        print(audioFilePath)
        
        // Get a handle to the shared AVAudioSession
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        // Create the AVAudioRecorder, setup completion callback and start recording
        try! audioRecorder = AVAudioRecorder(URL: audioFilePath!, settings: [:])
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        // Stop recording and deactivate shared audio session
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch _ {
            print("Unable to deactivate session")
        }
        
        resetUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // On segue to listen screen, transfer the sound recording object over to the next view controller.
        if (segue.identifier == "recordingToPlaying") {
            let svc = segue.destinationViewController as! SoundPlayerViewController
            svc.soundRecording = sender as! SoundRecording
        }
    }
}

