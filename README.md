# Splunk-SDK
 - The Splunk-SDK gem is an interface to make accessing splunk through REST API easy! It was built as a replacement for Splunk's deprecated SDK as well as improvements on @cbrito's splunk-client gem.
 - Splunk-SDK gem is more flexible as it gives you direct access to the get and post methods. This along with Splunk's documentation makes it easy to get the information you need! There are also a few specialty search features/methods to address some of the problems I ran into when writing my scripts with the REST API. Specifically it provides an offset when dealing with 1m+ results, as well as progress updates.
 - This gem will be actively maintained so if you have any ideas or suggestions for new objects/classes or any new features, feel free to email me at: matt.hu017@gmail.com or open up an issue at GitHub: https://github.com/matthu017/Splunk-SDK

## How to use:  
### Setup a client object:  
`client = SplunkSDK.new('username', 'password', 'splunk.host.com')`  
Add optional parameters such as use_ssl or port as a hash

**Making post and get requests:**  
`client.get_request('/endpoint/to/access')`  
Add get request parameters as an optional hash  
`client.post_request('/endpoint/to/access', {'key' => 'value'})`

### Returning a search object:  
`search = client.search("search parameters here") `  
Add optional search result parameters such as wait_time, offset, or output_mode as a hash  

**Wait for a search to finish**  
`search.wait`  
`search.wait_percent`  

**Return the results as an array of `output_mode` objects**  
`result_arr = search.results`

**Query to see if the search is done**  
`isDone = search.complete?`

**Cancelling a search**  
`search.cancel`

