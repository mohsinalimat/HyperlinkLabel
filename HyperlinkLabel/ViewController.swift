//
//  ViewController.swift
//  HyperlinkLabel
//
//  Created by Ky Nguyen Coinhako on 4/5/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let termText = "By register, I agree to ... Terms of Service and Private Policy"
    let term = "Terms of Service"
    let policy = "Private Policy"
    let termLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        termLabel.text = termText
        
        let formattedText = String.format(strings: [term, policy],
                                          boldFont: UIFont.boldSystemFont(ofSize: 15),
                                          boldColor: UIColor.blue,
                                          inString: termText,
                                          font: UIFont.systemFont(ofSize: 15),
                                          color: UIColor.black)
        termLabel.attributedText = formattedText
        termLabel.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        termLabel.addGestureRecognizer(tap)
        termLabel.isUserInteractionEnabled = true
        termLabel.textAlignment = .center
        
        view.addSubview(termLabel)
        termLabel.frame = CGRect(x: 16, y: 100, width: UIScreen.main.bounds.width - 32, height: 50)
    }

    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termString = termText as NSString
        let termRange = termString.range(of: term)
        let policyRange = termString.range(of: policy)
        
        let tapLocation = gesture.location(in: termLabel)
        let index = termLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if checkRange(termRange, contain: index) == true {
            handleViewTermOfUse()
            return
        }
        
        if checkRange(policyRange, contain: index) {
            handleViewPrivacy()
            return
        }
    }
    
    func handleViewTermOfUse() {
        print("Term tapped")
    }
    
    func handleViewPrivacy() {
        print("Policy tapped")
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}

extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension String {
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedStringKey.font: font,
                                        NSAttributedStringKey.foregroundColor: color])
        let boldFontAttribute = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

