//
//  Scripts.swift
//  WebViewInterceptExample
//
//  Created by K Y on 12/17/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

private let imgSrc = "https://raw.githubusercontent.com/1985wasagoodyear/WebViewInterceptExample/master/WebViewInterceptExample/smrtDog.jpeg"

enum Scripts {
    /// JavaScript to transform all img-elements into pictures of our dog
    static let doggify = """
var images = document.getElementsByTagName('img');
for (var i = 0; i < images.length; i++) {
images[i].src = "\(imgSrc)";
}
"""
}
