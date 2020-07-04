//
//  AppDelegate.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 18/10/2019.
//  Copyright © 2019 NRKK.DEV. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let startScreenViewController = StartScreenViewController()
        window!.rootViewController = startScreenViewController
        window!.makeKeyAndVisible()
        
        /// Продолжать играть в фоновом режиме
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let audioSession = AVAudioSession.sharedInstance()
        do { try audioSession.setCategory(.playback) }
        catch { }
        
        return true
    }
}
