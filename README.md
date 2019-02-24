
## KKPageView
A carousel view control based `UICollectionView`

## Requirements

* iOS 8.0+
* Xcode 7.0 or above

## CocoaPods

```
use_frameworks!
pod 'AdsPlayView', '~> 1.0.0'
```

## Usage

### init


``` swift	
						
let playView = AdsPlayView(frame: rect, placeholderImage: UIImage(named: "placeholder")!, URLArr: [url1, url2, url3, url4])
view.addSubview(playView)
        
```

### Callbacks


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

Mail : broccoliii@163.com

## License

the MIT license. 
