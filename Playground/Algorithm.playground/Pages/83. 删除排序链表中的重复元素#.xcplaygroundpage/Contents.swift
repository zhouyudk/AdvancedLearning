//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/

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
    func deleteDuplicates(_ head: ListNode?) -> ListNode? {
        let root = ListNode()
        root.next = head
        var pre = root
        var curl:ListNode? = pre.next
        while curl?.next != nil {
            if curl!.val != curl!.next!.val {
                pre = curl!
            } else {
                pre.next = curl?.next
            }
            curl = curl!.next!
        }
        return root.next
    }
}

let ln = ListNode.initListNode(vals: 1,2,2,2,3,3,3,4)
ln?.printNode()
Solution().deleteDuplicates(ln)?.printNode()
