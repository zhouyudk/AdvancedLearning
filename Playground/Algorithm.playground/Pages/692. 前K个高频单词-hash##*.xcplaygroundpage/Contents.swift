//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/top-k-frequent-words/

class Solution {
    func topKFrequent(_ words: [String], _ k: Int) -> [String] {
        var hash = [String: Int]()
        for word in words {
            hash[word] = (hash[word] ?? 0) + 1
        }

        let newWords = hash.keys.sorted {
            if hash[$0] != hash[$1] {
                return hash[$0]! > hash[$1]!
            } else {
                return $0<$1
            }
            } as [String]
        return Array(newWords[0..<k])
    }
}

let words = ["i", "love", "leetcode", "i", "love", "coding"]

Solution().topKFrequent(words, 2)
