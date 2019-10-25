//
//  ViewController.swift
//  UIPresentationController_sample
//
//  Created by yhonda on 2019/10/16.
//  Copyright © 2019 yhonda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    }


    @IBAction func didTapButton() {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") {
//            vc.modalPresentationStyle = .custom
//            vc.transitioningDelegate = self
//            present(vc, animated: true, completion: nil)
//        }
        
        let alert = showAlert(title: "modal", message: "message is long message \n left alignment setting")
        
        print(alert.preferredContentSize.debugDescription)
        print(alert.presentationController?.frameOfPresentedViewInContainerView.debugDescription)
        print(alert.presentationController?.presentedView.debugDescription)
        
        
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class ModalViewController: UIViewController {
    
//    private lazy var closeButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        view.layer.cornerRadius = 10.0
//        let alert = showAlert(title: "modal", message: "message")
//
//        print(alert.preferredContentSize.debugDescription)
//        print(alert.presentationController?.frameOfPresentedViewInContainerView.debugDescription)
//        print(alert.presentationController?.presentedView.debugDescription)
//
//
//
//        present(alert, animated: true, completion: nil)
    }
}

extension ModalViewController {
    
    func setup() {
        
        
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String) -> UIAlertController {
        
        let font = UIFont(name: "HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        paragraphStyle.alignment = .left
        
        let attributed: [NSAttributedString.Key : Any] = [//.font : font,
                                                          .paragraphStyle : paragraphStyle,
                                                          .foregroundColor : UIColor.purple]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributed)
        let attributedMessage = NSAttributedString(string: message, attributes: attributed)
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        return alert
    }
}
