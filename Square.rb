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