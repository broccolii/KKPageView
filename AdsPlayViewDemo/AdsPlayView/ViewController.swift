//
//  ViewController.swift
//  AdsPlayView
//
//  Created by Broccoli on 15/11/16.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

// http://fromwiz.com/share/s/0i4C850y0AUf2VM_1t15ktzt1-Z1cg3gmA4X2nmNrx34IKKk

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200)
        
        let url1 = NSURL(string: "http://img3.douban.com/view/status/median/public/70479fc48e015ee.jpg")!
        let url2 = NSURL(string: "http://img3.douban.com/view/status/median/public/198a1ad399063b1.jpg")!
        let url3 = NSURL(string: "http://img4.douban.com/view/status/median/public/a4292c8f3353deb.jpg")!
        let url4 = NSURL(string: "http://img4.douban.com/view/status/median/public/703f430b2045367.jpg")!
        
        let playView = AdsPlayView(frame: rect, placeholderImage: UIImage(named: "placeholder")!, URLArr: [url1, url2, url3, url4])
//        playView.switchInterval = 2.0
        // block
//        playView.didSelectItemAtIndexBlock = {
//            (index) -> Void in
//            debugPrint(index.row)
//        }
        
        playView.delegate = self
        view.addSubview(playView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: AdsPlayViewDelegate {
    func adsPlayView(AdsPlayView: UIView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        debugPrint("indexPath: \(indexPath)")
    }
}