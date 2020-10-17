class SplunkSearch

    attr_reader :sid
    def initialize(searchID, pointer, wait_time, offset, mode)
        @sid = searchID
        @client = pointer
        @WAIT_TIME = wait_time
        @OFFSET = offset
        @OUTPUT_MODE = mode
    end

    # waits until finished
    def wait
        while(!complete?)
            sleep @WAIT_TIME
        end
    end

    #wait until finished with percentage of completion put every @WAIT_TIME
    def wait_percent
        while(!complete?)
            puts percent_complete
            sleep @WAIT_TIME
        end
    end

    # when called, returns the percentage of the search completed
    def percent_complete
        xml = @client.get_request("/services/search/jobs/#{@sid}")
        doc = Nokogiri::XML(xml)
        progress = doc.xpath("//s:key[@name='doneProgress']").text
        return "#{progress}/1.0"
    end

    # returns boolean - if the search is complete
    def complete?
        xml = @client.get_request("/services/search/jobs/#{@sid}")
        doc = Nokogiri::XML(xml)
        text = doc.xpath("//s:key[@name='isDone']").text
        text.to_i == 1
    end

    # cancelling the search
    def cancel
        xml = @client.post_request("/services/search/jobs/#{@sid}/control", {'action' => 'cancel'})
        xml
    end

    # tabluate results, only runs if complete?
    # returns an array with results in each array index
    def results
        numOfSearches = numEvents / @OFFSET #the number of searches we must make to return all values
        result = Array.new
        if (complete?)
            for i in 0..numOfSearches
                result.push( @client.get_request("/services/search/jobs/#{@sid}/results", {'output_mode' => @OUTPUT_MODE, 'count' => @OFFSET, 'offset' => (@OFFSET * i)}))
            end
        end
        result
    end

    private
    def numEvents
        xml = @client.get_request("/services/search/jobs/#{@sid}")
        doc = Nokogiri::XML(xml)
        text = doc.xpath("//s:key[@name='eventCount']").text
        text.to_i
    end
end