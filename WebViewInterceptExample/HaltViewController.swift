//
//  HaltViewController.swift
//  WebViewInterceptExample
//
//  Created by Kevin Yu on 10/10/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import UIKit

class HaltViewController: UIViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
