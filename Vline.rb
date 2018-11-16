require './Solver'

class Vline < Solver
    def initialize(nums)
        super(nums: nums, v: false)
    end

    def pprint
        square = @squares.clone
        square.each_index{|x| square[x] = square[x].val}
        print(square, "\n")
    end
end