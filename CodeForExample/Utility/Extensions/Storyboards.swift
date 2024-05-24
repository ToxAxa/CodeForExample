//
//  Storyboards.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation

import UIKit

enum Storyboards {
    case landing
    
    var instance: UIStoryboard {
        
        switch self {
        case .landing:
            return UIStoryboard.init(name: "Landing", bundle: nil)
        }
    }
}
