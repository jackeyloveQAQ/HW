using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace hw1
{
    public class Solution_threesum
    {
        public IList<IList<int>> ThreeSum(int[] nums)
        {
            IList<IList<int>> result = new List<IList<int>>();
            Array.Sort(nums);
            for(int i=0;i<nums.Length-2;i++)
            {
                int l = i + 1, r = nums.Length - 1;
                while (l< r)
                {
                    if ((nums[i] + nums[l] + nums[r]) == 0)
                    {
                        result.Add(new List<int> { nums[i], nums[l], nums[r] });
                        l--;
                        r++;

                    }
                    else if ((nums[i] + nums[l] + nums[r]) < 0)
                    {
                        r++;

                    }
                    else
                    {
                        l--;
                    }
                }

            }
            return result;

        }
    }
}
