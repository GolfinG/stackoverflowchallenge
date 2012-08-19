require 'rubygems'
require 'curb'

class HomeController < ApplicationController

  @contestants = [
    {:id => '955404', :team => 0, :full_name => 'Golf Sinteppadon', :company => 'TwitchTV', :startingReputation => 159},
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
  @API_URL = "http://api.stackexchange.com/2.0/users/"
  @responses = {}
  @FROM_DATE = 1317193260 # Timestamp on September 28

  def index
    requests = [
      {:name => 'users', :endpoint => ''},
      {:name => 'recentReputationChanges', :endpoint => 'reputation', :params => {:pagesize => 10, :fromdate => @FROM_DATE}},
      {:name => 'top3Questions', :endpoint => 'questions', :params => {:pagesize => 3, :sort => "votes", :fromdate => @FROM_DATE}},
      {:name => 'worstQuestion', :endpoint => 'questions', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @FROM_DATE, :order => "asc"}},
      {:name => 'top3Answers', :endpoint => 'answers', :params => {:body => 'true', :pagesize => 3, :sort => "votes", :fromdate => @FROM_DATE}},
      {:name => 'worstAnswer', :endpoint => 'answers', :params => {:body => "true", :pagesize => 1, :sort => "votes", :fromdate => @FROM_DATE, :order => "asc"}}
    ]

    m = Curl::Multi.new
    requests.each do |request|
      @responses[request[:name]] = ""
      endpoint = @API_URL + getContestantsIdString + "/" + request[:endpoint] + "?" + request[:params].join("")
      c = Curl::Easy.new(request[:endpoint]) do |curl|
        curl.follow_location = true
        curl.headers["Accept-Encoding"] = "gzip"
        curl.on_body{|data| @responses[request[:name]] << data; data.size }
        curl.on_success {|easy| puts "success, add more easy handles" }
      end
      m.add(c)
    end

    m.perform do
      puts "idling... can do some work here"
    end

    # Calculate days remaining until end date
    #datetime1 = new DateTime()
    #datetime2 = new DateTime('2011-10-29')
    #daysLeft = datetime1->diff(datetime2)
  end

  ##
  # Return a string containing all contestants' ids delimited by semicolons
  # e.g. 134;1234;543;25;456;3245
  def getContestantsIdString
    ids = []
    @contestants.each do |contestant|
      ids.push(contestant[:id])
    end
    return ids.join(';')
  end

  ##
  # Take an array of users, subtract initial reputation,
  # sort the array to get who is in the lead,
  # and set the key to be the user_id
  def formatUsers(users)
    # Subtract initial reputation
    # Use basic for loop to pass by reference
    users.each do |user|
      if (Time.now.getutc - @FROM_DATE > 0)
        user.reputation -= @contestants[user.user_id]
      else
        user.reputation = 0
      end
    end

    # Sort new list by comparing reputation
    users.sort! {
      |a, b| b.start <=> a.reputation
    }

    newUsers = {}

    users.each do |user|
      newUsers[user.id] = user
    end
    return newUsers
  end

  ##
  # Take a Stack Overflow timestamp which is in GMT,
  # convert it to PST, and output it as a nice displayable string
  # timestamp the timestamp to format
  # showTime whether or not to show exact time in the result
  def formatDate(timestamp, showTime = true)
    return showTime if date("F j g:ia", timestamp) else date("M d Y", timestamp) end
  end

  ##
  # Take a block of HTML, remove tags, and limit length to maxLength chars
  # @param answer
  def formatAnswerBody(answer)
    maxLength = 150
    answer = strip_tags(answer)
    if (strlen(answer) > maxLength)
      answer = substr(answer, 0, maxLength) + "..."
    end
    return answer
  end
