//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/minimum-distance-between-bst-nodes/
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }

    static func creatTree(_ count: Int) -> TreeNode? {
        var nodeList = [TreeNode]()
        for i in 0..<count {
            nodeList.append(TreeNode(i))
        }
        var j = 0
        var i = 1
        while i<count {
            let node = nodeList[j]
            node.left = nodeList[i]
            if i+1<count {
                node.right = nodeList[i+1]
            }
            i += 2
            j += 1
        }
        inOrder(nodeList.first!)
        return nodeList.first
    }

    //生成二叉搜索树
    static var i = 0
    static func inOrder(_ node: TreeNode?) {
        if node == nil { return }
        inOrder(node!.left)
        node!.val = i
        print(node!.val)
        i += 1
        inOrder(node!.right)
    }
}


class Solution {
    var lastNum: Int? = nil
    func minDiffInBST(_ root: TreeNode?) -> Int {
        guard let root = root else { return Int.max}
        let ml = minDiffInBST(root.left)
        //访问第一个节点时 lastNum为空 直接返回 ml也就是Int.max
        let minNum = lastNum == nil ? ml : min(root.val - lastNum!, ml)
        lastNum = root.val
        let mr = minDiffInBST(root.right)
        return min(minNum, mr)
    }
}
