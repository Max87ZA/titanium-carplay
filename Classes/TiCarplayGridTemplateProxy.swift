//
//  TiCarplayGridTemplateProxy.swift
//  TiCarplay
//
//  Created by Max87 on 11/09/2024.
//

import TitaniumKit
import CarPlay
import os

@objc(TiCarplayGridTemplateProxy)
public class TiCarplayGridTemplateProxy: TiCarplayTemplateProxy {
    let logger = Logger(subsystem: "ti.carplay", category: "gridtemplate")
    var handler: KrollCallback?
    var gridTemplate: CPGridTemplate?
    public override func _init(withProperties properties: [AnyHashable: Any]!) {
            super._init(withProperties: properties)

            let title = TiUtils.stringValue("title", properties: properties)
            let buttons = properties["buttons"] as? [[String: Any]]

            template = CPGridTemplate(title: title, gridButtons: mapped(buttons: buttons))

            if let tabImage = TiUtils.stringValue("tabImage", properties: properties) {
                template.tabImage = UIImage(systemName: tabImage)
            }
            if let tabTitle = TiUtils.stringValue("tabTitle", properties: properties) {
                template.tabTitle = tabTitle
            }
        }

        private func mapped(buttons: [[String: Any]]?) -> [CPGridButton] {
            guard let buttons else {
                return []
            }

            return buttons.enumerated().compactMap { (index, item) in
                guard let title = item["title"] as? String,
                      let imageName = item["image"] as? String else {
                    return nil
                }
                let image: UIImage
                if imageName.hasSuffix(".png") {
                    image = UIImage(named: imageName) ?? UIImage()
                } else {
                    image = UIImage(systemName: imageName) ?? UIImage()
                }
                let handler = item["handler"] as? KrollCallback

                let gridButton = CPGridButton(titleVariants: [title], image: image) { [weak self] _ in
                    handler?.callAsync([["index": index, "id": item["id"] ?? title]], thisObject: self)
                }

                return gridButton
            }
        }
    
}

