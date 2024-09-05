//
//  SceneDelegate.swift
//  carplay_test_swift
//
//  Created by Hans Knöchel on 31.10.23.
//

import UIKit
import CarPlay
import TitaniumKit

class TiCarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
  
  var interfaceController: CPInterfaceController?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
  }
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
    self.interfaceController = interfaceController
    
    // NOTE: This is an example implementation of some common templates that could be shown as the initial state.
    // Ideally, you should remove this piece at some point and control everything via the JS APIs
    
    // Item 1: Show child template
    let listItem1 = CPListItem(text: "List Item 1", detailText: "Hello world")
    listItem1.handler = { [weak self] (item, completion) in
      self?.interfaceController?.pushTemplate(CPListTemplate(title: "Show child template", sections: []), animated: true, completion: nil)
      completion()
    }
    
    // Item 2: Show alert template
    let listItem2 = CPListItem(text: "List Item 2", detailText: "Show alert template")
    listItem2.handler = { [weak self] (item, completion) in
      let alertTemplate = CPAlertTemplate(titleVariants: ["Test"], actions: [CPAlertAction(title: "Delete", style: .destructive, handler: { _ in
        self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
        completion()
      })])
      self?.interfaceController?.presentTemplate(alertTemplate, animated: true, completion: nil)
    }

    // Item 3: Show info template
    let listItem3 = CPListItem(text: "List Item 3", detailText: "Show info template")
    listItem3.handler = { [weak self] (item, completion) in
      let infoTemplate = CPInformationTemplate(title: "Information", layout: .leading, items: [CPInformationItem(title: "Title", detail: "Subtitle")], actions: [CPTextButton(title: "Action", textStyle: .normal, handler: { _ in
        self?.interfaceController?.popTemplate(animated: true, completion: nil)
      })])
      
      self?.interfaceController?.pushTemplate(infoTemplate, animated: true, completion: nil)
      completion()
    }
  let listItem4 = CPListItem(text: "List Item 4", detailText: "Show info template")
  listItem4.handler = { [weak self] (item, completion) in
    let infoTemplate = CPInformationTemplate(title: "Information", layout: .leading, items: [CPInformationItem(title: "Title", detail: "Subtitle")], actions: [CPTextButton(title: "Action", textStyle: .normal, handler: { _ in
      self?.interfaceController?.popTemplate(animated: true, completion: nil)
    })])
    
    self?.interfaceController?.pushTemplate(infoTemplate, animated: true, completion: nil)
    completion()
  }

    let section = CPListSection(items: [listItem1, listItem2, listItem3, listItem4])
    let listTemplate = CPListTemplate(title: "Home", sections: [section])
    listTemplate.showsTabBadge = false
      
      var listItems = [CPListItem]()
      
      // Use default list of songs data and create a list
      // of CPListItems from the default songs.
      var defaultListItems: [CPListItem] = []
      
          defaultListItems.append(
              CPListItem(
                  text: "song.title",
                  detailText: "song.artist.name"
              )
          )
      
      listItems.append(contentsOf: defaultListItems)
      
      // Set a handler to handle selection.
      for listItem in listItems {
          listItem.handler = { item, completion in
              print("\(String(describing: item.text)) - selected.")
          }
      }
      
      // Create a CPListSection using the list items array
      // created above.
      let listSection = CPListSection(items: listItems)
      
      // Create the list template and set tab image icon.
      let songsListTemplate = CPListTemplate(
          title: "Songy",
          sections: [ listSection ]
      )
//      songsListTemplate.tabImage = UIImage(
//          systemName: "music.house"
//      )
      songsListTemplate.tabSystemItem = .search
      
//      songsListTemplate.tabSystemItem = .search
      
      
      let tabTemplate = CPTabBarTemplate(templates: [listTemplate, songsListTemplate])
      
//    listTemplate.tabSystemItem = .featured
      
    
    
    self.interfaceController?.setRootTemplate(tabTemplate, animated: true, completion: nil)
  }
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
    
  }
  
  // MARK: Disconnect
  
  func sceneDidDisconnect(_ scene: UIScene) {
    
  }
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController, from window: CPWindow) {
    
  }
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
    self.interfaceController = nil
  }
  
  // MARK: Select
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didSelect navigationAlert: CPNavigationAlert) {
    
  }
  
  func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didSelect maneuver: CPManeuver) {
    
  }
}

