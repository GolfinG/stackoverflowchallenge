require 'curb'
require 'json'

class HomeController < ApplicationController

  def index
    @contestants = [
      {:id => '955404', :team => 0, :full_name => 'Golf Sinteppadon', :company => 'TwitchTV', :startingReputation => 259},
      {:id => '959577', :team => 0, :full_name => 'James Vaughan', :company => 'SAY Media', :startingReputation => 16},
      {:id => '379289', :team => 1, :full_name => 'Tim Vega', :company => 'Tableau Software', :startingReputation => 1},
      {:id => '1382614', :team => 1, :full_name => 'Cosmo Smith', :company => 'Rover', :startingReputation => 46},
      {:id => '906800', :team => 1, :full_name => 'Ji Mun', :company => 'Wetpaint', :startingReputation => 60},
      {:id => '1586409', :team => 0, :full_name => 'Eui Min Jung', :company => 'Intentional Software', :startingReputation => 1},
      {:id => '1586476', :team => 0, :full_name => 'DJ Sprouse', :company => 'ComputeNext', :startingReputation => 1},
      {:id => '781529', :team => 1, :full_name => 'Min Sul', :company => 'Amazon', :startingReputation => 372},
      {:id => '303052', :team => 0, :full_name => 'James Athappilly', :company => 'Facebook', :startingReputation => 292},
      {:id => '1829', :team => 1, :full_name => 'Jennifer Yang', :company => 'Salesforce', :startingReputation => 1}
    ]
    @responses = {}
    @from_date = 1345420800 # Timestamp on August 20
    requests = [
      {:name => 'users', :endpoint => '', :params => {}},
      {:name => 'recentReputationChanges', :endpoint => 'reputation', :params => {:pagesize => 10, :fromdate => @from_date}},
      #{:name => 'top3Questions', :endpoint => 'questions', :params => {:pagesize => 3, :sort => "votes", :fromdate => @from_date}},
      #{:name => 'worstQuestion', :endpoint => 'questions', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @from_date, :order => "asc"}},
      #{:name => 'top3Answers', :endpoint => 'answers', :params => {:body => 'true', :pagesize => 3, :sort => "votes", :fromdate => @from_date}},
      #{:name => 'worstAnswer', :endpoint => 'answers', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @from_date, :order => "asc"}}
    ]

    m = Curl::Multi.new
    api_url = "http://api.stackexchange.com/2.0/users/"
    requests.each do |request|
      @responses[request[:name]] = ""
      endpoint = api_url + get_contestants_id_string + "/" + request[:endpoint] + "?site=stackoverflow.com&" + request[:params].to_param
      c = Curl::Easy.new(endpoint) do |curl|
        curl.follow_location = true
        curl.encoding = "gzip"
        #curl.headers['Accept'] = 'application/json'
        curl.on_body{|data| @responses[request[:name]] = data }
      end
      m.add(c)
    end

    m.perform

    @responses.each do |key,value|
      value = JSON.parse value
    end
  end

  ##
  # Return a string containing all contestants' ids delimited by semicolons
  # e.g. 134;1234;543;25;456;3245
  def get_contestants_id_string
    ids = []
    @contestants.each do |contestant|
      ids.push(contestant[:id])
    end
    return ids.join(';')
  end

end
