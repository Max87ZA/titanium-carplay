/**
 * Axway Titanium
 * Copyright (c) 2018-present by Axway Appcelerator. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

import TitaniumKit
import CarPlay

@objc(TiCarplayListTemplateProxy)
public class TiCarplayListTemplateProxy : TiCarplayTemplateProxy {

  public override func _init(withProperties properties: [AnyHashable : Any]!) {
    super._init(withProperties: properties)
        
    let title = TiUtils.stringValue("title", properties: properties)
    let sections = properties["sections"] as? [[String: Any]]
    
    template = CPListTemplate(title: title, sections: mapped(sections: sections))
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
      
  }
  
//  private func mapped(sections: [[String: Any]]?) -> [CPListSection] {
//    guard let sections else {
//      return []
//    }
//    
//      return sections.enumerated().map { (sectionIndex, section) in
//      if let items = section["items"] as? [[String: Any]] {
//          return CPListSection(items: items.enumerated().map({ (itemIndex, item) in
//          let text = item["text"] as? String
//          let detailText = item["detailText"] as? String
//          let handler = item["handler"] as? KrollCallback
//          let imagePath = item["image"] as? String
//          let isPlaying = item["isPlaying"] as? Bool ?? false
//          let isPlayingIndicatorPosition = item["isPlayingIndicatorPosition"] as? String ?? "leading"
////          let listItem = CPListItem(text: text, detailText: detailText)
//          let listItem: CPListItem
//
////          if let imageName = imageName, let image = UIImage(named: imageName) ?? UIImage(systemName: imageName) {
////              listItem = CPListItem(text: text, detailText: detailText, image: image)
////          } else {
////              listItem = CPListItem(text: text, detailText: detailText)
////          }
//          
//          var image: UIImage? = nil
//
//          if let imagePath = imagePath {
//              if imagePath.hasPrefix("http://") || imagePath.hasPrefix("https://"),
//                 let url = URL(string: imagePath),
//                 let data = try? Data(contentsOf: url),
//                 let downloadedImage = UIImage(data: data) {
//                  image = downloadedImage
//              } else if imagePath.hasPrefix("file://"),
//                        let url = URL(string: imagePath),
//                        let data = try? Data(contentsOf: url),
//                        let fileImage = UIImage(data: data) {
//                  image = fileImage
//              } else if let embeddedImage = UIImage(named: imagePath) ?? UIImage(systemName: imagePath) {
//                  image = embeddedImage
//              }
//          }
//              if let image = image {
//                  let imageRowItem = CPListImageRowItem(text: text??,  images: [image])
//                  listItem = imageRowItem as CPListItem
//              } else {
//                  listItem = CPListItem(text: text, detailText: detailText)
//              }
//              
//          if #available(iOS 15.0, *) {
//              listItem.isPlaying = isPlaying
//              switch isPlayingIndicatorPosition
//              {
//              case "leading":
//                  listItem.playingIndicatorLocation = .leading
//                  
//              case "trailing":
//                  listItem.playingIndicatorLocation = .trailing
//              default:
//                  listItem.playingIndicatorLocation = .leading
//              }
//              
//          }
//          listItem.handler = { [weak self] (item, completion) in
//            handler?.callAsync([["sectionIndex": sectionIndex, "itemIndex": itemIndex]], thisObject: self)
//            completion()
//          }
//          
//          return listItem
//        }))
//      }
//      
//      return CPListSection(items: [])
//    }
//  }
    private func mapped(sections: [[String: Any]]?) -> [CPListSection] {
        guard let sections = sections else {
            return []
        }

        return sections.enumerated().map { (sectionIndex, section) in
            guard let items = section["items"] as? [[String: Any]] else {
                return CPListSection(items: [])
            }

            var listItems: [CPListItem] = []

            for (itemIndex, item) in items.enumerated() {
                let text = item["text"] as? String ?? ""
                let detailText = item["detailText"] as? String
                let imagePath = item["image"] as? String
                let handler = item["handler"] as? KrollCallback
                let isPlaying = item["isPlaying"] as? Bool ?? false
                let isPlayingIndicatorPosition = item["isPlayingIndicatorPosition"] as? String ?? "leading"
                var image: UIImage? = nil

                // Load image from any supported source
                if let imagePath = imagePath {
                    if imagePath.hasPrefix("http") || imagePath.hasPrefix("https"),
                       let url = URL(string: imagePath),
                       let data = try? Data(contentsOf: url),
                       let remoteImage = UIImage(data: data) {
                        image = remoteImage
                    } else if imagePath.hasPrefix("file://"),
                              let url = URL(string: imagePath),
                              let data = try? Data(contentsOf: url),
                              let fileImage = UIImage(data: data) {
                        image = fileImage
                    } else {
                        image = UIImage(named: imagePath) ?? UIImage(systemName: imagePath)
                    }
                }

                // Always use CPListItem to support isPlaying and detailText
                let listItem: CPListItem
                if let image = image {
                    listItem = CPListItem(text: text, detailText: detailText, image: image)
                } else {
                    listItem = CPListItem(text: text, detailText: detailText)
                }

                if #available(iOS 15.0, *) {
                    listItem.isPlaying = isPlaying
                    switch isPlayingIndicatorPosition
                    {
                    case "leading":
                        listItem.playingIndicatorLocation = .leading
                        
                    case "trailing":
                        listItem.playingIndicatorLocation = .trailing
                    default:
                        listItem.playingIndicatorLocation = .leading
                    }
                }

                listItem.handler = { [weak self] (_, completion) in
                    handler?.callAsync([[
                        "sectionIndex": sectionIndex,
                        "itemIndex": itemIndex
                    ]], thisObject: self)
                    completion()
                }

                listItems.append(listItem)
            }

            return CPListSection(items: listItems)
        }
    }



    
    @objc(updateSections:)
    public func updateSections(_ args: [Any]?) {
        guard let listTemplate = self.template as? CPListTemplate else {
            print("Current template is not a CPListTemplate")
            return
        }

        guard let sectionsData = args?.first as? [[String: Any]] else {
            print("Invalid sections data")
            return
        }

        let newSections = mapped(sections: sectionsData)
        listTemplate.updateSections(newSections)
    }
    
    
}
