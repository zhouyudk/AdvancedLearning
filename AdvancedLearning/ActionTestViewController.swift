//
//  ActionTestViewController.swift
//  AdvancedLearning
//
//  Created by yu zhou on 2021/3/26.
//

import UIKit


/// UITouch、UIControl、UIGestureRecognizer事件传递机制，优先级
class ActionTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.isUserInteractionEnabled = true

        view.addSubview(label)
        self.view = view

        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        //        label.addGestureRecognizer(gesture)
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 250, width: 200, height: 20)
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.addGestureRecognizer(gesture)
        button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
        view.addSubview(button)

        let myButton = MyButton()
        myButton.frame = CGRect(x: 150, y: 280, width: 200, height: 20)
        myButton.backgroundColor = .black
        myButton.addGestureRecognizer(gesture)
        myButton.addTarget(self, action: #selector(onMyButtonClicked), for: .touchUpInside)
        view.addSubview(myButton)


    }

    @objc func gestureHandler() {
         print("Gesture 触发")
     }

     @objc func onButtonClicked() {
         print("Button 点击")
     }

    @objc func onMyButtonClicked() {
        print("myButton 点击")
    }
}

class MyButton: UIControl {

}
