//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/number-of-atoms/

class Solution {
    // 使用Hash表存储，以原子名称为Key 个数为value， 对于括号 使用栈
    func countOfAtoms(_ formula: String) -> String {
        var hash = [String: Int]()
        var stack = [String]()
        var name: String? = nil
        var count: String? = nil
        // 每次迭代处理之前的name和count 并判断是否存入最新的字符
        for cc in formula {
            let c = String(cc)
             guard name != nil else {
                name = c
                continue
            }

            if c>="a" && c<="z" {
                name! += c
                continue
            } else {
                // 如果stack顶为")"则出栈
                if !stack.isEmpty && stack.last == ")" {
                    if c>="A" && c<="Z" {
                        let mul = (count != nil ? Int(count!)! : 1)
                        // 下一个字母为大写表示 新的元素名开始  可以开始处理之前的数据
                        stack.removeLast()
                        while !stack.isEmpty {
                            if stack.last! == "(" {
                                stack.removeLast()
                                break
                            } else {
                                hash[stack.last!] = hash[stack.last!]! * mul
                                stack.removeLast()
                            }
                        }
                        name = c
                        count = nil
                    }
                    if c>="0" && c<="9" {
                        count = count != nil ? count!+c : c
                        continue
                    }
                    // 如果右括号连续出现 则直接弹出
                    if c == ")" {
                        while !stack.isEmpty {
                            if stack.last == "(" {
                                stack.removeLast()
                                break
                            } else {
                                stack.removeLast()
                            }
                        }
                        stack.append(c)
                    }
                } else {
                    if (c>="A" && c<="Z") || c == ")" {
                        //每次获取到以元素名称 则判断是括号栈是否为空
                        if !stack.isEmpty {
                            stack.append(name!)
                        }
                        hash[name!] = (hash[name!] ?? 0) + (count != nil ? Int(count!)! : 1)
                        name = c
                        count = nil
                    }
                    if c>="0" && c<="9" {
                        count = count != nil ? count!+c : c
                    }
                }
            }
            print(hash)
            if c == "(" {
                stack.append(c)
            }
        }
        //处理最后一组数据
        //如果stack不为空则表示 以括号结尾，不用处理name
        if stack.isEmpty {
            hash[name!] = (hash[name!] ?? 0) + (count != nil ? Int(count!)! : 1)
        } else {
            stack.removeLast()
            while !stack.isEmpty {
                if stack.last! == "(" {
                    stack.removeLast()
                    break
                } else {
                    let mul = (count != nil ? Int(count!)! : 1)
                    hash[stack.last!] = hash[stack.last!]! * mul
                    stack.removeLast()
                }
            }
        }


        return hash.keys.sorted { $0<$1 }.reduce("") { (res, key) in
            if hash[key]! > 1 {
                return res+key+"\(hash[key]!)"
            } else {
                return res+key
            }
        }
    }
}

let input = "K4(ON(SO3)2)2"//"K4(ON(SO3)2)2"
Solution().countOfAtoms(input)

//不考虑括号的情况
class Solution1 {
    // 使用Hash表存储，以原子名称为Key 个数为value， 对于括号 使用栈
    func countOfAtoms(_ formula: String) -> String {
        var hash = [String: Int]()
        var stack = [String]()
        var name: String? = nil
        var count: String? = nil
        // 每次迭代处理之前的name和count 并判断是否存入最新的字符
        for cc in formula {
            let c = String(cc)
             guard name != nil else {
                name = c
                continue
            }

            if c>="a" && c<="z" {
                name! += c
                continue
            } else {
                if c>="A" && c<="Z" {
                    hash[name!] = (hash[name!] ?? 0) + (count != nil ? Int(count!)! : 1)
                    name = c
                    count = nil
                }
                if c>="0" && c<="9" {
                    count = count != nil ? count!+c : c
                }
            }
        }
        //处理最后一组数据
        hash[name!] = (hash[name!] ?? 0) + (count != nil ? Int(count!)! : 1)

        return hash.keys.sorted { $0<$1 }.reduce("") { (res, key) in
            if hash[key]! > 1 {
                return res+key+"\(hash[key]!)"
            } else {
                return res+key
            }
        }
    }
}
