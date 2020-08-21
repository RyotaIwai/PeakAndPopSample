//
//  ForceTouchable.swift
//  PAndP
//
//  Created by Ryota Iwai on 2020/08/21.
//  Copyright © 2020 Ryota Iwai. All rights reserved.
//

import Foundation
import UIKit

protocol ForceTouchable {
    func setPreviewingDelegate(_ viewController: UIViewController, delegate: NSObjectProtocol)
}

extension ForceTouchable where Self: UIView {

    func setPreviewingDelegate(_ viewController: UIViewController, delegate: NSObjectProtocol) {
        if #available(iOS 13, *) {
            guard let interactionDelegate = delegate as? UIContextMenuInteractionDelegate else {
                return
            }
            self.addInteraction(UIContextMenuInteraction(delegate: interactionDelegate))
        } else {
            guard viewController.traitCollection.forceTouchCapability == .available,
                let previewingDelegate = delegate as? UIViewControllerPreviewingDelegate else {
                    return
            }
            _ = viewController.registerForPreviewing(with: previewingDelegate, sourceView: self)
        }
    }
}
