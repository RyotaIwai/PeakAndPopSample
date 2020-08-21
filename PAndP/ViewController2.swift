//
//  ViewController2.swift
//  PAndP
//
//  Created by Ryota Iwai on 2020/08/21.
//  Copyright © 2020 Ryota Iwai. All rights reserved.
//

import UIKit

final class ViewController2 :UIViewController {

    enum ImageNum {
        case one
        case two
        case three
        case four
        
        var text: String {
            switch self {
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            }
        }
        
        var image: UIImage? {
            return UIImage(named: self.text)
        }
    }

    private var imageNum: ImageNum = .one {
        didSet {
            self.imageView?.image = self.imageNum.image
            self.label?.text = self.imageNum.text
        }
    }
    
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            self.imageView.layer.cornerRadius = 8
            self.imageView.layer.borderColor = UIColor.white.cgColor
            self.imageView.layer.borderWidth = 1
            self.imageView.image = self.imageNum.image
        }
    }
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            self.label.text = self.imageNum.text
        }
    }
    
    func configure(with imageNum: ImageNum) {
        self.imageNum = imageNum
    }

    @IBAction private func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - For Peak and Pop

extension ViewController2: Peekable {
    var menuItems: [MenuItem] {
        var items: [MenuItem] = []
        items.append(
            MenuItem(
                title: MenuTitle(title: "Menu 1", image: nil, isStrongAttribute: false),
                action: { _ in
                    print("Tap Menu 1")
            })
        )
        items.append(
            MenuItem(
                title: MenuTitle(title: "Menu 2", image: nil, isStrongAttribute: false),
                action: { _ in
                    print("Tap Menu 2")
            })
        )
        items.append(
            MenuItem(
                title: MenuTitle(title: "Menu 3", image: nil, isStrongAttribute: true),
                action: { _ in
                    print("Tap Menu 3")
            })
        )

        return items
    }
}

// Before iOS12
extension ViewController2 {
    override var previewActionItems: [UIPreviewActionItem] {
        return self.previewItems
    }
}
