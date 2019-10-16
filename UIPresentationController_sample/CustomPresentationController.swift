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
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.infoLight)
        button.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    let margin = (x: CGFloat(30), y: CGFloat(220.0))
    private let contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20)
    
    // 表示トランジション開始前に呼ばれる
    override func presentationTransitionWillBegin() {
        
        guard let containerView = containerView else { return }
        containerView.insertSubview(overlayView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.7
            },
                                                               completion: nil)
    }
    
    // 非表示トランジション開始前に呼ばれる
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.0
            },
                                                               completion: nil)
    }
    
    // 非表示トランジション開始後に呼ばれる
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    // 子のコンテナのサイズを返す
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width - margin.x, height: parentSize.height - margin.y)
    }
    
    // 呼び出し先の View Controller の Frame を返す
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        let containerBounds = containerView?.bounds
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds!.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = margin.x / 2.0
        presentedViewFrame.origin.y = margin.y / 2.0
        
        return presentedViewFrame
    }

    // レイアウト開始前に呼ばれる
    override func containerViewWillLayoutSubviews() {
        overlayView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
        presentedView?.addSubview(closeButton)
    }

    // レイアウト開始後に呼ばれる
    override func containerViewDidLayoutSubviews() {
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
        dismiss()
    }
    
    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss()
    }
}
