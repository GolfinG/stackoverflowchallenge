require 'curb'
require 'json'

class HomeController < ApplicationController

  def index
    @contestants = {
      '955404' => {:team => 0, :company => 'TwitchTV', :startingReputation => 259}, # Golf
      '959577' => {:team => 0, :company => 'SAY Media', :startingReputation => 16}, # James V
      '379289' => {:team => 1, :company => 'Tableau Software', :startingReputation => 1}, # Tim
      '1382614' => {:team => 1, :company => 'Rover', :startingReputation => 46}, # Cosmo
      '906800' => {:team => 1, :company => 'Wetpaint', :startingReputation => 60}, # Ji
      '1586409' => {:team => 0, :company => 'Intentional Software', :startingReputation => 1}, # Eui
      '1586476' => {:team => 0, :company => 'ComputeNext', :startingReputation => 1}, # DJ
      '781529' => {:team => 1, :company => 'Amazon', :startingReputation => 372}, # Min
      '303052' => {:team => 0, :company => 'Facebook', :startingReputation => 292}, # James A
      # '1829' => {:team => 1, :company => 'Salesforce', :startingReputation => 1}, # Jennifer Yang
      '1610174' => {:team => 1, :company => 'UW', :startingReputation => 1}, # Jim
      '1533702' => {:team => 0, :company => 'Google', :startingReputation => 71}, # Sterling
      '1056955' => {:team => 1, :company => 'Amazon', :startingReputation => 11}, # Siwei
      '1611124' => {:team => 0, :company => 'Marin Software', :startingReputation => 1} # Jayson
    }

    @data = {}
    @from_date = 1345420800 # Timestamp on August 20
    requests = [
      {:name => 'users', :endpoint => '', :params => {}},
      {:name => 'recentReputationChanges', :endpoint => 'reputation', :params => {:pagesize => 10, :fromdate => @from_date}},
      {:name => 'top3Questions', :endpoint => 'questions', :params => {:pagesize => 3, :sort => "votes", :fromdate => @from_date}},
      {:name => 'worstQuestion', :endpoint => 'questions', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @from_date, :order => "asc"}},
      {:name => 'top3Answers', :endpoint => 'answers', :params => {:body => 'true', :pagesize => 3, :sort => "votes", :fromdate => @from_date}},
      {:name => 'worstAnswer', :endpoint => 'answers', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @from_date, :order => "asc"}}
    ]

    m = Curl::Multi.new
    api_url = "http://api.stackexchange.com/2.0/users/"
    requests.each do |request|
      @data[request[:name]] = {}
      endpoint = api_url + get_contestants_id_string + "/" + request[:endpoint] + "?site=stackoverflow.com&" + request[:params].to_param
      c = Curl::Easy.new(endpoint) do |curl|
        curl.follow_location = true
        curl.encoding = "gzip"
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.on_body{|data| @data[request[:name]] = JSON.parse(data) }
      end
      m.add(c)
    end

    m.perform

    @data['users'] = format_users(@data['users']['items'])
    @data['recentReputationChanges'] = @data['recentReputationChanges']['rep_changes']
    #recentReputationChanges = json_decode(curl_multi_getcontent(recentReputationChanges)).rep_changes
    #top3Questions = json_decode(curl_multi_getcontent(top3Questions)).questions
    #worstQuestion = json_decode(curl_multi_getcontent(worstQuestion)).questions[0]
    #top3Answers = json_decode(curl_multi_getcontent(top3Answers)).answers
    #worstAnswer = json_decode(curl_multi_getcontent(worstAnswer)).answers[0]

  end

  ##
  # Take an array of users, subtract initial reputation,
  # sort the array to get who is in the lead,
  # and set the key to be the user_id
  def format_users(users)
    # Subtract initial reputation
    # Use basic for loop to pass by reference
    users.each do |user|
      if ((Time.now.getutc - @from_date).to_i > 0)
        user['reputation'] = user['reputation'] - @contestants[user['user_id'].to_s][:startingReputation]
      else
        user['reputation'] = 0
      end
    end

    # Sort new list by comparing reputation
    users.sort! { |a, b| b['reputation'] <=> a['reputation'] }

    newUsers = {}

    users.each do |user|
      newUsers[user['user_id']] = user
    end
    return newUsers
  end

  ##
  # Return a string containing all contestants' ids delimited by semicolons
  # e.g. 134;1234;543;25;456;3245
  def get_contestants_id_string
    ids = []
    @contestants.each do |id, contestant|
      ids.push(id)
    end
    return ids.join(';')
  end

  def saveDayScore
    c = Curl::Easy.new(endpoint) do |curl|
      curl.follow_location = true
      curl.encoding = "gzip"
      
      curl.on_body{|data| test = data }
    end
  end

end
