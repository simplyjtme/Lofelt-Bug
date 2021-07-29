//
//  ContentView.swift
//  Lofelt Bug
//
//  Created by Joseph Thryselius on 7/27/21.
//

import SwiftUI
import LofeltHaptics
import AVFoundation

var audioPlayer: AVAudioPlayer?
var haptics: LofeltHaptics?

struct ContentView: View {
    var hapticsSupported = false;
    
    init() {
        // instantiate haptics player
        haptics = try? LofeltHaptics.init()
        
        // check if device supports Lofelt Haptics
        hapticsSupported = LofeltHaptics.deviceMeetsMinimumRequirement()
    }
    
    func loadHapticData(fileName: String) -> String {
        let data = try? String(contentsOf: URL(fileURLWithPath: getHapticPath(fileName:fileName)), encoding: String.Encoding.utf8)
        
        print(data)
        return data ?? ""
    }
    
    func getHapticPath(fileName:String) -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "haptic") else {
            return ""
        }
        return path
    }
    
    func getAudioPath(fileName:String) -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "wav") else {
            return ""
        }
        return path
    }
    
    
    var body: some View {
        HStack {
            Button(action: {
                // load audio clip
                //let audioData = NSDataAsset(name: "Content/Achievement_1-audio")
                
                audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: getAudioPath(fileName: "Content/Sounds/MouseDown")))//AVAudioPlayer(data: audioData!.data)
                
                // load haptic clip
                try? haptics?.load(self.loadHapticData(fileName: "Content/Haptic/MouseDown"))
                
                // play audio and haptic clip
                audioPlayer?.play()
                try? haptics?.play()
            }) {
                HStack {
                    Text("Mouse Down")
                }
            }
            .shadow(radius: 20.0)
            .padding()
            .background(Color.gray)
            .cornerRadius(10.0)
            Button(action: {
                // load audio clip
                //let audioData = NSDataAsset(name: "Content/Achievement_1-audio")
                
                audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: getAudioPath(fileName: "Content/Sounds/Achievement_1")))//AVAudioPlayer(data: audioData!.data)
                
                // load haptic clip
                try? haptics?.load(self.loadHapticData(fileName: "Content/Haptic/Achievement_1"))
                
                // play audio and haptic clip
                audioPlayer?.play()
                try? haptics?.play()
            }) {
                HStack {
                    Text("Achievement")
                }
            }
            .shadow(radius: 20.0)
            .padding()
            .background(Color.gray)
            .cornerRadius(10.0)
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            haptics = try? LofeltHaptics.init()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
