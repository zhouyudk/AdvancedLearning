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

        let coverView = UIView(frame: CGRect(x: 150, y: 250, width: 200, height: 20))
        coverView.backgroundColor = .green
        coverView.isUserInteractionEnabled = false
        view.addSubview(coverView)

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
    // 递归调用
    //- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event;   // recursively calls -pointInside:withEvent:. point is in the receiver's coordinate system


    //- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;   // default returns YES if point is in bounds
}

// 手势一旦触发就不会再触发其他 UIControl的事件和UITouch

/*
 系统通过 IOKit.framework来处理硬件操作，其中屏幕处理也通过IOKit完成(IOKit可能是注册监听了屏幕输出的端口)
 当用户操作屏幕，IOKit收到屏幕操作，会将这次操作封装为IOHIDEvent对象。通过mach port(IPC进程间通信)将事件转发给SpringBoard来处理。
 SpringBoard是iOS系统的桌面程序。SpringBoard收到mach port发过来的事件，唤醒main runloop来处理。
 main runloop将事件交给source1处理，source1会调用__IOHIDEventSystemClientQueueCallback()函数。
 函数内部会判断，是否有程序在前台显示，如果有则通过mach port将IOHIDEvent事件转发给这个程序。
 如果前台没有程序在显示，则表明SpringBoard的桌面程序在前台显示，也就是用户在桌面进行了操作。
 __IOHIDEventSystemClientQueueCallback()函数会将事件交给source0处理，source0会调用__UIApplicationHandleEventQueue()函数，函数内部会做具体的处理操作。
 例如用户点击了某个应用程序的icon，会将这个程序启动。
 应用程序接收到SpringBoard传来的消息，会唤醒main runloop并将这个消息交给source1处理，source1调用__IOHIDEventSystemClientQueueCallback()函数，在函数内部会将事件交给source0处理，并调用source0的__UIApplicationHandleEventQueue()函数。
 在__UIApplicationHandleEventQueue()函数中，会将传递过来的IOHIDEvent转换为UIEvent对象。
 在函数内部，将事件放入UIApplication的事件队列，等到处理该事件时，将该事件出队列，UIApplication将事件传递给窗口对象(UIWindow)，如果存在多个窗口，则从后往前询问最上层显示的窗口
 窗口UIWindow通过hitTest和pointInside操作，判断是否可以响应事件，如果窗口UIWindow不能响应事件，则将事件传递给其他窗口；若窗口能响应事件，则从后往前询问窗口的子视图。
 以此类推，如果当前视图不能响应事件，则将事件传递给同级的上一个子视图；如果能响应，就从后往前遍历当前视图的子视图。
 如果当前视图的子视图都不能响应事件，则当前视图就是第一响应者。
 找到第一响应者，事件的传递的响应链也就确定的。
 如果第一响应者非UIControl子类且响应链上也没有绑定手势识别器UIGestureRecognizer;
 那么由于第一响应者具有处理事件的最高优先级，因此UIApplication会先将事件传递给它供其处理。首先，UIApplication将事件通过 sendEvent: 传递给事件所属的window，window同样通过 sendEvent: 再将事件传递给hit-tested view，即第一响应者,第一响应者具有对事件的完全处理权，默认对事件不进行处理，传递给下一个响应者(nextResponder)；如果响应链上的对象一直没有处理该事件，则最后会交给UIApplication，如果UIApplication实现代理，会交给UIApplicationDelegate，如果UIApplicationDelegate没处理，则该事件会被丢弃。
 如果第一响应者非UIControl子类但响应链上也绑定了手势识别器UIGestureRecognizer;
 UIWindow会将事件先发送给响应链上绑定的手势识别器UIGestureRecognizer，再发送给第一响应者，如果手势识别器能成功识别事件，UIApplication默认会向第一响应者发送cancel响应事件的命令;如果手势识别器未能识别手势，而此时触摸并未结束，则停止向手势识别器发送事件，仅向第一响应者发送事件。如果手势识别器未能识别手势，且此时触摸已经结束，则向第一响应者发送end状态的touch事件，以停止对事件的响应。
 如果第一响应者是自定义的UIControl的子类同时响应链上也绑定了手势识别器UIGestureRecognizer;这种情况跟第一响应者非UIControl子类但响应链上也绑定了手势识别器UIGestureRecognizer`处理逻辑一样;
 //如果第一响应者是UIControl的子类且是系统类(UIButton、UISwitch)同时响应链上也绑定了手势识别器UIGestureRecognizer;
 //UIWindow会将事件先发送给响应链上绑定的手势识别器UIGestureRecognizer，再发送给第一响应者，如果第一响应者能响应事件，UIControl调用调用sendAction:to:forEvent:将target、action以及event对象发送给UIApplication，UIApplication对象再通过 sendAction:to:from:forEvent:向target发送action。()
 */



//个人总结

//hitTest 寻找当前view中的能响应事件且点击point在其中的subView。如果未找到 就i返回自己
//寻找subView按 后添加 先判断的顺序，也就是覆盖在上面的先判断。如果覆盖的view不具备响应事件的能力，比如hide，isUserInteractionEnabled = false, 被覆盖住的view如果point在其上 也会响应事件

//对于点击事件 hook 以下方法 处理全局的点击事件
//UIApplication().sendAction(<#T##action: Selector##Selector#>, to: <#T##Any?#>, from: <#T##Any?#>, for: <#T##UIEvent?#>)
// to 为target，  addTarget时指定的target.
// from 为 发送action的对象 如button等
//https://manual.sensorsdata.cn/sa/latest/tech_sdk_client_ios-1573910.html
//https://gerald8.github.io/2020-01-16/iOS-%E9%9D%9E%E4%BE%B5%E5%85%A5%E5%BC%8F%E5%9F%8B%E7%82%B9%E6%96%B9%E6%A1%88
