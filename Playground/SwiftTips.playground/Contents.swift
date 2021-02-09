//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//: Swift 开发必备Tips
/*:
 1 柯里化
在构造一个函数的时候，应该尽量减少入参个数，最好只带一个入参
*/

/*:
 2 Sequence  序列
实现了该协议的对象都能通过for in进行迭代遍历，
而实现Sequence 需要 重写makeIterator方法，也就是迭代器，而生成迭代器需要实现IteratorProtocol, 实现next方法 。
map filter reduce是对Sequence的协议扩展
*/

//: 以下实现一个反向迭代器
class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T

    var array: [Element]
    var currentIndex = 0

    init(_ array: [Element]) {
        self.array = array
        currentIndex = array.count-1
    }

    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        } else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}

struct ReverseSequence<T>: Sequence {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }

    typealias Iterator = ReverseIterator<T>

    func makeIterator() -> Iterator {
        return ReverseIterator(self.array)
    }
}

let rs = ReverseSequence(array: [1,2,3])
for x in rs {
    print("自定义序列和迭代器：\(x)") // outPut 3 2 1
}

/*:
 3 元组
经典用法 通过(a,b) = (b,a) 交换连个变量的值
也经常用户函数需要传递多个值 而不想单独定义一个数据对象时
*/

/*:
 4 @autoclosure 自动闭包
用于修饰方法的闭包参数，
当函数以闭包作为参数时，理想情况下可简写为funcA{ xx },
而如果用@autoclosure修饰闭包参数类型，则可以简写为funcA(xx),
常用的?? && || 都用到了@autoclosure，以保证操作符左侧的结果不可用时 才会执行右侧的自动闭包
 */

func ??<T>(optional: T?, defaultValue: @autoclosure ()->T) -> T {
    switch optional {
        case .some(let value): return value
        case .none: return defaultValue()
    }
}
//可选类型其实也是一个枚举, 也有对应map filter flatMap等方法
enum MyOptional<T> {
    case some(T)
    case none
}

/*:
 5 @escaping 逃逸闭包
 当方法的参数为闭包， 且不能保证在函数结束 return 前，该闭包能执行，则需要使用@escaping 修饰该闭包类型
*/
//: 默认闭包参数为 非逃逸闭包
func doWork(_ block: () -> ()) {
    block()
}

//: 异步执行block, 如果不加@escaping 编译错误  Escaping closure captures non-escaping parameter 'block'
func doWorkAsync(block: @escaping () -> ()) {
    DispatchQueue.main.async {
        block()
    }
}
//: 传递闭包参数 不一定需要添加@escaping , 只要保证在方法return之前 block能被执行则为非逃逸闭包
func doAnotherWork(block: () -> ()) {
    doWork(block)
}

/*:
 6 Optional Chaining 可选链
 使用可选链 使swift在进链式调用时更加安全，避免出现空异常。
 但是 多级可选链调用 会导致执行是否成功无法判断
*/

class Pet {
    func play() {

    }
}

class Child {
    var pet: Pet?
}
let playClosure = {(child :Child) -> () in child.pet?.play()}
playClosure(Child()) //无法获取执行结果
//修改playClosure方法
let playClosureN = {(child :Child) -> ()? in child.pet?.play()}
if let _ = playClosureN(Child()) {
    print("played")
} else {
    print("do not play")
}

/*:
 7 操作符
 swift支持操作符的重载，意味着可以为自定义的类型等 实现 + - 等等操作符, 也可以定义新操作符
 自定义新操作符时，需要定义操作符类型 prefix: +A、 infix: A+B、postfix: A+，优先级
 */
struct Vector2D {
    var x = 0.0
    var y = 0.0
}
func +(left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x+right.x, y: left.y+right.y)
}
print("操作符: \(Vector2D(x: 1,y: 2) + Vector2D(x: 2,y: 5))")

//定义一个矢量运算符

infix operator +* : MultiplicationPrecedence
func +*(left: Vector2D, right: Vector2D) -> Double {
     return left.x*right.x + left.y*right.y
}
/*:
 8 func的参数修饰
 在swift中func的参数都是默认不可变的，也就是在函数体内不可以修改
 使用inout 修饰符，swift中Int为值类型，不能直接取地址，而&符号的作用是在函数内创建了一个新的变量，然后在函数返回时，将新的值赋值给 &修饰的变量。与引用类型的& 不同
 */
//
func incrementor(v: inout Int) {
    v += 1
}
var para = 1
incrementor(v: &para)
print("func的参数修饰： \(para)") //输出2

/*:
 9 字面量表达
 通过赋值的方式, 将值表达为指定的类型。
 */
let anArray = [1, 2, 3]
class Person: ExpressibleByStringLiteral {
    let name: String
    init(name value: String) {
        self.name = value
    }

    required convenience init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}
let p: Person = "xiaoming"
print("字面量表达： \(p.name)")

/*:
 10 下标
 下标脚本，如Array Map的[]，其实时调用了subscript方法，只有一个入参和返回值，如果有多个参数和返回值则 应该使用Array类型入参和 ArraySlice作为返回值
 */
extension Array {
    public subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        set {
            for (index, i) in input.enumerated() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
var arr = [1,2,3,4,5]
arr[[0,2,3]]
arr[[0,2,3]] = [6,7,8]
//此方法仅用于举例，在实际应用中 应该定义一个可变长参数列表的方法实现该功能
//ArraySlice  Slice
//ArraySlice 为原数组的切片，不会copy原数组，而是直接使用原Array的内容进行操作

/*:
 11 方法嵌套
 swift中方法为一等公民，可以将方法作为变量和函数的参数，还可以作为函数的返回值. 函数式编程的核心.
 */
    //如需实现一个参数大于0则加1 小于0则减1的方法
func operation(v: Int) -> Int {
    if v >= 0 {
        return v+1
    } else {
        return v-1
    }
}

//重写如下
func operation(v: Int, block: (Int)->Int) -> Int {
    return block(v)
}
print(operation(v: 5) { $0 + 1})
//当一个函数的逻辑复杂，或者函数的参数不清晰时，可以将逻辑通过此种方式抛给外部实现
//更多的内容可以阅读函数式编程pdf

/*:
 12 typealias
 类型重命名
 */
typealias Location = CGPoint
typealias Distance = Double
//当泛型嵌套时，可缩短代码并增加可读性
typealias IntArray = Array<Int>
//合并多个协议
protocol DogP {}
protocol CatP {}
typealias PetP = DogP & CatP
class AnimalC: PetP {

}

/*:
13 associatedtype
动态类型，常用于protocol中，需要在实现Protocol时 指定该类型，否则编译无法通过
*/
protocol FoodAsso {

}

protocol AnimalAsso {
    func eat(f: FoodAsso)
}

struct MeatAsso: FoodAsso {

}
struct TigerAsso: AnimalAsso {
    func eat(f: FoodAsso) {
        if let _ = f as? MeatAsso {
            print("eat meat")
        } else {
            fatalError("is not meat")
        }
    }
}
//如果将Tiger中eat方法的food类型修改为Meat 也会报错, 因为eat方法指定接收一个Food类型的参数
//首先想到的是使用泛型，但是swift协议不能使用泛型，于是使用associatedtype
protocol AnimalAssoN {
    associatedtype Food: FoodAsso
    func eat(f: Food)
}

struct MeatAssoN: FoodAsso {

}
struct TigerAssoN: AnimalAssoN {
    func eat(f: MeatAssoN) {
        print("eat meat")
    }
}
// 含有associatedtype 的Protocol 不再能单独使用

/*:
 14 可变参数函数
 函数参数个数可变, 使用...，对于在使用时 需要将参数 以Array使用.
 一个函数只能存在一个 可变参数
 */

func sum(input: Int...) -> Int {
    return input.reduce(0, +)
}
// print方法也是可变参数函数,
print("可变参数函数：", sum(input: 1, 2, 3))

/*:
 15 初始化方法顺序
 子类的init方法中  1 需要先初始化子类自定义的参数 2 调用父类的init方法，3 对父类中需要修改的成员变量进行修改
 */

/*:
15 初始化方法 Designated  Convenience Required

swift 默认的初始化方法为Designated，
 指定构造器。在方法中可以对 let 实例常量进行赋值，因为 init方法只会执行一次
 Convenience 修饰的初始化方法 该方法都必须直接或间接调用同一个类中的Designated初始化方法，且不能被子类重写和以super形式调用
在子类中必须重写了 Convenience 初始化方法调用的Designated初始化方法，才能在子类使用Convenience 初始化方法
 总结： 初始化方法必须保证对象完全初始化（调用Designated 保证） 子类的Designated 初始化方法必须调用父类的Designated
 */

class ClassA {
    let numA: Int
    init(num: Int) {
        numA = num
    }

    required convenience init(bigN: Int) {
        self.init(num: bigN)
    }
}
class ClassB: ClassA {
    let numB: Int
    override init(num: Int) {
        numB = num+1
        super.init(num: num)
    }
}
ClassB(bigN: 100)

/*:
 16 初始化方法返回nil
 默认 初始化方法是不能写return的，而对于可能初始化失败的情况需要使用init？, return 表示初始化失败
 */
class ClassOption {
    let num: Int
    init?(str: String) {
        if let i = Int(str) {
            num = i
        } else {
            return nil//
        }
    }
}

/*:
 17 static 与 class
 static 与 class都是类作用域，
 static修饰的方法 和成员 为静态方法和静态成员，class 修饰的方法为类方法
 唯一的区别为static修饰的 不能在子类重写， class修饰的方法可在子类重写
 */

class ClassC {
    class func test() {

    }
}
class ClassD: ClassC {
    override class func test() {

    }
}

/*:
 18 正则表达式
 正则30分钟入门 http://deerchao.net/tutorials/regex/regex.htm
 常用正则 http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
 */

struct RegexHelper {
    let regex: NSRegularExpression
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }

    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }

}
let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"//邮箱匹配
let matcher: RegexHelper
do {
    matcher = try RegexHelper(mailPattern)
}
let maybeMail = "dfalkdj@qq.com"
if matcher.match(maybeMail) {
    print("邮箱有效")
}
// 定义操作符
precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}
infix operator =~ : MatchPrecedence
func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

/*:
 19 AnyClass 元类型 .self
 在swift中 AnyClass 定义为
 ```
    typealias AnyClass = AnyObject.Type
 ```
 AnyObject.Type 可得到元类型,  A.Type 代表A这个类型的类型。可以声明一个元类型来存储A这个类型本身。而中A中取出类型需要A.self
 */
class ClassF {
    static func test() {

    }
}
let typeF: ClassF.Type = ClassF.self
let typeFF: AnyClass = ClassF.self
typeF.test()
(typeFF as! ClassF.Type).test()

/*:
 20 动态类型与多方法
 swift 默认为编译时就决定方法的调用，所以如果有方法的重载  参数分别为父类和子类，并不会运行时动态根据类型调用对应的方法
 */

class ClsssG {}
class SubClassG: ClsssG {}
func printG(_ c: ClsssG) {
    print("ClassG")
}
func printG(_ c: SubClassG) {
    print("SubClassG")
}

func printGG(_ c: ClsssG) {
    printG(c)
}

printGG(SubClassG())

/*:
 21 属性观察 willSet 与didSet
 set get 与willSet didSet不能同时存在，如果需要为存储属性添加属性观察，可以子类中重写该属性 加上willSet didSet
 */
class ClassH {
    var number: Int {
        get {
            print("get")
            return 1
        }
        set { print("set") }
    }
}

class SubClassH: ClassH {
    override var number: Int {
        willSet { print("willSet") }
        didSet { print("didSet", oldValue) }
    }
}
let h = SubClassH()
h.number = 2
//首先会打印get, 这是因为didSet用到了oldValue，所以需要先get旧值保存。 如果didSet中未使用oldValue则不会调用get

/*:
 22 lazy方法
 在对Array进行筛选 转换，并且有可能提前退出的情况非常有用
 */

let testArray = [1,2,3,4]
let result = testArray.lazy.map { i -> Int in
    print("处理:", i)
    return i*2
}
for i in result {
    if i > 4 {
        break
    }
    print("结果:", i)
}
// 上述代码如果没有使用lazy而是直接调用map，会转换完成后才走for，而lazy后 会在转换3后就结束

/*:
 23 反射与Mirror
 可以在运行时获取swift 中中对象的描述信息，包括属性和类型等。 包括struct swift class或者继承自NSObject的class都能使用mirror。
 通过Mirror可以很方便的实现类似OC中的KVC，通过属性名获取属性的值，但是只能读不能写。
 但是官方建议，只在Debug或者playground中使用Mirror。
 */

struct CheckMirror {
    let strA : String
    let strB: String
}
let cm = CheckMirror(strA: "A", strB: "B")
let r = Mirror(reflecting: cm)
print(r.displayStyle!)
print("属性个数：\(r.children.count)")
for child in r.children {
    print("属性名: \(String(describing: child.label)), 值: \(String(describing: child.value))")
}
dump(cm)//答应对象在运行时的内容信息

/*:
 24 隐式解包 Optional
 在OC中 所有的实际类型都可以指向nil，不过是在参数或者返回值时。比如一个方法要求返回NSString,但是依然可以return nil。因为OC向nil放消息是不会有什么影响的。所以swift使用Cocoa的api时，不知道那些api会返回 nil， 按理来说应该将这些参数或者返回值都定义为Optional，但是对于使用者非常不友好。于是加入了隐式解包。
 在swift中使用隐式解包比较危险，一般只会用在链接 xib中的UI控件。
 */

let testOptional: ClassA! = ClassA(num: 1)
print(testOptional.numA)// 此处testOptional.numA等价于testOptional!.numA

/*:
 25 多重Optional
 当多重Optional变量赋值时，如果不是nil则不管赋值是可选值还是字面量都会进行类型推断转化为多重可选值，
 但是nil是个特例，当nil以可选变量的形式赋值给多重可选变量时，会进行可选层数的抵消，如下的anoNil和anoNil1，
 如果直接将nil赋值给多重可选变量其值直接为nil而非Optional(nil)
 */
var str:String? = "String"
var anoStr:String?? = str

var literalOptional:String?? = "String"

print(anoStr,literalOptional)
print(anoStr!,literalOptional!)
print(anoStr!!,literalOptional!!)
if let a = anoStr,let b = literalOptional {
    print(a,b)
}

var aNil:String?? = nil
var anoNil: String??? = aNil
var anoNil1: String?? = aNil
var literalNil: String?? = nil

print(anoNil,anoNil1,literalNil)

if anoNil != nil {
    print("anoNil")
}
if anoNil1 != nil {
    print("anoNil1")
}
if literalNil != nil {
    print("literalNil")
}

/*:
 26 可选map
 对可选值进行map, 如果不为nil 则返回转换后的值（转换后的值还是optional），如果为nil则返回nil
 */

let num :Int? = nil// 赋值2试试
let result11 = num.map {
    $0*2
}
print("可选map：", result11)

//@propertyWrapper

//@inlinable


print(result)

/*-------------------------------------------------------------------------
  27 Protocol Extension
 协议的扩展对swift带来了巨大变化，swift成为可以面向协议的编程语言
 如果要在swift实现类似OC的协议中的可选方法，必须在protocol前面加上@objc，并在可选方法前加上@objc optional进行修饰，而这种协议只能用于class.
 通过协议扩展可以为协议方法提供默认实现，具体类型中可以选择是否要重写，这也算是从另一个方面实现了方法的可选，并且在调用方法时不用判断func是否实现
 */

@objc protocol AnimalObjc{
   @objc optional func eat()->Void
}
protocol Animal {
    func eat()->Void
}

struct Dog:Animal {
    
}

extension Animal{
    func eat() {
        print("eat")
    }
}
let dog = Dog()
dog.eat()

//扩展中添加protocol中未定义的方法
extension Animal {
    func run() {
        print("run")
    }
}
let dog2 = Dog()
dog2.run()
//然后有一种很有意思的情况,注意下面的run方法，这是在协议的扩展中添加的方法，我们在Cat中重写了eat和run
//let cat = Cat()调用方法得到的结果也和预期相同，但是修改代码为let cat1 = Cat() as Animal后，出现意外了，run方法并没有调用重写的，而是使用的协议扩展中的内容
//这是因为eat在协议中定义了，在实际类型中是必然有这个方法的，这种情况就会进行动态派发，而run在实际类型中并不一定出现，所以在编译期间就决定其类型为Animal从而调用其默认的方法，而不会动态派发
struct Cat: Animal {
    func eat() {
        print("cat eat")
    }
    func run() {
        print("cat run")
    }
}
let cat = Cat()
cat.eat()
cat.run()
let cat1 = Cat() as Animal
cat1.eat()
cat1.run()
let image = UIImageView(image: UIImage(named: "protocolEx"))//协议扩展总结，点击右侧quicklook查看图片
/*:
 28 where 与模式匹配
 在 for  switch case 中都能使用where，以增加条件的筛选
 */
let namesss = ["小二", "张三", "李四"]
namesss.forEach {
    switch $0 {
    case let x where x.hasPrefix("张"):
        print(x)
    default:
        print($0)
    }
}

for x in namesss where x.hasPrefix("张") {
    print(x)
}

/*:
 29 嵌套enum
 使用枚举定义 链表,  嵌套的枚举需要使用 indirect 修饰
 */
indirect enum LinkedList<Element: Comparable> {
    case empty
    case node(Element, LinkedList<Element>)
}
let linkedList = LinkedList.node(1, .node(2, .node(5, .empty)))
func linkedListIterate(ll: LinkedList<Int>) {
    switch ll {
    case .node(let value, let next):
        print("枚举嵌套：", value)
        linkedListIterate(ll: next)
    case .empty:
        print("枚举嵌套：", "链尾")
    }
}

linkedListIterate(ll: linkedList)

/*:
 闭包 值的捕获*/
//方法中的方法在捕获外层的值时，如果在return之前 外层的值变了， 捕获的值会是return前最终的值
func test() -> [(Int)->Void] {
    var j = 0
    func t(i:Int)->Void {

        print(i+j)
    }
    var a:[((Int)->Void)] = []
    for i in 1...5 {
        j = i
        a.append(t)
    }
    return a
}
// 将j移到for的内部，于是j在每次循环结束 生命周期就结束了，于是内部func捕获的值就是每次for中j得到的值
func test11() -> [(Int)->Void] {

    var a:[((Int)->Void)] = []
    for i in 1...5 {
        let j = i
        func t(i:Int)->Void {

            print(i+j)
        }
        a.append(t)
    }
    return a
}

var dd = test11()
dd.forEach { (d) in
    d(0)
}

//一定不要在闭包在 return 的闭包中修改 捕获的变量。 以为每次闭包的执行都会修改捕获的值 ，并影响下一次的执行。
var functionA = { () -> (() -> ()) in
    var a = 0
    return {
        a = a+10
        print("闭包内修改捕获的局部变量：",a)
    }
}

var functionObject = functionA()
functionObject()
functionObject()
//输出 10 和 20

//MARK: Swift 与 OC ---------------------------------------------
/*:
 30 #selector
 作用等价与OC中的@selector，#selector 获取swift中暴露给OC的selector
 */

/*:
 31 实例方法的动态调用
 一般情况下 我们都是使用实例对象 来调用方法，但是还有另一种方式，先获取实例方法 在通过参数传入实例来执行。
 */
class ClassAuto {
    func method(num: Int) -> Int {
        print("ClassAuto")
        return num+1
    }
}

class SubClassAuto: ClassAuto {
    override func method(num: Int) -> Int {
        print("SubClassAuto")
        return num+1
    }
}
let f = ClassAuto.method
f(SubClassAuto())(1)

/*:
 32 weak 与 unowned
 闭包的生命周期 短于 对象的生命周期时才能 使用unowned，否则使用weak，如下情况使用unowned会crash
 */
class PersonA {
    let name = "name"
    lazy var printName: ()->() = {
        [weak self] in
//        print(self.name)
        if let self = self {
            print(self.name)
        }
    }
}

var personA: PersonA? = PersonA()
let pn = personA!.printName
personA = nil
pn()

/*:
 33 Autoreleasepool
 NSData.dataWithContentsOfFile 在swift中已废弃,  该方法会返回已给autorelease对象， 这就需要主自动释放池释放的时候才会释放内存。
 如果在for中调用就会内存暴涨，可以添加局部的自动释放池，以提前释放。
 */
// 当自动释放池的生命周期结束是，其内部的自动释放对象也就释放了，其实在此处NSData使用的是构造器，而不是返回自动释放对象，所以也没有必要使用autoreleasepool
for i in 1...10000 {
    autoreleasepool {
        NSData(contentsOfFile: "")
    }
}

/*:
34  值类型和引用类型
 swift 中 struct enum Array String Int  Bool 等都是值类型。值类型的优势是减少堆内存的分配与释放次数。
 */

func test(_ arr: [Int]) {
    for i in arr {
        print(i)
    }
}
var a = [1,2,3]
var b = a
let c = a
test(a)
//该过程没有任何堆上的内存分配，a, b ,c 在物理上是相同的。只有当值类型的内容发生变化时才会进行值的复制。
b[2] = 10
test(a)
// 输出结果不会变化

class MyObject {
    var num = 100
}
var myObject = MyObject()
var aa = [myObject]
var bb = aa
bb.append(myObject)

myObject.num = 20
print(bb[0].num, bb[1].num, aa[0].num)
bb[1].num = 30
print(bb[0].num, bb[1].num, aa[0].num)
//Array Dic中的在复制时会将其中存储的值类型一并复制，而对于引用类型只是复制一份引用。
//当数据量大 且要频繁的进行增删改， 可以使用NSMutableArray, NSMutableDictionary以提高效率

/*:
  35 String 与 NSString
 String为值类型，不变型在使用时安全方便，但是String 的截取比较麻烦，可以转换为NSString实现
 */

/*:
 36 UnsafePointer
 swift 中使用指针的方式， UnsafeMutablePointer
 */

/*:
 37 GCD 与延时调用
 OC中处理延时调用 一般使用 performSelector withObject afterDelay.
 ios 8以后 可以通过DispatchWorkItem 进行GCD中task的取消
 */
let time: TimeInterval = 2
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
    print("延时2s输出")
}
// 自定义带取消功能的延时方法
typealias Task = (_ cancel: Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now()+time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }

    var closure: (()-> Void)? = task
    var result: Task?
    let delayedClosure: Task = { cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }

    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }

    return result
}

func cancel(_ task: Task?) {
    task?(true)
}
let task = delay(5) {
    print("延时10s")
}
cancel(task)

/*:
 38 使用 is 进行 class struct enum的实例的类型判断  类似iskindOfClass
 */


/*:
 39 KVO 与 keyPath
 kvo是基于kvc和动态派发的，所以swift的class 必须继承自NSObject， 并且被观察的属性加上@objc  dynamic
 */
class MyClassObjc: NSObject {
    @objc dynamic var num = 10
}
class OtherClass: NSObject {
    var myObj: MyClassObjc
    var observation: NSKeyValueObservation?
    override init() {
        myObj = MyClassObjc()
        super.init()
        observation = myObj.observe(\MyClassObjc.num,options: [.new], changeHandler: { (_, change) in
            if let newN = change.newValue {
                print("KVO: \(newN)")
            }
        })

        delay(2) {
            self.myObj.num = 20
        }
    }
}
let other = OtherClass()

/*:
 40 局部scope
 */
do {
    print("test do")
}
//保留引用
let scope: String = {
    return "test"+"scope"
}()

/*:
 41 判等
 OC中一般判断两个对象是否相等，使用isEqual。 oc中使用== 是判断两个对象的指针是否相同
 swift 可以为任意对象 自定义== 操作符，自定义相等的条件.
 swift 中使用===判断引用是否相等
 */

/*:
 42 Options
 在OC调用UIView animat ，富文本定义 等方法时需要传入Options. 这些对应的类型都是使用NS_ENUM, 位移定义的每个枚举项，所以一般使用| 连接。
 在swift中直接使用[], 传入这些参数
 */


/*:
 43 delegate
 对于swift中普通协议，在class中定义协议类型时是无法使用weak修饰的，因为默认协议可以被struct和enum实现。所以一般在定义协议时加上:class，限定协议只能被class实现。
 */
protocol TestProtocol: class {

}
class ProtocolClass {
    weak var delegate: TestProtocol!
}
// 如果不加class 会报weak 错误， 因为struct enum都是值类型  没有ARC

/*:
 44 Associated Object  关联对象
 在OC的category 中是无法直接添加属性的， 因为在代码加载时  class加载后 才会再加载category，再类加载时 参数列表的内存就已经确定，而且不是不可变的。所以category 无法动态添加属性而能加方法。 category添加属性 无法生成var。
通过关联对象可以在category中增加属性 ，但是该属性存储再一个全局的 hash表中，生命周期也和class的生命周期无关。

 swift 中在extension中 默认也只能添加计算属性，因为计算属性是不用存储值，不需要多于的内存。
 而如果要存储值，也只能使用关联对象。
 */
extension MyClassObjc {
    private struct Keys {
        static var titleKey: Void?
    }

    var title : String? {
        get {
            return objc_getAssociatedObject(self, &MyClassObjc.Keys.titleKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &MyClassObjc.Keys.titleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

/*:
 45 Lock
 @synchronized 互斥锁，在OC非常方便的为局部代码添加锁的方法，只需要传入一个对象，然后将需要加锁的代码加在大括号内。
 swift 中并没有 @synchroinzed,实现方式 更为直观(其实就是@synchronized的实现方式)

 */
func testLock(obj: MyObject) {
    objc_sync_enter(obj)
    //需要加锁的代码
    objc_sync_exit(obj)
}
// 封装
func synchronized(_ lock: AnyObject, closure: ()-> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
/*:
 46 Toll-Free Bridging 和Unmanged
 在OC中 Core Fundation的api  一般对应有CF的类型等，比如CFString  CFURLRef等，在使用CF的api时 需要将NS的对象转换为CF的对象。
 因为CF的api一般只接受CF类型的对象。而在OC中 ARC只管NSObject的自动引用。因此CF的内存只能手动管理内存。
 在NS 转为CF时需要, 可以使用__bridge 修饰转换的对象，表示内存管理权不变。意味着不用手动管理。

 在swift中 系统的CF也在ARC的管理范围内 所以也就不需要__bridge
 swift 没有强制要求命名遵循CF命名规范，所以ARC无法应用与第三方或者自定义的CF api。 所以这类api导入swift时 类型会被对应为
 Unmanged<T> 是需要自己进行内存管理的
 */

///Swift 与开发环境及一些实践-----------------------------------------------------------------
/*:
 47 随机数生成
 */
let randomNum = arc4random()// 产生一个UInt32的整数

/*:
 48 print 与debugPrint
 默认print输出对象本身，可以实现CustomStringConvertible协议来实现 对象的格式化输出
 */
extension MyObject: CustomStringConvertible {
    var description: String {
        return "格式化输出的对象: \(self.num)"
    }
}

print(myObject)

/*:
 49 错误与异常处理
 <异常 一般在代码级别 ，如果争取的catch了异常 比处理。程序依然能正常运行。比如Array 越界，  对象无法处理的消息， json解析错误等。
 错误一般为 用户操作 或者 运行设备引起的 问题。  比如用户名密码错误， 硬盘满导致新内容无法写入等都是错误。>

 但是swift使用Error定义异常

在可以throw的方法内永远不要返回Optional的值，如果结合try?使用  会多重Optional， 如果返回值的nil, 解包会得到Optional<nil>
 */

enum MyError: Error {

}

/*:
 50 断言
 一般是自己的api 方法内做一些参数的条件判断，用以提醒调用方。assert 默认只在debug编译时有效。 如果要在release中生效 可以修改编译标记.不过一般不会这么做
 */

/*:
 51 fatalError
 产生严重错误，使app强制退出，比如为了规范 在基类定义了子类必须重写的方法
 */


class ClassFatalError {
    func mustOverride() {
        fatalError("必须重写")
    }
}

class SubClassFatalError: ClassFatalError {

}
//应该尽量使用协议 强制子类必须实现某些方法.

/*:
 52 代码组织与 Framework
 iOS 中framework  可以被看做为阉割版的动态库。 因为framework  只能在app和app的扩展中进行动态链接。 而无法在app之间进行共享使用。
 但是使用framework 对组件化开发有很大的帮助， 可以将每个组件制作为二进制的framework， 减少编译的时间。 并在多个项目中使用。
 目前由于swift还是会定期的更新， 但是swift开发的二进制的framework， 要求调用方和framework的swift版本一致。所以每次swift版本更新 都必须所有项目一起更新。否则会因为版本冲突，编译报错.
 */

/*:
  53 安全的资源组织方式
 在iOS中  使用图片资源， 或者segue时都需要传入字符串，但是同一个资源使用的地方较多，修改会极其不便。可以采用第三方库R.swift 和SwiftGen
 */

/*:
 54 Playground
 延时运行---需要 引入PlaygroundSupport, 并设置PlaygroundPage.current.needsIndefiniteExecution = true
 可视化开发---PlaygroundPage.current.liveView = UILabel(),  liveview也可以是ViewController, 所以在实际项目中加入Playground 可以调试UI且不用每次重启app
 */

/*:
 55 数字与数学

 */
//常用特殊数
Int.max
Int.min
Double.infinity//  无穷大
let numNan = Double.nan //Not a number, 运算错误产生的结果
//数字自身和自身比较就可以判断 是否为NaN，
if numNan == numNan {
    print("Num is \(numNan)")
} else {
    print("NaN")
}
if numNan.isNaN {

}
/*:
 56 性能
 swift相较OC在性能上 有极大的提升，比如方法的查找，oc需要一层层的在自身以及父类中查找，而纯swift的class在编译期就已经确定了调用的方法。
 */

/*:
 57 Log 输出
 #file 调用处的文件名
 #line 调用处的行号  Int型
 #column 调用处的列  Int
 #function 调用处的方法名
 */

/*:
 58 属性访问控制
 默认为internal 只能在当前的lib中调用
 private  只能在统一文件同一类型中调用 包含extension
 fileprivate  同一文件 不同类型调用
 public和open都是外部可以调用 ，但是只有open的代码才可以在外部继承与重写。
 */

/*:
 59 Core Data
 OC中的@dynamic修饰的属性时告诉编译器 不自动生成getter setter，代码运行时会添加。如果不添加就会crash。swift中 dynamic修饰的属性才能使用kvo
 */







