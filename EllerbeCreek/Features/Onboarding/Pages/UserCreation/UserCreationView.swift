//
//  UserCreationView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import GameKit

class UserCreationView: NibBasedView {
    
    public weak var delegate: OnboardingViewDelegate?
    
    @IBOutlet var subHeaderLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(24.0)
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var headerLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(48.0)
                label.textColor = Colors.darkGreen
            }
        }
    }
    
    @IBOutlet var gameCenterButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "GameCenter"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var gameCenterDescriptionLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.adjustsFontSizeToFitWidth = true
                label.font = Fonts.regular.withSize(16.0)
                label.numberOfLines = 0
                label.text = "Enabling Game Center allows your game activity to be saved and synced across your other devices."
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var customButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Custom"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        commonInit()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
           
        commonInit()
    }
    
    private func commonInit() {
    
    }
    
    @IBAction func gameCenterAction() {
        GameCenterManager.shared.authenticate {
            guard let delegate = self.delegate else { return }
            delegate.triggerScrollToNextSlide()
        }
    }
    
}
