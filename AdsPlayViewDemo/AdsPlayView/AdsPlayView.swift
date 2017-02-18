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
    func adsPlayView(_ AdsPlayView: UIView, didSelectItemAtIndexPath indexPath: IndexPath)
}

class AdsPlayView: UIView {
    
    /// 轮播间隔时间 默认是 5 秒
    var switchInterval: Double! {
        set {
            switchTimer = Timer.scheduledTimer(timeInterval: newValue, target: self, selector: #selector(AdsPlayView.beganSwitchAnimation), userInfo: nil, repeats: true)
            switchTimer.fireDate = Date(timeIntervalSinceNow: newValue)
        }

        get {
         return nil
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView! = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = self.frame.size
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdenifier)
        collection.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
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
    var imgURLArr: [URL]!
    /// placeholder image
    var placeholderImage: UIImage!
    /// 滚动 时间间隔
    fileprivate var switchTimer: Timer!
    /// 一个 当前图片 的变量 用于 计算 collectionView 的偏移
    fileprivate var dataCurrentIndex = 0
    /// pageControl 的 currentPage
    fileprivate var pageControlCurrent: Int!
    /// 点击事件的 回调
    // block
    var didSelectItemAtIndexBlock: ((IndexPath) -> Void)!
    // delegate
    var delegate: AdsPlayViewDelegate!
    
    // MARK: - init
    init(frame: CGRect, placeholderImage: UIImage, URLArr: [URL]) {
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
    fileprivate func correctCollectionViewOffset(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.bounds.width - 1
        
        if offset != 0 {
            dataCurrentIndex = (dataCurrentIndex + Int(offset) + imgURLArr.count) + imgURLArr.count
            let indexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            
            UIView.setAnimationsEnabled(false)
            collectionView.reloadItems(at: [indexPath])
            UIView.setAnimationsEnabled(true)
            
            pageControl.currentPage = pageControlCurrent
        }
    }
    
    @objc fileprivate func beganSwitchAnimation() {
        let indexPath = IndexPath(item: 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
}

private let CellIdenifier = "AsdPalyViewCell"
// MARK: - UICollectionViewDataSource
extension AdsPlayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdenifier, for: indexPath)
        let url = imgURLArr[(indexPath.row - 1 + imgURLArr.count + dataCurrentIndex) % imgURLArr.count]
        pageControlCurrent = (indexPath.row - 1 + imgURLArr.count + dataCurrentIndex) % imgURLArr.count
        
        let imgView = UIImageView(frame: bounds)
        imgView.kf_setImageWithURL(url, placeholderImage: placeholderImage)
        cell.addSubview(imgView)
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AdsPlayView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let _ = switchTimer {
            switchTimer.fireDate = Date.distantFuture
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let _ = switchTimer {
            switchTimer.fireDate = Date(timeIntervalSinceNow: switchTimer.timeInterval)
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
       correctCollectionViewOffset(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        correctCollectionViewOffset(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = didSelectItemAtIndexBlock {
            block(IndexPath(item: pageControlCurrent, section: 0))
        }
        
        if let delegate = delegate {
            delegate.adsPlayView(self, didSelectItemAtIndexPath: IndexPath(item: pageControlCurrent, section: 0))
        }
    }
}


