//
//  Window.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

protocol WindowPresentation {
}

class Window: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
