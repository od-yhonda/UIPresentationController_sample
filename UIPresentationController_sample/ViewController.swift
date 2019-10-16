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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") {
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: nil)
        }
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
    }
}

extension ModalViewController {
    
    func setup() {
        
        
    }
}
