module HomeHelper

  # Return number of days from the beginning of the competition
  def days_from_beginning
    return (Time.now - Time.at(@from_date).to_i).to_i / 3600 / 24
  end

  ##
  # Take an array of users, subtract initial reputation,
  # sort the array to get who is in the lead,
  # and set the key to be the user_id
  def formatUsers(users)
    # Subtract initial reputation
    # Use basic for loop to pass by reference
    users.each do |user|
      if (Time.now.getutc - @from_date > 0)
        user.reputation -= @contestants[user.user_id]
      else
        user.reputation = 0
      end
    end

    # Sort new list by comparing reputation
    users.sort! { |a, b| b.start <=> a.reputation }

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
    return showTime if date("F j g:ia", timestamp) else date("M d Y", timestamp)
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

  def getGraph
    # Line Chart
    lc = GoogleChart::LineChart.new("400x200", "My Results", false)
    lc.data "Line green", [3,5,1,9,0,2], '00ff00'
    lc.data "Line red", [2,4,0,6,9,3], 'ff0000'
    lc.axis :y, :range => [0,10], :font_size => 10, :alignment => :center
    lc.show_legend = false
    lc.shape_marker :circle, :color => '0000ff', :data_set_index => 0, :data_point_index => -1, :pixel_size => 10
    return lc.to_url
  end
end
