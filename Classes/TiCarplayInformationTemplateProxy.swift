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
    public override func _init(withProperties properties: [AnyHashable: Any]!) {
        super._init(withProperties: properties)
        
        
        let title = TiUtils.stringValue("title", properties: properties)
        let detail = properties["detail"] as? String? ?? "Default Detail Value"
        let layoutString = properties["layout"] as? String? ?? "leading"
        let lines = detail?.components(separatedBy: "\n")
        if let privacyDetail = detail {
                    logger.info("detail: \(privacyDetail, privacy: .public)")
                } else {
                    logger.info("detail is nil or not a String")
                }
        let actions = properties["actions"] as? [String]?
        
        if let lines = detail?.components(separatedBy: "\n")
        {
            
            
            // Create an array of CPInformationItem objects
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
                // If layoutString is neither "leading" nor "twoColumn", use a default value
                layout = .leading
            }
            template = CPInformationTemplate(title: title! ,
                                             layout: layout,
//                                             items: [CPInformationItem(title: "", detail: detail!)],
                                             items: informationItems,
                                             actions: mapped(actions:actions as? [String]))
            if let tabImage = TiUtils.stringValue("tabImage", properties: properties)
            {
      //          template.tabTitle = tabTitle
                template.tabImage = UIImage(
                    systemName: tabImage
                )
            }
            else
            {
      //          template.tabSystemItem = .favorites
            }
            // Now, 'informationItems' contains individual CPInformationItem objects
        }
    }
    private func mapped(actions: [String]?) -> [CPTextButton] 
    {
        let logger = Logger(subsystem: "ti.carplay", category: "infotemplate")
        guard let actions else {
        return []
      }
        var actionButtonsArray:[CPTextButton] = []
        for actionTitle in actions
        {
            let actionButton = CPTextButton(
                    title: actionTitle,
                    textStyle: .normal
            )
            { [weak self] button in
                        // Handle button tap if needed
                if(button.title == "HAKA")
                {
                    if let customURL = URL(string: "tel://+421910666910")
                    {
                        logger.info("calling \(customURL)")
                        UIApplication.shared.open(customURL, options: [:], completionHandler: nil)
//                        self.carplayScene?.open(customURL, options: [:], completionHandler: nil)
                    }
                }
                else if(button.title == "Polícia")
                {
                    if let customURL = URL(string: "tel://158")
                    {
                        logger.info("calling \(customURL)")
                        UIApplication.shared.open(customURL, options: [:], completionHandler: nil)
                    }
                }
                else if(button.title == "Next")
                {
                    
                }
                else if(button.title == "Previous")
                {
                    
                }
                else if(button.title == "Done")
                {
                    
                }

            }
            actionButtonsArray.append(actionButton)
        }
        return actionButtonsArray
    }
}


