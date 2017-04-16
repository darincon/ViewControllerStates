//
//  ViewController.swift
//  UIStates
//
//  Created by Diego Rincon on 4/15/17.
//  Copyright © 2017 Scirestudios. All rights reserved.
//

import UIKit
import SnapKit

enum LoginState {
    case initial, waiting, invalidEmail, ready
}

class ViewController: UIViewController {
    
    enum Config {
        static let titleFont                = UIFont(name: "HelveticaNeue-Bold", size: 30)
        static let textFieldFont            = UIFont(name: "HelveticaNeue", size: 16)
        static let placeholderFont          = UIFont(name: "HelveticaNeue", size: 14)
        static let warningFont              = UIFont(name: "HelveticaNeue", size: 12)
        static let buttonFont               = UIFont(name: "HelveticaNeue", size: 18)
        
        static let itemsColor               = UIColor.white
        static let invalidEmailColor        = UIColor.red
        static let placeholderColor         = UIColor(white: 1.0, alpha: 0.7)
        
        static let underlineThickness       = CGFloat(0.5)
        static let borderWidth              = CGFloat(1)
        static let itemHeight               = CGFloat(50)
        static let warningHeight            = CGFloat(25)
        static let verticalSpacing          = CGFloat(15)
        
        static let widthMultiplier          = CGFloat(0.8)
        static let topMarginMultiplier      = CGFloat(0.05)
        static let emailVerticalMultiplier  = CGFloat(0.2)
        
        static let initialAnimationDuration = TimeInterval(1)
        static let animationDuration        = TimeInterval(0.3)
        static let initialDelay             = TimeInterval(1)
    }
    
    private var titleVerticalConstraint: Constraint?
    private var emailVerticalConstraint: Constraint?
    private var invalidEmailVerticalConstraint: Constraint?
    private var signInButtonVerticalConstraint: Constraint?
    private var signInButtonWidthConstraint: Constraint?
    
    var state: LoginState = .initial {
        didSet {
            updateSubviews(with: state)
        }
    }
    
    private var isValidEmail: Bool {
        return emailTextField.text?.isValidEmail == true
    }
    
    private var isValidPassword: Bool {
        guard let password = passwordTextField.text else {
            return false
        }
        
        return password.characters.count > 0
    }
    
    private var placeholderAttributes: [String: Any]? {
        guard let font = Config.placeholderFont else {
            return nil
        }
        
        return [NSForegroundColorAttributeName: Config.placeholderColor,
                NSFontAttributeName: font]
    }
    
    // MARK: Laxy variables
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var blurredBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background_blurred")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.font = Config.titleFont
        label.text = "SIGN IN"
        label.textColor = Config.itemsColor
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var emailTextField: UnderlinedTextField = { [unowned self] in
        let textField = UnderlinedTextField(underlineColor: Config.itemsColor, thickness: Config.underlineThickness)
        textField.tintColor = Config.itemsColor
        textField.textColor = Config.itemsColor
        textField.attributedPlaceholder = NSAttributedString(string: "email", attributes: self.placeholderAttributes)
        textField.font = Config.textFieldFont
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.delegate = self
        
        return textField
    }()
    
    lazy var passwordTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField(underlineColor: Config.itemsColor, thickness: Config.underlineThickness)
        textField.tintColor = Config.itemsColor
        textField.textColor = Config.itemsColor
        textField.attributedPlaceholder = NSAttributedString(string: "password", attributes: self.placeholderAttributes)
        textField.font = Config.textFieldFont
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return textField
    }()
    
    lazy var invalidEmailLabel: UILabel = {
        let label = UILabel()
        label.font = Config.warningFont
        label.text = "Invalid email"
        label.textColor = Config.invalidEmailColor
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderColor = Config.itemsColor.cgColor
        button.layer.borderWidth = Config.borderWidth
        button.layer.cornerRadius = Config.itemHeight / 2.0
        button.clipsToBounds = true
        button.titleLabel?.font = Config.buttonFont
        button.setTitle("SIGN IN", for: .normal)
        
        return button
    }()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupFixedLayouts()
        state = .initial
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let completion = { [weak self] (completed: Bool) -> Void in
            self?.emailTextField.becomeFirstResponder()
        }
        
        animateTransition(to: .waiting, duration: Config.initialAnimationDuration, delay: Config.initialDelay, completion: completion)
    }
    
    // MARK: Setup
    
    private func setupSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(blurredBackgroundImageView)
        view.addSubview(signInLabel)
        view.addSubview(emailTextField)
        view.addSubview(invalidEmailLabel)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
    }
    
    private func setupFixedLayouts(){
        backgroundImageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        blurredBackgroundImageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        signInLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(Config.widthMultiplier)
            make.centerX.equalToSuperview()
            make.height.equalTo(Config.itemHeight)
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(Config.widthMultiplier)
            make.centerX.equalToSuperview()
            make.height.equalTo(Config.itemHeight)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(Config.widthMultiplier)
            make.centerX.equalToSuperview()
            make.height.equalTo(Config.itemHeight)
            make.top.equalTo(emailTextField.snp.bottom).offset(Config.verticalSpacing)
        }
        
        invalidEmailLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(emailTextField)
            make.height.equalTo(Config.warningHeight)
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(Config.itemHeight)
        }
    }
    
    // MARK: UI state updates
    
    private func updateSubviews(with state: LoginState) {
        updateBackground(with: state)
        updateBlurredBackground(with: state)
        updateSignInLabel(with: state)
        updateEmailField(with: state)
        updatePasswordField(with: state)
        updateInvalidEmailLabel(with: state)
        updateSignInButton(with: state)
    }
    
    private func updateBackground(with state: LoginState) {
        switch state {
        case .initial:
            backgroundImageView.alpha = 1.0
        case .waiting, .invalidEmail, .ready:
            backgroundImageView.alpha = 0.0
        }
    }
    
    private func updateBlurredBackground(with state: LoginState) {
        switch state {
        case .initial:
            blurredBackgroundImageView.alpha = 0.0
        case .waiting, .invalidEmail, .ready:
            blurredBackgroundImageView.alpha = 1.0
        }
    }
    
    private func updateSignInLabel(with state: LoginState) {
        titleVerticalConstraint?.deactivate()
        
        switch state {
        case .initial:
            signInLabel.alpha = 0.0
            
            signInLabel.snp.makeConstraints({ (make) in
                titleVerticalConstraint = make.bottom.equalTo(view.snp.top).constraint
            })
        case .waiting, .invalidEmail, .ready:
            signInLabel.alpha = 1.0
            
            signInLabel.snp.makeConstraints({ (make) in
                titleVerticalConstraint = make.top.equalTo(view.snp.bottom).multipliedBy(Config.topMarginMultiplier).constraint
            })
        }
    }
    
    private func updateEmailField(with state: LoginState) {
        emailVerticalConstraint?.deactivate()
        
        switch state {
        case .initial:
            emailTextField.alpha = 0.0
            
            emailTextField.snp.makeConstraints({ (make) in
                emailVerticalConstraint = make.top.equalTo(view.snp.centerY).constraint
            })
        case .waiting, .invalidEmail, .ready:
            emailTextField.alpha = 1.0
            
            emailTextField.snp.makeConstraints({ (make) in
                emailVerticalConstraint = make.top.equalTo(view.snp.bottom).multipliedBy(Config.emailVerticalMultiplier).constraint
            })
        }
    }
    
    private func updatePasswordField(with state: LoginState) {
        switch state {
        case .initial:
            passwordTextField.alpha = 0.0
        case .waiting, .invalidEmail, .ready:
            passwordTextField.alpha = 1.0
        }
    }
    
    private func updateInvalidEmailLabel(with state: LoginState) {
        invalidEmailVerticalConstraint?.deactivate()
        
        switch state {
        case .initial, .waiting, .ready:
            invalidEmailLabel.alpha = 0.0
            
            invalidEmailLabel.snp.makeConstraints({ (make) in
                invalidEmailVerticalConstraint = make.bottom.equalTo(emailTextField).constraint
            })
        case .invalidEmail:
            invalidEmailLabel.alpha = 1.0
            
            invalidEmailLabel.snp.makeConstraints({ (make) in
                invalidEmailVerticalConstraint = make.top.equalTo(emailTextField.snp.bottom).constraint
            })
        }
    }
    
    private func updateSignInButton(with state: LoginState) {
        switch state {
        case .initial:
            signInButton.alpha = 0.0
            
            signInButtonVerticalConstraint?.deactivate()
            signInButtonWidthConstraint?.deactivate()
            signInButton.snp.makeConstraints({ (make) in
                signInButtonVerticalConstraint =  make.top.equalTo(view.snp.bottom).constraint
                signInButtonWidthConstraint = make.width.equalTo(Config.itemHeight).constraint
            })
        case .waiting, .invalidEmail:
            signInButton.alpha = 1.0
            signInButton.titleLabel?.alpha = 0.0
            
            signInButtonVerticalConstraint?.deactivate()
            signInButtonWidthConstraint?.deactivate()
            signInButton.snp.makeConstraints({ (make) in
                signInButtonVerticalConstraint =  make.centerY.equalToSuperview().constraint
                signInButtonWidthConstraint = make.width.equalTo(Config.itemHeight).constraint
            })
            
        case .ready:
            signInButton.alpha = 1.0
            signInButton.titleLabel?.alpha = 1.0
            
            signInButtonWidthConstraint?.deactivate()
            signInButton.snp.makeConstraints({ (make) in
                signInButtonWidthConstraint = make.width.equalToSuperview().multipliedBy(Config.widthMultiplier).constraint
            })
        }
    }
    
    // MARK: Action methods
    
    func textFieldDidChange(_ textField: UITextField) {
        informationDidchange()
    }
    
    // MARK: Auxiliary methods
    
    private func animateTransition(to state: LoginState, duration: TimeInterval = Config.animationDuration, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        let animations = { [weak self] in
            self?.state = state
            self?.view.layoutIfNeeded()
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseInOut,
                       animations: animations,
                       completion: completion)
    }
    
    fileprivate func informationDidchange() {
        if !isValidEmail {
            animateTransition(to: .invalidEmail)
        }
        else if isValidPassword {
            animateTransition(to: .ready)
        }
        else {
            animateTransition(to: .waiting)
        }
    }
}

// MARK: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        informationDidchange()
    }
}

