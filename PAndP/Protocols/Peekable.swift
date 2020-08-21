//
//  Peekable.swift
//  PAndP
//
//  Created by Ryota Iwai on 2020/08/21.
//  Copyright © 2020 Ryota Iwai. All rights reserved.
//

import Foundation
import UIKit

struct MenuTitle {
    let title: String
    let image: UIImage?
    let isStrongAttribute: Bool
}

struct MenuItem {
    let title: MenuTitle
    let action: (UIViewController) -> Void
}

protocol Peekable: class {
    func peek()
    func pop()

    var menuItems: [MenuItem] { get }
    var previewItems: [UIPreviewActionItem] { get }

    @available(iOS 13.0, *)
    func prepare()

    @available(iOS 13.0, *)
    var menu: UIMenu? { get }
}

extension Peekable {
    func peek() {}
    func pop() {}

    var previewItems: [UIPreviewActionItem] {
        let items: [UIPreviewActionItem] = self.menuItems.map { (item) -> UIPreviewActionItem in
            return UIPreviewAction(title: item.title.title, style: item.title.isStrongAttribute ? .destructive : .default) { (_, vc) in
                item.action(vc)
            }
        }
        return items
    }
}

@available(iOS 13.0, *)
extension Peekable where Self: UIViewController {

    func prepare() {
        // For call viewDidLoad()
        self.loadViewIfNeeded()
    }

    var menu: UIMenu? {
        let items: [UIAction] = self.menuItems.map { (item) -> UIAction in
            return UIAction(title: item.title.title, image: item.title.image, attributes: item.title.isStrongAttribute ? [.destructive] : []) { [weak self] _ in
                guard let me = self else {
                    return
                }
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                item.action(me)
            }
        }
        return UIMenu(title: "", image: nil, identifier: nil, children: items)
    }
}
