using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace hw1
{
    public class Solution_twosum
    {
        public int[] TwoSum(int[] nums, int target)
        {
            Dictionary<int, int> tmp = new Dictionary<int, int>();
            for(int i=0;i<nums.Length;i++)
            {
                if (tmp.ContainsKey(target - nums[i])) 
                {
                    return new int[] {tmp[target - nums[i]],i}; 
                }
                else
                {   if (tmp.ContainsKey(nums[i]))
                    {
                        tmp[nums[i]] = i;
                    }
                    else
                    {
                        tmp.Add(nums[i], i);
                    }
                    
                }
            }
            return new int[] {-1, -1};
        }
    }
}
