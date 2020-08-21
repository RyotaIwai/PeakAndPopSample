//
//  ViewController.swift
//  PAndP
//
//  Created by Ryota Iwai on 2020/08/21.
//  Copyright © 2020 Ryota Iwai. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var button1: ForceTouchableButton! {
        didSet {
            self.button1.layer.cornerRadius = 8
            self.button1.setPreviewingDelegate(self, delegate: self)
        }
    }
    @IBOutlet private weak var button2: ForceTouchableButton! {
        didSet {
            self.button2.layer.cornerRadius = self.button2.bounds.height / 2
            self.button2.setPreviewingDelegate(self, delegate: self)
        }
    }

    @IBOutlet private weak var view1: ForceTouchableView! {
        didSet {
            self.view1.setPreviewingDelegate(self, delegate: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func button1Tapped(_ sender: Any) {
        guard let vc = self.viewController2() else {
            return
        }
        vc.configure(with: .one)
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction private func button2Tapped(_ sender: Any) {
        guard let vc = self.viewController2() else {
            return
        }
        vc.configure(with: .two)
        self.present(vc, animated: true, completion: nil)
    }

    private func viewController2() -> ViewController2? {
        let storyboard = UIStoryboard.init(name: "ViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ViewController2
    }
}

// MARK: - For Peak and Pop

extension ViewController: PeekShowable {
    func previewingViewController(view: (UIView & ForceTouchable)) -> (UIViewController & Peekable)? {
        guard let vc = self.viewController2() else {
            return nil
        }
        if view === self.button1 {
            vc.configure(with: .one)
        } else if view === self.button2 {
            vc.configure(with: .two)
        } else if view === self.view1 {
            vc.configure(with: .three)
        }
        return vc
    }
}

// MARK: ContextMenusShowable

@available(iOS 13.0, *)
extension ViewController: ContextMenusShowable {}

// MARK: UIContextMenuInteractionDelegate

@available(iOS 13.0, *)
extension ViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return self.contextMenu(interaction, configurationForMenuAtLocation: location)
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.contextMenu(interaction, previewForHighlightingMenuWithConfiguration: configuration)
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionCommitAnimating) {
        return self.contextMenu(interaction, willPerformPreviewActionForMenuWith: configuration, animator: animator)
    }
}

// MARK: UIViewControllerPreviewingDelegate
// Before iOS12
extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let forceTouchableView = previewingContext.sourceView as? (UIView & ForceTouchable) else {
            return nil
        }
        return self.previewingViewController(view: forceTouchableView)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewController = viewControllerToCommit as? Peekable else {
            return
        }
        viewController.pop()
        self.present(viewControllerToCommit, animated: false, completion: nil)
        return
    }
}
