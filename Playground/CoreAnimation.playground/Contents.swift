//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


class MyViewController : UIViewController {
    var sublayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        return layer
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view

        view.layer.addSublayer(sublayer)

        let button = UIButton()
        button.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
        view.addSubview(button)
    }

    //触发隐式动画
    //当一个layer 没有设置view作为delegate时，修改其color frame等属性会触发隐式动画
    @objc func onButtonClicked() {
           sublayer.backgroundColor = UIColor.black.cgColor
           sublayer.frame = CGRect(x: 150, y: 50, width: 100, height: 100)
       }
    //就职责而言，UIView负责处理事件响应，Layer负责界面的绘制
    //加入想为一个没有设置View作为代理的Layer添加点击时间，同一通过其
    func testLayerClick() {
        sublayer.hitTest(<#T##p: CGPoint##CGPoint#>)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
