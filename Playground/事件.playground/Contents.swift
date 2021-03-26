//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//http://www.cocoachina.com/articles/26383
class MyViewController : UIViewController {
    let logLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 300, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        return label
    }()
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.isUserInteractionEnabled = true
        
        view.addSubview(label)
        view.addSubview(logLabel)
        self.view = view

        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
//        label.addGestureRecognizer(gesture)
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 250, width: 200, height: 20)
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addGestureRecognizer(gesture)
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc func gestureHandler() {
        print("Gesture 触发")
        logLabel.text = "Gesture 触发"
    }

    @objc func onButtonClick() {
        print("Button 点击")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

class MyButton: UIControl {

}

