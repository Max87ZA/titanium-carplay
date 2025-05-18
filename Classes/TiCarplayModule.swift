//
//  TiCarplayModule.swift
//  titanium-carplay
//
//  Created by Your Name
//  Copyright (c) 2023 Your Company. All rights reserved.
//

import UIKit
import TitaniumKit
import CarPlay
import os

@objc(TiCarplayModule)
class TiCarplayModule: TiModule {
    public static private(set) var instance: TiCarplayModule?

        public override init() {
            super.init()
            TiCarplayModule.instance = self
        }

        public static func shared() -> TiCarplayModule? {
            return TiCarplayModule.instance
        }
    @objc
    public func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        // Forward the event to JavaScript
        self.fireEvent("didConnect", with: nil)
    }
    @objc
    public func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController) {
        self.fireEvent("didDisconnect", with: nil)
    }
//  private lazy var interfaceController: CPInterfaceController? = {
//      
//      guard let carPlayScene = UIApplication.shared.connectedScenes.first(where: { $0 is CPTemplateApplicationScene }) as? CPTemplateApplicationScene,
//          let sceneDelegate = carPlayScene.delegate as? TiCarPlaySceneDelegate,
//          let interfaceController = sceneDelegate.interfaceController else {
//      return nil
//    }
//      
//    
//    return interfaceController
//  }()
    private func getInterfaceController() -> CPInterfaceController? {
      guard let carPlayScene = UIApplication.shared.connectedScenes.first(where: { $0 is CPTemplateApplicationScene }) as? CPTemplateApplicationScene,
            let sceneDelegate = carPlayScene.delegate as? TiCarPlaySceneDelegate,
            let interfaceController = sceneDelegate.interfaceController else {
        return nil
      }
      return interfaceController
    }
    let logger = Logger(subsystem: "ti.carplay", category: "module")
    private var interfaceController: CPInterfaceController? 
  func moduleGUID() -> String {
    return "155b792e-29af-44b3-8b08-66cf0598ab47"
  }
  
  override func moduleId() -> String! {
    return "ti.carplay"
  }
  
  @objc(setRootTemplate:)
  func setRootTemplate(template: TiCarplayTemplateProxy) {
    guard let interfaceController = getInterfaceController() else {
      return
    }
    
    interfaceController.setRootTemplate(template.template, animated: true, completion: nil)
  }
  
  @objc(pushTemplate:)
  func pushTemplate(template: [TiCarplayTemplateProxy]) {
    guard let interfaceController = getInterfaceController(), let template = template.first?.template else {
      return
    }
    
    interfaceController.pushTemplate(template, animated: true, completion: nil)
  }
  
  @objc(presentTemplate:)
  func presentTemplate(template: [TiCarplayTemplateProxy]) {
    guard let interfaceController = getInterfaceController(), let template = template.first?.template else {
      return
    }
    
    interfaceController.presentTemplate(template, animated: true, completion: nil)
  }
  
  @objc(dismissTemplate:)
  func dismissTemplate(unused: [Any]?) {
    guard let interfaceController = getInterfaceController() else {
      return
    }
    
    interfaceController.dismissTemplate(animated: true, completion: nil)
  }
  
    @objc
    public func popToRootTemplate(_ args: [Any]?) {
        self.getInterfaceController()?.popToRootTemplate(animated: true)
    }
    
    @objc
    public func setInterfaceController(_ controller: CPInterfaceController?) {
        self.interfaceController = controller
    }

    @objc
    public func pushNowPlayingTemplate(_ unused: [Any]? = nil) {
        guard let interfaceController = getInterfaceController() else {
            logger.warning("No CarPlay interface controller available")
            return
        }

        let nowPlayingTemplate = CPNowPlayingTemplate.shared
        interfaceController.pushTemplate(nowPlayingTemplate, animated: true)
    }
    
}
