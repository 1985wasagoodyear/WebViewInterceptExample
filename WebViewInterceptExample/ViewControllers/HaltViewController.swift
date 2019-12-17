//
//  HaltViewController.swift
//  WebViewInterceptExample
//
//  Created by Kevin Yu on 10/10/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

final class HaltViewController: UIViewController {

    // tapping anywhere returns user to previous VC.
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        dismiss(animated: true,
                completion: nil)
    }

}
