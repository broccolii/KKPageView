//
//  AdsPlayView.swift
//  AdsPlayView
//
//  Created by Broccoli on 15/11/16.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit
import Kingfisher

protocol AdsPlayViewDelegate {
    func adsPlayView(AdsPlayView: UIView, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

class AdsPlayView: UIView {
    
    /// 轮播间隔时间 默认是 5 秒
    var switchInterval: Double! {
        set {
            switchTimer = NSTimer.scheduledTimerWithTimeInterval(newValue, target: self, selector: Selector("beganSwitchAnimation"), userInfo: nil, repeats: true)
            switchTimer.fireDate = NSDate(timeIntervalSinceNow: newValue)
        }

        get {
         return nil
        }
    }
    
    private lazy var collectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = self.frame.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        collection.pagingEnabled = true
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdenifier)
        collection.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.imgURLArr.count
        pageControl.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 10)
        pageControl.center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height - 20)
        return pageControl
    }()
    
    
    /// 图片 URL 数组
    var imgURLArr: [NSURL]!
    /// placeholder image
    var placeholderImage: UIImage!
    /// 滚动 时间间隔
    private var switchTimer: NSTimer!
    /// 一个 当前图片 的变量 用于 计算 collectionView 的偏移
    private var dataCurrentIndex = 0
    /// pageControl 的 currentPage
    private var pageControlCurrent: Int!
    /// 点击事件的 回调
    // block
    var didSelectItemAtIndexBlock: ((NSIndexPath) -> Void)!
    // delegate
    var delegate: AdsPlayViewDelegate!
    
    // MARK: - init
    init(frame: CGRect, placeholderImage: UIImage, URLArr: [NSURL]) {
        super.init(frame: frame)
        self.imgURLArr = URLArr
        addSubview(collectionView)
        insertSubview(pageControl, aboveSubview: self.collectionView)
        self.placeholderImage = placeholderImage
        self.switchInterval = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 页面 滚动
extension AdsPlayView {
    private func correctCollectionViewOffset(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.bounds.width - 1
        
        if offset != 0 {
            dataCurrentIndex = (dataCurrentIndex + Int(offset) + imgURLArr.count) + imgURLArr.count
            let indexPath = NSIndexPath(forItem: 1, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
            
            UIView.setAnimationsEnabled(false)
            collectionView.reloadItemsAtIndexPaths([indexPath])
            UIView.setAnimationsEnabled(true)
            
            pageControl.currentPage = pageControlCurrent
        }
    }
    
    @objc private func beganSwitchAnimation() {
        let indexPath = NSIndexPath(forItem: 2, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
    }
}

private let CellIdenifier = "AsdPalyViewCell"
// MARK: - UICollectionViewDataSource
extension AdsPlayView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdenifier, forIndexPath: indexPath)
        let url = imgURLArr[(indexPath.row - 1 + imgURLArr.count + dataCurrentIndex) % imgURLArr.count]
        pageControlCurrent = (indexPath.row - 1 + imgURLArr.count + dataCurrentIndex) % imgURLArr.count
        
        let imgView = UIImageView(frame: bounds)
        imgView.kf_setImageWithURL(url, placeholderImage: placeholderImage)
        cell.addSubview(imgView)
        imgView.contentMode = UIViewContentMode.ScaleAspectFill
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AdsPlayView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let _ = switchTimer {
            switchTimer.fireDate = NSDate.distantFuture()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let _ = switchTimer {
            switchTimer.fireDate = NSDate(timeIntervalSinceNow: switchTimer.timeInterval)
        }
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
       correctCollectionViewOffset(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        correctCollectionViewOffset(scrollView)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let block = didSelectItemAtIndexBlock {
            block(NSIndexPath(forItem: pageControlCurrent, inSection: 0))
        }
        
        if let delegate = delegate {
            delegate.adsPlayView(self, didSelectItemAtIndexPath: NSIndexPath(forItem: pageControlCurrent, inSection: 0))
        }
    }
}


