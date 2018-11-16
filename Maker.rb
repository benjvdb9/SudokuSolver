require 'byebug'
require 'colorize'
require 'io/console'

class Maker
    def initialize
        @blank = [["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  #----------------------------
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  #----------------------------
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"],
                  ["0", "0", "0",  "0", "0", "0",  "0", "0", "0"]]

    def make
        visualize
        for line_id in (0..8).to_a
            for num_id in (0..8).to_a
                inpt = STDIN.getch
                
                if inpt == "C"
                    inpt2 = STDIN.getch
                    if num_id == 0
                        @blank[line_id - 1][8] = inpt2
                    else
                        @blank[line_id][num_id - 1] = inpt2
                    end
                    visualize
                    inpt = STDIN.getch
                end

                if inpt == "Q"
                    break
                end
                puts inpt
                @blank[line_id][num_id] = inpt
                visualize
            end
            if inpt == "q"
                break
            end
        end
    end

    def modify()
        visualize
        print 'Line number: '
        line_id = gets.chomp.to_i
        visualize(line_id)
        print 'Column number: '
        num_id = gets.chomp.to_i
        visualize(line_id, num_id)
        print 'New number? '
        inpt = gets.chomp.to_i
        @blank[line_id-1][num_id-1] = inpt
        visualize
    end

    def visualize(line_id = nil, num_id = nil)
        system("cls")
        i = 0
        j = 1
        puts("=========================================")
        for line in @blank
            if j == line_id and num_id != nil
                line[num_id-1] = line[num_id-1].colorize(:color =>:white, :background => :red)
            end

            ln = "|| %s | %s | %s || %s | %s | %s || %s | %s | %s ||" % line
            
            if j == line_id and num_id == nil
                ln = ln.colorize(:color =>:white, :background => :red)
            end

            puts(ln)
            if i == 2
                i = -1
                puts("=========================================")
            else
                puts("==-----------==-----------==-----------==")
            end
            i+=1
            j+=1
        end
    end

    def save
        File.write('Sudoku.txt', @blank)
        puts "File saved!"
    end

    def get
        f_output =File.read('Sudoku.txt')
        f = eval(f_output)
        @blank = f
    end

    def returnSud
        sud = @blank.clone
        for line in sud
            line.each_index{|index| line[index] = line[index].to_i}
        return sud
    end

    #TERMINAL
    def terminal
        running = true
        while running
            puts "Make: 1, Get: 2, Modify: 3, View: 4, Save: 5, Stop: 6"
            inpt = gets.chomp

            if inpt == "1"
                make
            elsif inpt == "2"
                get
            elsif inpt == "3"
                modify
            elsif inpt == "4"
                visualize
            elsif inpt == "5"
                save
            elsif inpt == "6"
                running = false
            else
                puts "NOT RECOGNI"
            end
        end
    end
end

if __FILE__ = $0
    mk = Maker.new
    mk.terminal
end