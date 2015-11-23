
## AdsPlayView
 一个基于 `UICollecionView` 实现的轮播图控件
## Features

* 图片网络下载是基于 [喵神](https://github.com/onevcat) 写的 [kingfisher](https://github.com/onevcat/Kingfisher)
* 轮播控件使用了 `UICollectionView` [无限滚动原理](http://fromwiz.com/share/s/0i4C850y0AUf2VM_1t15ktzt1-Z1cg3gmA4X2nmNrx34IKKk) (感谢 yy1451391073@163.com 分享的笔记) 

## Requirements

* iOS 8.0+
* Xcode 7.0 or above

## CocoaPods

```
use_frameworks!
pod 'AdsPlayView', '~> 1.0.0'
```

## Usage

###init


``` swift	
						
let playView = AdsPlayView(frame: rect, placeholderImage: UIImage(named: "placeholder")!, URLArr: [url1, url2, url3, url4])
view.addSubview(playView)
        
```

### Callbacks

你可以自定义选择回调的方式:

#### block
``` swift
 // block
 playView.didSelectItemAtIndexBlock = {
    (index) -> Void in
    debugPrint(index.row)
 }

```
#### delegate
``` swift
extension ViewController: AdsPlayViewDelegate {
    func adsPlayView(AdsPlayView: UIView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        debugPrint("indexPath: \(indexPath)")
    }
}
```

## Contact

我的邮箱: broccoliii@163.com

## License

the MIT license. 
