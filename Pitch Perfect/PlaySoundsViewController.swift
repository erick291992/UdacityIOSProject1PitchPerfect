//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erick Manrique on 3/28/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let filePath = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3")
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = try!AVAudioPlayer(contentsOfURL: filePathUrl)
//            audioPlayer.enableRate = true
//        }
//        else{
//            print("error in path")
//        }
        
        audioPlayer = try!AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try!AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
   
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func StopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        playModifiedAudio(changePitchEffect)
        
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        playModifiedAudio(changePitchEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 100.0
        playModifiedAudio(reverbEffect)
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let echoEffect = AVAudioUnitDelay()
        echoEffect.wetDryMix = 100.0
        playModifiedAudio(echoEffect)
    }
    
    func playAudioWithRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playModifiedAudio(effect: AVAudioUnit){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

}
