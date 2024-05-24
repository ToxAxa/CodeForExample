//
//  LandingBuilder.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

enum LandingBuilder {
    
    static func build() -> UIViewController {

        let storyboard = Storyboards.landing.instance
        let view = LandingViewController.instantiate(from: storyboard)

        return view
    }
}
