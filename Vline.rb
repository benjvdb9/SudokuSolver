require './Solver'

class Vline < Solver
    def initialize(nums)
        super(nums: nums, v: false)
    end
end