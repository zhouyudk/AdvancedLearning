//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/binary-tree-paths/

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
    func binaryTreePaths(_ root: TreeNode?) -> [String] {
        guard let root = root else { return []}
        var res = [String]()
        helper(root, [], &res)
        return res
    }
    func helper(_ root: TreeNode?, _ vals: [Int], _ res: inout [String]) {
        guard let root = root else { return }
        let nVals = vals + [root.val]
        if root.left == nil && root.right == nil {
            res.append(nVals.map{ "\($0)" }.joined(separator: "->"))
            return
        }
        helper(root.left, nVals, &res)
        helper(root.right, nVals, &res)
    }
}

let dd = ["dd"]
dd.joined(separator: "->")
