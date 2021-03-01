import UIKit

//GCD
//线程安全
//当在多个线程中修改同一个变量时需要注意

//多线程安全
func test() {
    var testArray = [Int]()
    var i = 0
    let queue = DispatchQueue(label: "并发", attributes: .concurrent)
    for j in 0...100 {
        queue.async { //全局队列+异步执行
            sleep(arc4random()%3)
            i = j
            testArray.append(i)
            print(i,j, Thread.current)//i 和 j 可能不同
        }
    }
    print(testArray.count)// 小于10的随机数
}
//test()

//可以保证线程安全
func testBarrirer()  {
    var testArray = [Int]()
    var i = 0
    let b = DispatchQueue.global()//(label: "并发", attributes: .concurrent)//使用global和自定的并发队列 结果不同 疑问
    for j in 0...10 {
        b.async { //全局队列+异步执行
            sleep(arc4random()%3)
            testArray.append(i)
            i = j
            print(i,j, Thread.current) //i和j是相同的
        }
        b.async(flags: .barrier) {

        }
    }
    b.async {
        print(testArray.count)
    }

}
testBarrirer()

//使用信号量 相当于把异步改为了同步
func testSemaphore() {
    var testArray = [Int]()
    var i = 0
    let semaphore = DispatchSemaphore(value: 1)
    for j in 0...100 {
        DispatchQueue.global().async { //全局队列+异步执行
            semaphore.wait()
            sleep(arc4random()%3)
            i = j
            testArray.append(i)
            print(i,j, Thread.current)
            semaphore.signal()
        }
    }
    print(testArray.count)
}

//testSemaphore()



/*: 如果在 for 中使用DispatchQueue初始化，会创建多个串行队列，导致任务并发执行

 */
func testSerialQueue() {
    let serial = DispatchQueue(label: "dfadsf", attributes: .init(rawValue: 0))
    for j in 0...10 {
        serial.async {
            sleep(arc4random()%3)
            print(j,Thread.current)
        }
    }
}


//Operation
