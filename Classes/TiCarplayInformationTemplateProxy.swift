//
//  TiCarplayInformationTemplateProxy.swift
//  TiCarplay
//
//  Created by Max87 on 01/11/2023.
//

import TitaniumKit
import CarPlay
import os

@objc(TiCarplayInformationTemplateProxy)
public class TiCarplayInformationTemplateProxy: TiCarplayTemplateProxy {
    let logger = Logger(subsystem: "ti.carplay", category: "infotemplate")
    var currentPage: Int = 0
    let pageSize: Int = 5
    let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    var userInput = ""
    public var handler: KrollCallback?
    
    public override func _init(withProperties properties: [AnyHashable: Any]!) 
    {
        super._init(withProperties: properties)
        
        
        let title = TiUtils.stringValue("title", properties: properties)
        let detail = properties["detail"] as? String? ?? "Default Detail Value"
        handler = properties["callback"] as? KrollCallback? ?? nil
        let callback = properties["callback"] as? KrollCallback
//        logger.log("handler: \(typeof handler)")
        logger.log("infotemplate callback: \(callback)")
        if(handler == nil)
        {
            logger.log("infotemplate handler is nill in init")
        }
        else
        {
            logger.log("infotemplate handler is not nill in init")
        }
        handler = callback
        let layoutString = properties["layout"] as? String? ?? "leading"
        let lines = detail?.components(separatedBy: "\n")
        if let privacyDetail = detail {
                    logger.info("detail: \(privacyDetail, privacy: .public)")
                } else {
                    logger.info("detail is nil or not a String")
                }
        let actions = properties["actions"] as? [String]?
        
        // Create an array of CPInformationItem objects for the information template
                if let lines = detail?.components(separatedBy: "\n") {
                    var informationItems: [CPInformationItem] = []
                    for line in lines {
                        informationItems.append(CPInformationItem(title: "", detail: line))
                    }

                    var layout: CPInformationTemplateLayout
                    switch layoutString {
                    case "leading":
                        layout = .leading
                    case "twoColumn":
                        layout = .twoColumn
                    default:
                        layout = .leading
                    }

                    // Get actions (buttons) from Titanium side and create buttons dynamically
                    let actions = properties["actions"] as? [[String: Any]]

                    // Set up the template with information items and buttons
                    template = CPInformationTemplate(title: title!,
                                                     layout: layout,
                                                     items: informationItems,
                                                     actions: mapped(actions:actions, callback:callback ?? nil ))

                    if let tabImage = TiUtils.stringValue("tabImage", properties: properties) {
                        template.tabImage = UIImage(systemName: tabImage)
                    }
                }
            }
            
    func mapped(actions: [[String: Any]]?, callback:KrollCallback?) -> [CPTextButton] {
                let logger = Logger(subsystem: "ti.carplay", category: "infotemplate")
                guard let actions = actions else { return [] }
                var actionButtonsArray: [CPTextButton] = []
                for action in actions {
                    guard let title = action["title"] as? String,
                          let handlerName = action["handler"] as? String else {
                        logger.log("Invalid action format. Missing title or handler.")
                        continue
                    }
                    let actionButton = CPTextButton(
                                        title: title,
                                        textStyle: .normal
                                )
                                { [weak self] button in
                                            // Handle button tap if needed
                                    if(handlerName == "haka")
                                    {
                                        if let customURL = URL(string: "tel://+421910666910")
                                        {
                                            logger.log("calling \(customURL)")
                                            UIApplication.shared.open(customURL, options: [:], completionHandler: nil)
                    //                        self.carplayScene?.open(customURL, options: [:], completionHandler: nil)
                                        }
                                    }
                                    else if(handlerName == "policia")
                                    {
                                        if let customURL = URL(string: "tel://158")
                                        {
                                            logger.log("calling \(customURL)")
                                            UIApplication.shared.open(customURL, options: [:], completionHandler: nil)
                                        }
                                    }
                                    else if(handlerName == "start")
                                    {
                                        logger.log("calling start event")
//                                        if(self?.handler != nil)
//                                        {
//                                            self?.handler?.call([["event":"start"]], thisObject: self)
//                                            
//                                        }
//                                        else
//                                        {
//                                            logger.log("no start handler")
//                                            
//                                        }
                                        if(callback != nil)
                                        {
                                            logger.log("start callback called")
                                            callback?.callAsync([["event":"start"]], thisObject: self)
                                        }
                                        else
                                        {
                                            logger.log("no start callback")
                                        }
                                        
                                        
                                    }
                                    else if(handlerName == "done")
                                    {
                                        logger.log("calling done event")
//                                        if(self?.handler != nil)
//                                        {
//                                            self?.handler?.call([["event":"done"]], thisObject: self)
//                                            
//                                        }
//                                        else
//                                        {
//                                            logger.log("no done handler")
//                                            
//                                        }
                                        if(callback != nil)
                                        {
                                            logger.log("done callback called")
                                            callback?.callAsync([["event":"done"]], thisObject: self)
                                        }
                                        else
                                        {
                                            logger.log("no done callback")
                                        }
                                        
                                        
                                    }
                                    else if(handlerName == "startOver")
                                    {
                                        logger.log("calling startOver event")
//                                        if(self?.handler != nil)
//                                        {
//                                            self?.handler?.call([["event":"startOver"]], thisObject: self)
//                                            
//                                        }
//                                        else
//                                        {
//                                            logger.log("no startOver handler")
//                                            
//                                        }
                                        if(callback != nil)
                                        {
                                            logger.log("startOver callback called")
                                            callback?.callAsync([["event":"startOver"]], thisObject: self)
                                        }
                                        else
                                        {
                                            logger.log("no startOver callback")
                                        }
                                        
                                        
                                    }
                                

                                }
                    
                    actionButtonsArray.append(actionButton)
                }
                
                return actionButtonsArray
            }
            

            
        }



