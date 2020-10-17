#!/bin/env ruby
require 'net/http'
require 'uri'
require 'openssl'
require 'nokogiri'
require File.expand_path File.join(File.dirname(__FILE__), 'splunk_search')

class SplunkSDK
    def initialize(username, password, host, opts = {})
        @USER = username
        @PASS = password
        @HOST = host
        @PORT = opts[:port] || 8089
        @USE_SSL = opts[:use_ssl] || false
    end

    # path - string - /services/path/to/service/wanted
    # opts - an optional hash containing request params
    def get_request(path, opts = {})
        uri = URI::HTTP.build(host: @HOST, port: @PORT, path: path, query: URI.encode_www_form(opts))
        req = Net::HTTP::Get.new(uri)
        req.basic_auth(@USER, @PASS)

        splunk_http_request.request(req).body
    end

    # path - string -  /services/path/to/service/wanted
    # data - hash - a hash representing the data 
    # header - hash - an optional hash containing header requests
    def post_request(path, data, header = nil)
        req = Net::HTTP::Post.new(path)
        req.set_form_data(data)
        req.basic_auth(@USER, @PASS)

        splunk_http_request.request(req).body
    end

    def search(search, opts = {})
        wait_time = opts[:wait_time] || 5
        offset = opts[:offset] || 10000
        output_mode = opts[:output_mode] || 'json'

        xml = post_request('/services/search/jobs', {'search' => search})
        doc = Nokogiri::XML(xml)
        return SplunkSearch.new(doc.xpath('//sid').text, self, wait_time, offset, output_mode)
    end

    private
    def splunk_http_request
        request = Net::HTTP.new(@HOST, @PORT)
        request.use_ssl = @USE_SSL
        request.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request
    end
end
