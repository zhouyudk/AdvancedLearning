//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/partition-list/

public class ListNode {
    public var val: Int
    public var next: ListNode?

    public init() {
        self.val = 0; self.next = nil;
    }

    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val; self.next = next;
    }

    public func printNode() {
        print(val)
        next?.printNode()
    }

    static func initListNode(_ count: Int, _ multiple: Int) -> ListNode {
        let root = ListNode(0)
        var tmp = root
        for i in 0..<count {
            tmp.next = ListNode(i*multiple)
            tmp = tmp.next!
        }
        return root.next!
    }

    static func initListNode(vals: Int...) -> ListNode? {
        let root = ListNode()
        var tmp = root
        for i in vals {
            tmp.next = ListNode(i)
            tmp = tmp.next!
        }
        return root.next
    }
}

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */
class Solution {
    func partition(_ head: ListNode?, _ x: Int) -> ListNode? {
        let root = ListNode()
        root.next = head
        var pre = root
        var current: ListNode? = pre.next
        // 存储筛选出的大于等于x的节点
        let rightRoot = ListNode()
        var rightTmp = rightRoot
        while current != nil {
            if current!.val >= x {
                rightTmp.next = current
                rightTmp = rightTmp.next!
                current = current!.next
                pre.next = current
            } else {
                pre = current!
                current = current!.next
            }
        }
        // 掐掉 大于等于x 链表中尾部小于x的节点
        rightTmp.next = nil
        pre.next = rightRoot.next

        return root.next
    }
}

let ln = ListNode.initListNode(vals: 1,4,3,2,5,2)

Solution().partition(ln, 3)!.printNode()
