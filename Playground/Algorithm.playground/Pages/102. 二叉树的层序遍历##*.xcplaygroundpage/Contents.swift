//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/binary-tree-level-order-traversal/

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
    //递归
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        var res = [[Int]]()
        func helper(_ root: TreeNode?, _ level: Int) {
            guard let r = root else { return }
            if level < res.count {
                res[level].append(r.val)
            } else {
                res.append([r.val])
            }
            helper(r.left, level+1)
            helper(r.right, level+1)
        }
        helper(root,0)
        return res
    }

    //迭代
}
