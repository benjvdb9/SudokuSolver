require 'byebug'
require 'colorize'

class Sudoku
    def initialize(lines)
        @squares = self.convertToSquares(lines)
        @gridlist = self.getGrids(@squares) 
        @Vlines = self.getVlines(@squares)
        @Hlines = self.getHlines(@squares)
        self.solve
        self.visualize
        self.newStep
    end

    def convertToSquares(lines)
        for line in lines
            line.each_index{|index| line[index] = Square.new(line[index])}
        end
    end

    def solve
        for grid in @gridlist
            grid.solve
        end

        for vline in @Vlines
            vline.solve
        end

        for hline in @Hlines
            hline.solve
        end
    end

    def visualize
        i = 0
        @Vlines[0].squares[0].resetIndex
        puts("=========================================")
        for line in @Vlines
            squares = line.squares.clone
            squares.each_index{|index| squares[index] = squares[index].pr}
            ln = "|| %s| %s| %s|| %s| %s| %s|| %s| %s| %s||" % squares
            puts(ln)
            if i == 2
                i = -1
                puts("=========================================")
            else
                puts("==-----------==-----------==-----------==")
            end
            i+=1
        end
    end

    def isSolved
        for grid in @gridlist
            if not grid.isSolved
                return false
            end
        end
        return true
    end

    def newStep
        if not self.isSolved
            puts("Creating new Sudoku -PRESS TO CONTINUE        -PRESS 1 TO QUIT              
                    -PRESS 2 TO SHOW SUDOKU   -PRESS KEY FOR POSSIBLE VALUES"
                .colorize(:color =>:black, :background => :white))
            x = gets.chomp
            while x != ""
                found = false

                if x == "1"
                    return 0
                end

                if x == "2"
                    found = true
                    self.visualize
                end

                if x == "3"
                    i = 1
                    found = true
                    grid = @gridlist[0]
                    for square in grid.squares
                        print("#{i}: ", square.impossibleVals, "\n")
                        i+=1
                    end
                end

                if x == "4"
                    found = true
                    for lines in @Vlines
                        for square in lines.squares
                            if square.status == "unknown"
                                print("#{square.code}: ", square.possibleVals, "\n")
                            end
                        end
                    end
                end

                for lines in @Vlines
                    for square in lines.squares
                        if square.code == x
                            found = true
                            print(square.possibleVals, "\n")
                        end
                    end
                end

                if not found
                    puts("NO SUCH KEY")
                end
                x = gets.chomp
            end
            curSud = self.createList
            sud = Sudoku.new(curSud)
        end
    end

    def createList
        curSud = []
        for line in @Vlines
            squares = line.squares.clone
            squares.each_index{|index| squares[index] = squares[index].pl}
            curSud.push(squares)
        end
        return curSud
    end

    def getGrids(lines)
        gridlist = []
        g1 = Grid.new
        g2 = Grid.new
        g3 = Grid.new
        for line in lines
            v1 = line[0, 3]
            g1.add(v1)
            v2 = line[3, 3]
            g2.add(v2)
            v3 = line[6, 3]
            g3.add(v3)

            if (g1.isFull)
                gridlist.push(g1, g2, g3)
                g1 = Grid.new
                g2 = Grid.new
                g3 = Grid.new
            end
        end
        return gridlist
    end
    
    def getVlines(lines)
        vlines = []
        for line in lines
            vline = Vline.new(line)
            vlines.push(vline)
        end
        return vlines
    end

    def getHlines(lines)
        hlines = []
        for i in (0..8).to_a
            hline_nums = []
            for line in lines
                hline_nums.push(line[i])
            end
            hline = Hline.new(hline_nums)
            hlines.push(hline)
        end
        return hlines
    end
end

class Square
    attr_accessor :val
    attr_accessor :code
    attr_accessor :known
    attr_accessor :index
    attr_accessor :status
    attr_accessor :possibleVals
    attr_accessor :impossibleVals

    def initialize(num)
        @val = num
        @status = "unknown"
        @impossibleVals = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        @@index = 0
        if num == 0
            @known = false
            @possibleVals = [1, 2, 3, 4, 5, 6, 7, 8, 9]
            @impossibleVals = []
        else
            @status = "given"
            @known = true
            @possibleVals = [num]
            @impossibleVals.delete(num)
        end
    end

    def scrapeValue(val)
        @possibleVals -= [val]
        if not @impossibleVals.include?(val)
            @impossibleVals += [val]
        end
        self.getStatus
    end

    def solve(val)
        @possibleVals = [val]
        @impossibleVals = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        @impossibleVals.delete(val)
        @status = "solved"
    end

    def getStatus
        if @possibleVals.size == 1
            @status = "solved"
        else
            @status = "unknown"
        end
    end

    def pr
        if @status == "given"
            val = @val.to_s + " "
            return val.yellow
        elsif @status == "solved"
            val = @possibleVals[0].to_s + " "
            return val.green
        else
            return self.getCode.red
        end
    end

    def pl
        if @status == "given"
            return @val
        elsif @status == "solved"
            return @possibleVals[0]
        else
            return 0
        end
    end

    def getCode
        alphabet = ("A".."Z").to_a
        if @@index < 26
            @code = alphabet[@@index] 
            code =  @code + " "
        else
            tens = @@index / 26
            ones = @@index % 26
            code = alphabet[tens-1] + alphabet[ones]
            @code = code
        end
        @@index += 1
        return code
    end

    def resetIndex
        @@index = 0
    end
end

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
end

class Vline < Solver
    def initialize(nums)
        super(nums: nums, v: false)
    end
end

class Hline < Solver
    def initialize(nums)
        super(nums: nums, v: false)
    end
end

if __FILE__ == $0
    curSud =    [[0, 7, 0,  0, 0, 4,  8, 0, 0],
                 [0, 0, 1,  2, 0, 0,  4, 0, 0],
                 [0, 0, 0,  5, 0, 0,  0, 0, 0],
                 #----------------------------
                 [0, 2, 0,  1, 7, 0,  5, 0, 0],
                 [1, 4, 0,  0, 6, 0,  0, 0, 0],
                 [0, 0, 6,  8, 0, 0,  7, 3, 0],
                 #----------------------------
                 [5, 1, 0,  0, 0, 0,  3, 0, 2],
                 [0, 9, 0,  0, 0, 0,  0, 0, 6],
                 [7, 0, 0,  0, 0, 0,  0, 0, 8]]
    
    newSud =    [[6, 0, 0,  0, 9, 0,  0, 0, 3],
                 [0, 3, 4,  0, 0, 0,  0, 0, 9],
                 [7, 2, 0,  4, 0, 0,  8, 0, 6],
                 #----------------------------
                 [0, 0, 0,  6, 7, 0,  3, 0, 8],
                 [0, 0, 0,  0, 2, 0,  0, 0, 0],
                 [1, 6, 0,  0, 0, 4,  7, 0, 0],
                 #----------------------------
                 [0, 0, 3,  2, 0, 8,  0, 0, 0],
                 [0, 0, 5,  0, 6, 0,  2, 0, 0],
                 [0, 0, 0,  1, 0, 0,  9, 8, 7]]

    sud = Sudoku.new(newSud)
end