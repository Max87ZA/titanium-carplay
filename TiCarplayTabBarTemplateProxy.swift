//
//  TiCarplayTabBarTemplateProxy.swift
//  TiCarplay
//
//  Created by Max87 on 11/11/2023.
//

import TitaniumKit
import CarPlay
import os

@objc(TiCarplayTabBarTemplateProxy)
public class TiCarplayTabBarTemplateProxy: TiCarplayTemplateProxy, CPTabBarTemplateDelegate {
    public func tabBarTemplate(_ tabBarTemplate: CPTabBarTemplate, didSelect selectedTemplate: CPTemplate) {
        
    }
    
//    private var tabbarTemplate: CPTabBarTemplate?
    let logger = Logger(subsystem: "ti.carplay", category: "tabbartemplate")
    
    public override func _init(withProperties properties: [AnyHashable: Any]!) {
        super._init(withProperties: properties)

        if let templates = properties["templates"] as? [TiCarplayTemplateProxy] 
        {
            
            var templateArray: [CPTemplate] = []
            var index = 0
            for templateProxy in templates {
                if let templateFromProxy = templateProxy.template {
                    // Do something with each template
                    if let tabTitle = templateFromProxy.tabTitle {
                        logger.info("tabTitle \(tabTitle)")
                    }
                    else
                    {
                        logger.info("no tabTitle for template \(index)")
                    }
                    templateArray.append(templateFromProxy)
                    index+=1
                }
            }

            template = CPTabBarTemplate(templates: templateArray)
            logger.info("maximum tabCount custom template: \(CPTabBarTemplate.maximumTabCount)")

        } else {
            // Handle the case where "templates" is not an array of TiCarplayTemplateProxy
            let listItem = CPListItem(text: "List Item ", detailText: "List Item detail text")
            let section = CPListSection(items: [listItem])
            
            let listTemplate = CPListTemplate(title: "Home", sections: [section])
            listTemplate.tabSystemItem = .featured
            listTemplate.tabTitle = "Home"
            listTemplate.showsTabBadge = false
            template = CPTabBarTemplate(templates: [listTemplate])
            logger.info("maximum tabCount default template: \(CPTabBarTemplate.maximumTabCount)")
        }
        
        
    }
    @objc(maximumTabCount)
    func maximumTabCount() -> Any {
        // Ensure that the template is of type CPTabBarTemplate before accessing maximumTabCount
        if let tabBarTemplate = template as? CPTabBarTemplate {
            logger.info("maximum tabCount(): \(CPTabBarTemplate.maximumTabCount)")
            return CPTabBarTemplate.maximumTabCount
        } else {
            return 0 // Or handle the case where template is not of type CPTabBarTemplate
        }
    }
    
    @objc(getTemplatesLength:)
    public func getTemplatesLength(args: [Any]) -> Any {

        guard let tabbar = args.first as? TiCarplayTabBarTemplateProxy,
              let tabBar = tabbar.template as? CPTabBarTemplate else {
            // Handle invalid input or return an empty array based on your requirement
            return []
        }

        // Assuming you have a property in your TiCarplayTabBarTemplateProxy named templates
        logger.info("tabBar.templates length: \(tabBar.templates.count)")
        return tabBar.templates.count
    }
    
    @objc(updateTemplates:)
    public func updateTemplates(args: Array<Any>) {

        let tabbar = args[0] as! TiCarplayTabBarTemplateProxy
        let tabBar = tabbar.template as! CPTabBarTemplate
        let templates = args[1] as! [TiCarplayTemplateProxy]
        var templateArray: [CPTemplate] = []
        
        for templateProxy in templates
        {
            if let templateFromProxy = templateProxy.template {
                // Do something with each template
                templateArray.append(templateFromProxy)
                
            }
        }
        
        tabBar.updateTemplates(templateArray)
        logger.info("TabBar update templates successfull")
    }
    
    @objc(updateTemplate:)
    public func updateTemplate(args: Array<Any>) {

        let tabbar = args[0] as! TiCarplayTabBarTemplateProxy
        let tabBar = tabbar.template as! CPTabBarTemplate
        let newTemplateProxy = args[1] as! TiCarplayTemplateProxy
        guard let newTemplate = newTemplateProxy.template else { return  }
        let index = args[2] as! Int
        
        var newTemplates: [CPTemplate] = []
        if(index <= tabBar.templates.count)
        {
            for (currentIndex, template) in tabBar.templates.enumerated()
            {
                if(currentIndex != index)
                {
                    newTemplates.append(template)
                }
                else
                {
                    newTemplates.append(newTemplate)
                }
            }
        }
        else
        {
            var newTemplates:[CPTemplate] = tabBar.templates
            newTemplates.append(newTemplate)
        }
        
        tabBar.updateTemplates(newTemplates)
        logger.info("TabBar update template successfull")
    }
    
    
    
}

