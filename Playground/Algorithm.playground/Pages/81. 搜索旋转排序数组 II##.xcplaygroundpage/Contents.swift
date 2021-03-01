//: [Previous](@previous)

import Foundation

//https://leetcode-cn.com/problems/search-in-rotated-sorted-array-ii/
//这是 搜索旋转排序数组 的延伸题目，本题中的 nums  可能包含重复元素。
//这会影响到程序的时间复杂度吗？会有怎样的影响，为什么？
// 会有一定影响，对于首尾数据相同的情况，需要剔出 首或者尾的重复数据
class Solution {
    func search(_ nums: [Int], _ target: Int) -> Bool {
        guard nums.count > 0 else { return false }
        var l = 0
        var r = nums.count-1
        var m: Int = (r+l)/2
        while l<=r {
            if nums[l] == nums[r] {
                if r-1>l {
                    r -= 1
                    m = (l+r)/2
                } else {
                    return binarySearch(l, r, nums, target)
                }
            }else if nums[l] < nums[r] {
                return binarySearch(l, r, nums, target)
            } else {
                if nums[l] <= nums[m] {
                    if nums[l] <= target && target <= nums[m] {
                        return binarySearch(l, m, nums, target)
                    } else {
                        l = m+1
                        m = (r+l)/2
                    }
                } else if nums[m+1] <= nums[r] {
                    if nums[m+1] <= target && target <= nums[r] {
                        return binarySearch(m+1, r, nums, target)
                    } else {
                        r = m
                        m = (r+l)/2
                    }
                }
            }
        }
        return false
    }

    private func binarySearch(_ ll: Int, _ rr: Int, _ nums: [Int],_ target: Int) -> Bool {
        var l = ll
        var r = rr
        var m: Int = (r+l)/2
        while l<=r {
            if nums[m] == target {
                return true
            } else if target > nums[m] {
                l = m+1
                m = (r+l)/2
            } else if target < nums[m] {
                r = m-1
                m = (r+l)/2
            }
        }
        return false
    }
}


let arr = [3,1,2,2]

Solution().search(arr, 0)
