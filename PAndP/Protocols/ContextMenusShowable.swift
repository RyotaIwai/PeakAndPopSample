//
//  ContextMenusShowable.swift
//  PAndP
//
//  Created by Ryota Iwai on 2020/08/21.
//  Copyright © 2020 Ryota Iwai. All rights reserved.
//

import Foundation
import UIKit

protocol PeekShowable: class {
    func previewingViewController(view: (UIView & ForceTouchable)) -> (UIViewController & Peekable)?
}

@available(iOS 13.0, *)
protocol ContextMenusShowable: PeekShowable {
    func contextMenu(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration?
    func contextMenu(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview?
    func contextMenu(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating)
}

@available(iOS 13.0, *)
extension ContextMenusShowable where Self: UIViewController {
    func contextMenu(_ interaction: UIContextMenuInteraction,
                     configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard
            let interactionView = interaction.view as? (UIView & ForceTouchable),
            let vc = self.previewingViewController(view: interactionView)  else {
                return nil
        }

        vc.prepare()
        vc.peek()
        let previewProvider: () -> UIViewController? = {
            return vc
        }
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            return vc.menu
        }
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProvider,
                                          actionProvider: actionProvider)
    }

    func contextMenu(_ interaction: UIContextMenuInteraction,
                     previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let view = interaction.view else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        return UITargetedPreview(view: view, parameters: parameters)
    }

    func contextMenu(_ interaction: UIContextMenuInteraction,
                     willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                     animator: UIContextMenuInteractionCommitAnimating) {
        guard let viewController = animator.previewViewController as? (UIViewController & Peekable) else {
            return
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        animator.preferredCommitStyle = .pop
        viewController.pop()
        animator.addCompletion {
            self.present(viewController, animated: false, completion: nil)
        }
    }
}
