module HomeHelper

  # Return number of days from the beginning of the competition
  def days_from_beginning
    return (Time.now - Time.at(@from_date).to_i).to_i / 3600 / 24
  end

  ##
  # Take a Stack Overflow timestamp which is in GMT,
  # convert it to PST, and output it as a nice displayable string
  # timestamp the timestamp to format
  # showTime whether or not to show exact time in the result
  def format_date(timestamp, showTime = true)
    #return showTime ? DateTime.strptime(timestamp, "F j g:ia") : DateTime.strptime(timestamp, '%M %d %Y')
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

end
