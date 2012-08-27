require 'curb'
require 'json'
require 'google_chart'

class HomeController < ApplicationController

  def index
    @contestants = [
      {:id => '955404', :team => 0, :company => 'TwitchTV', :startingReputation => 259}, # Golf
      {:id => '959577', :team => 0, :company => 'SAY Media', :startingReputation => 16}, # James V
      {:id => '379289', :team => 1, :company => 'Tableau Software', :startingReputation => 1}, # Tim
      {:id => '1382614', :team => 1, :company => 'Rover', :startingReputation => 46}, # Cosmo
      {:id => '906800', :team => 1, :company => 'Wetpaint', :startingReputation => 60}, # Ji
      {:id => '1586409', :team => 0, :company => 'Intentional Software', :startingReputation => 1}, # Eui
      {:id => '1586476', :team => 0, :company => 'ComputeNext', :startingReputation => 1}, # DJ
      {:id => '781529', :team => 1, :company => 'Amazon', :startingReputation => 372}, # Min
      {:id => '303052', :team => 0, :company => 'Facebook', :startingReputation => 292}, # James A
      # {:id => '1829', :team => 1, :company => 'Salesforce', :startingReputation => 1}, # Jennifer Yang
      {:id => '1610174', :team => 1, :company => 'UW', :startingReputation => 1}, # Jim
      {:id => '1533702', :team => 0, :company => 'Google', :startingReputation => 71}, # Sterling
      {:id => '1056955', :team => 1, :company => 'Amazon', :startingReputation => 11}, # Siwei
      {:id => '1611124', :team => 0, :company => 'Marin Software', :startingReputation => 1} # Jayson
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

    #m.perform

    @responses.each do |key,value|
      #value = JSON.parse value
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
