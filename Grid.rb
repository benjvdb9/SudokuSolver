require './Solver'

class Grid < Solver
    def  initialize
        super(v: false)
    end

    def add(nums)
        @squares += nums
    end

    def isFull
        if @squares.size == 9
            return true
        end
        return false
    end

    def isSolved
        unknowns = 0
        for square in @squares
            if not square.known
                unknowns += 1
            end
        end

        if unknowns == 0
            return true
        else
            return false
        end
    end

    def pprint
        square = @squares.clone
        square.each_index{|x| square[x] = square[x].val}
        print(square[0, 3], "\n")
        print(square[3, 3], "\n")
        print(square[6, 3], "\n")
    end
end