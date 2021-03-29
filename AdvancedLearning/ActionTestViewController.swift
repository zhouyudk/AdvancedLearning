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
//        gesture.delaysTouchesBegan = true
        view.addGestureRecognizer(gesture)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(action:)))
        longPress.minimumPressDuration = 2
        longPress.delaysTouchesBegan = true
//        view.addGestureRecognizer(longPress)
        //        label.addGestureRecognizer(gesture)
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 250, width: 200, height: 20)
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.addGestureRecognizer(gesture)
//        button.addGestureRecognizer(longPress)
        button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
        view.addSubview(button)

        let myButton = MyButton()
        myButton.frame = CGRect(x: 150, y: 280, width: 200, height: 20)
        myButton.backgroundColor = .black
//        myButton.addGestureRecognizer(gesture)
        myButton.addTarget(self, action: #selector(onMyButtonClicked), for: .touchUpInside)
        view.addSubview(myButton)


    }

    @objc func gestureHandler() {
         print("Gesture 触发")
     }
    // 长按手势 会在begin和end时触发 selector，长按到时间满足触发begin，手指抬起后触发end, 所以需要判断 状态为begin时处理事件
    @objc func longPressGestureHandler(action: UILongPressGestureRecognizer) {
        if action.state == UIGestureRecognizer.State.began {
            print("longPressGestureHandler 开始触发")
        }
        print("longPressGestureHandler 触发 \(action.state.rawValue)")
    }

    // button上添加手势，会触发手势而不会触发button的action
    // 如果父视图添加了手势，点击button 还是触发button的action
    @objc func onButtonClicked() {
         print("Button 点击")
     }
    // 如果父视图添加了手势，点击自定义的继承与UIControl的mybutton 触发父视图的手势
    @objc func onMyButtonClicked() {
        print("myButton 点击")
    }

    // 默认情况 gesture.delaysTouchesBegan 为false gesture.delaysTouchesEnd为true
    // view的手势和 touchBegan会同时触发， touchBegan会在手指接触屏幕后立即触发，而手势需要达到一定的条件才能触发
    // touchBegan会优先与手势响应

    // 如果 gesture.delaysTouchesBegan为 true 则标识touch会先判断手势是否触发，如果未触发则 继续触发touch，如果已触发则不再触发touchBegin
    // gesture.delaysTouchesEnd同理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Began")
    }

    // 如果view上有手势，但是手势未满足触发条件(比如长按) 则会触发touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Ended")
    }
}

class MyButton: UIControl {

}

// 手势一旦触发就不会再触发其他 UIControl的事件和UITouch
