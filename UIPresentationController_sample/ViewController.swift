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

    let customAlertControllerTransitioningDelegate = CustomAlertControllerTransitioningDelegate()
    
    @IBAction func didTapButton() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as? ModalViewController {
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = customAlertControllerTransitioningDelegate
            
            let customView: CustomView = CustomView.instantiate()
            vc.contents = customView
            
            let ca = CustomAlertController(preferredStyle: .custom(customView))
            print("--------------------")
            print("ca.modalPresentationStyle: \(ca.modalPresentationStyle.rawValue)")
            print("ca.modalTransitionStyle: \(ca.modalTransitionStyle.rawValue)")
            print("ca.transitioningDelegate: \(ca.transitioningDelegate)")
            present(ca, animated: true, completion: nil)
        }
    }
    
    @IBAction func test() {
        print("押せちゃった")
    }
    
    func showSampleAlert() {
        let alert = showAlert(title: "modal", message: "message is long message \n left alignment setting")
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
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var const: NSLayoutConstraint!
    
    var contents: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        view.layer.cornerRadius = 10.0
        stackView.addArrangedSubview(contents)
        const.constant = contents.frame.height
    }
    
    func sample() {
    }
}

extension ModalViewController {
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String) -> UIAlertController {
        
//        let font = UIFont(name: "HiraKakuProN-W3", size: 12) ?? UIFont.systemFont(ofSize: 12)
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

enum AlertType {
    case info
    case warning
    case error
    case custom(title: String, message: String)
    
    var title: String {
        switch self {
        case .info: return "info title"
        case .warning: return "warning title"
        case .error: return "error title"
        case .custom(let title, _): return title
        }
    }
    
    var message: String {
        switch self {
        case .info: return "info message"
        case .warning: return "warning message"
        case .error: return "error message"
        case .custom(_, let message): return message
        }
    }
}

extension UIAlertController {
    
    static func create(type: AlertType, style: Style) -> UIAlertController {
        return UIAlertController(title: type.title, message: type.message, preferredStyle: style)
    }
    
    static func alert(type: AlertType) -> UIAlertController {
        return UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
    }
    
    static func sheet(type: AlertType) -> UIAlertController {
        return UIAlertController(title: type.title, message: type.message, preferredStyle: .actionSheet)
    }
    
    static func showAlert(title: String, message: String) -> UIAlertController {
        
            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 3.0
            paragraphStyle.alignment = .left
            
            let attributed: [NSAttributedString.Key : Any] = [.paragraphStyle : paragraphStyle]
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

extension UIAlertController {
    
    func addAction(title: String = "OK", action: ((UIAlertAction) -> ())? = nil) {
        addAction(.init(title: title, style: .default, handler: action))
    }
    
    func addCancelAction(title: String = "Cancel", action: ((UIAlertAction) -> ())? = nil) {
        addAction(.init(title: title, style: .cancel, handler: action))
    }
    
    func addDestructiveAction(title: String, action: ((UIAlertAction) -> ())? = nil) {
        addAction(.init(title: title, style: .destructive, handler: action))
    }
}

extension UIViewController {
    class func instantiate<T: UIViewController>() -> T {
        let viewControllerName = String(describing: T.self)
        let storyboard = UIStoryboard(name: viewControllerName, bundle: Bundle(for: T.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Failed to instantiate \(viewControllerName).")
        }
        return viewController
    }
}

extension UIView {
    
    class func instantiate<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Failed to instantiate \(nibName).")
        }
        return view
    }
}



class CustomAlertController: UIViewController {
    
    enum Style {
        case `default`
        case alert
        case alertWithClose(title: String?, m: String?)
        case custom(_ contentsView: UIView)
    }
    
     lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [contentsView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(#imageLiteral(resourceName: "sample_icon"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(preferredStyle: CustomAlertController.Style) {
        self.preferredStyle = preferredStyle
        
        switch preferredStyle {
        case .default, .alert, .alertWithClose:
            self.contentsView = UIView()
        case .custom(let contentsView):
            self.contentsView = contentsView
        }
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = customAlertControllerTransitioningDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?, message: String?, preferredStyle: CustomAlertController.Style) {
        self.init(preferredStyle: preferredStyle)
    }
    
//    var title: String?

    var message: String?
    
    var preferredStyle: CustomAlertController.Style
    
    let a = UIAlertController()
    
    
    
    var contentsView: UIView! {
        didSet {
            contentsView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let customAlertControllerTransitioningDelegate = CustomAlertControllerTransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
//        view.addSubview(stackView)
//        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: contentInsets.top).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInsets.left).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: contentInsets.bottom).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentInsets.right).isActive = true
        
//        let heightConstraint = contentsView.frame.height + contentInsets.top + contentInsets.bottom
//        stackView.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        
//        let widthConstraint = view.frame.width - contentInsets.left - contentInsets.right
//        stackView.widthAnchor.constraint(equalToConstant: widthConstraint).isActive = true
        
        containerView.addSubview(stackView)
//        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentInsets.left).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: contentInsets.bottom).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: contentInsets.right).isActive = true
        
        
        
//        let heightConstraint = contentsView.frame.height + contentInsets.top + contentInsets.bottom
//        stackView.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
        
//        let widthConstraint = view.frame.width - contentInsets.left - contentInsets.right
//        stackView.widthAnchor.constraint(equalToConstant: widthConstraint).isActive = true
        
//        view.addSubview(containerView)
//        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: contentInsets.top).isActive = true
//        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: contentInsets.left).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: contentInsets.bottom).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentInsets.right).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

//        let heightConstraint = contentsView.frame.height + contentInsets.top + contentInsets.bottom
//        containerView.heightAnchor.constraint(equalToConstant: heightConstraint).isActive = true
//        let widthConstraint = view.frame.width - contentInsets.left - contentInsets.right
//        containerView.widthAnchor.constraint(equalToConstant: widthConstraint).isActive = true
        
//        containerView.addSubview(contentsView)
//        contentsView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: contentInsets.top).isActive = true
//        contentsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentInsets.left).isActive = true
//        contentsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: contentInsets.bottom).isActive = true
//        contentsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: contentInsets.right).isActive = true

        containerView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        
//        view.addSubview(closeButton)
//        closeButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        closeButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
//        closeButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension CustomAlertController {
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension CustomAlertController {
    
    func addAction(title: String = "OK", action: ((UIAlertAction) -> ())? = nil) {
//        addAction(.init(title: title, style: .default, handler: action))
    }
    
    func addCancelAction(title: String = "Cancel", action: ((UIAlertAction) -> ())? = nil) {
//        addAction(.init(title: title, style: .cancel, handler: action))
    }
}

class CustomAlertControllerTransitioningDelegate: NSObject {
    
}

extension CustomAlertControllerTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
