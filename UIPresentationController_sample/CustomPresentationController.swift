//
//  CustomPresentationController.swift
//  UIPresentationController_sample
//
//  Created by yhonda on 2019/10/16.
//  Copyright © 2019 yhonda. All rights reserved.
//

import UIKit

final class CustomPresentationController: UIPresentationController {
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayViewDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        
        return view
    }()
    
//    private lazy var closeButton: UIButton = {
//
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        button.setImage(#imageLiteral(resourceName: "sample_icon"), for: .normal)
//        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        button.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
//        return button
//    }()
    
//    private lazy var label: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textColor = UIColor.white
//        label.lineBreakMode = .byWordWrapping
//        label.backgroundColor = UIColor.clear
//        label.numberOfLines = 2
//        label.font = UIFont.preferredFont(forTextStyle: .caption1)
//
//        return label
//    }()
    
//    let margin = (x: CGFloat(30), y: CGFloat(220.0))
//    private let contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20)
//    private var screenRatio: Float?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
//        guard let customAlertController = presentedViewController as? ModalViewController else {
//            fatalError("失敗")
//        }
//        contentsSize = customAlertController.contents.frame.size
        guard let customAlertController = presentedViewController as? CustomAlertController else {
            fatalError("失敗")
        }
        contentsSize = customAlertController.containerView.frame.size
//        overlayView.addSubview(closeButton)
//        closeButton.centerXAnchor.constraint(equalToSystemSpacingAfter: presentedViewController.view.trailingAnchor, multiplier: 0).isActive = true
//        closeButton.centerYAnchor.constraint(equalToSystemSpacingBelow: presentedViewController.view.topAnchor, multiplier: 0).isActive = true
    }
    
    var contentsSize: CGSize!
    
    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
//        containerView?.addSubview(overlayView)
//        overlayView.addSubview(presentedViewController.view)
//        overlayView.addSubview(closeButton)
        
        let transitionCoordinator = presentedViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { cont in
            self.overlayView.alpha = 0.7
        },
                                       completion: nil)
        
        
//        guard let containerView = containerView else { return }
//        containerView.insertSubview(overlayView, at: 0)
//
//        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
//            self?.overlayView.alpha = 0.7
//            },
//                                                               completion: nil)
    }
    
    // 非表示トランジション開始前に呼ばれる
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        let transitionCoordinator = presentedViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.0
            },
                                       completion: nil)
    }
    
    // 非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
//        if completed {
//            overlayView.removeFromSuperview()
//        }
        
        if !completed {
            overlayView.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // 子のコンテナのサイズを返す
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        var size = parentSize
        size.height = contentsSize.height+20

        return size
    }
    
    // 呼び出し先の View Controller の Frame を返す
    override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let containerView = containerView else { return CGRect() }
        
        let containerBounds = containerView.bounds
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        
        var presentedViewFrame = CGRect()
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = containerView.frame.midX - presentedViewFrame.midX
        presentedViewFrame.origin.y = containerView.frame.midY - presentedViewFrame.midY
        
        return presentedViewFrame
    }

    // レイアウト開始前に呼ばれる
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = containerView!.bounds
        
        let presentedViewFrame = frameOfPresentedViewInContainerView
        presentedView?.frame = presentedViewFrame
        
//        var closeButtonFrame = closeButton.frame
//        closeButtonFrame.origin.x = overlayView.frame.midX + presentedViewFrame.size.width/2 - closeButtonFrame.midX
//        closeButtonFrame.origin.y = overlayView.frame.midY - presentedViewFrame.size.height/2 - closeButtonFrame.midY
//
//        closeButton.frame = closeButtonFrame
    }

    // レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
    }
}

private extension CustomPresentationController {
    
    func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Action
extension CustomPresentationController {
    
    @IBAction func overlayViewDidTap(_ sender: UIGestureRecognizer) {
//        dismiss()
    }
    
    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss()
    }
}
