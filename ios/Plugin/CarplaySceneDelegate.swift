//
//  CarplaySceneDelegate.swift
//  Plugin
//
//  Created by Fahid Attique on 29/01/2024.
//  Copyright © 2024 Max Lynch. All rights reserved.
//

import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    private var interfaceController: CPInterfaceController?

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController, from window: CPWindow) {

        self.interfaceController = interfaceController
        
        let nowPlayingTemplate = CPNowPlayingTemplate.shared
        self.interfaceController?.setRootTemplate(nowPlayingTemplate, animated: true, completion: nil)
        
        CarPlayHelper.shared.isCarplayConnected = true
        CarPlayHelper.shared.startStreaming()
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        
        CarPlayHelper.shared.isCarplayConnected = false
        CarPlayHelper.shared.pausePlayer()
        self.interfaceController = nil
    }
}
