//
//  TiCarplaySearchTemplateProxy.swift
//  TiCarplay
//
//  Created by Max87 on 01/11/2023.
//

import TitaniumKit
import CarPlay

@objc(TiCarplaySearchTemplateProxy)
public class TiCarplaySearchTemplateProxy: TiCarplayTemplateProxy, CPSearchTemplateDelegate {
    var searchTemplate: CPSearchTemplate!
    var handler: KrollCallback?

    public override func _init(withProperties properties: [AnyHashable: Any]!) {
        super._init(withProperties: properties)
        handler = properties["handler"] as? KrollCallback

        // Create a search template
        searchTemplate = CPSearchTemplate()
        searchTemplate.delegate = self

        // Set the template
        template = searchTemplate
    }

    public func searchTemplate(_ searchTemplate: CPSearchTemplate, updatedSearchText searchText: String, completionHandler: @escaping ([CPListItem]) -> Void) {
        // Implement your search logic here and provide an array of search results as CPListItems
        // For example, you can filter data based on the searchText and return matching items.

        // Create an array of CPListItems (example)
        let listItem3 = CPListItem(text: "List Item 3", detailText: "Show info template")

        // Call the handler to provide search results asynchronously
        handler?.callAsync([["searchText": searchText]], thisObject: self)

        completionHandler([listItem3])
    }

    public func searchTemplate(_ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem, completionHandler: @escaping () -> Void) {
        // Handle the selection of a search result
        // Implement your action when a search result is selected
    }
}
