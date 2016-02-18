//
//  SoundPlayerViewController.swift
//  PitchPerfect
//
//  Created by Michael Main on 2/17/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import UIKit
import AVFoundation

class SoundPlayerViewController: UIViewController {
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioFile:AVAudioFile!
    var soundRecording:SoundRecording!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            // Create the AVAudioSession and ensure it's outputting to the device's speaker
            let session = AVAudioSession.sharedInstance()
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            
            // Create audio engine, player node and an audio file for the sent over sound recording
            audioEngine = AVAudioEngine()
            audioPlayerNode = AVAudioPlayerNode()
            audioFile = try AVAudioFile(forReading: soundRecording.filePath)
        } catch _ {
            print("Failed to load sound file")
        }
    }

    @IBAction func slowButtonPressed(sender: AnyObject) {
        // Play recorded sound slowly
        print("Slow speed")
        playSound(rate: 0.5)
    }
    
    @IBAction func regularButtonPressed(sender: AnyObject) {
        // Play recorded sound at regular speed
        print("Regular speed")
        playSound(rate: 1.0)
    }
    
    @IBAction func fastButtonPressed(sender: AnyObject) {
        // Play recorded sound at fast speed
        print("Fast speed")
        playSound(rate: 2.0)
    }
    
    @IBAction func chipmunkButtonPressed(sender: AnyObject) {
        // Play recorded sound at high pitch
        print("Chipmunk pitch")
        playSound(rate: 1.0, pitch: 1000)
    }
    
    @IBAction func darthVaderButtonPressed(sender: AnyObject) {
        // Play recorded sound at low pitch
        print("Darth Vader pitch")
        playSound(rate: 1.0, pitch: -1000)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        // Stop and reset the audio engine
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playSound(rate playRate : Float, pitch : Float = 0.0) {
        // Stop and reset the audio engine
        audioEngine.stop()
        audioEngine.reset()
        
        // Create audio player node and attach it to audio engine
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Create pitch change effect and set pitch and rate on it
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = playRate
        audioEngine.attachNode(changePitchEffect)
        
        // Connect audio player node to the change pitch effect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        // Connect the change pitch effect to the audioEngine's output node
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Schedule the sound file to play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        // Play the sound file
        try! audioEngine.start()
        audioPlayerNode.play()
    }
}
