class Solver
    attr_accessor :squares
    attr_accessor :verb
    def initialize(nums: [], v: false)
        @verb = v
        @squares = nums
    end

    def solve
        ind = 1
        for square in @squares
            if ind == 99 and self.instance_of? (Vline)
                byebug
            end

            other_squares = @squares.clone
            other_squares.delete(square)

            impossible_in_other = square.possibleVals
            for eliminator in other_squares
                impossible_in_other = impossible_in_other & eliminator.impossibleVals

                if eliminator.known and !square.known
                    square.scrapeValue(eliminator.val)
                end
            end

            if impossible_in_other.size == 1 and !square.known
                square.solve(impossible_in_other[0])
            end

            if @verb
                self.verbose(ind, square)
            end
            ind+=1
        end
    end

    def verbose(i, square)
        print(i, ": ", square.known, "\n")
        print(square.possibleVals, "\n")
    end
end