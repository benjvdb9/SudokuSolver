require 'colorize'
require './Grid'
require './Vline'
require './Hline'
require './Square'

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