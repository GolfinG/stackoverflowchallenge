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
  def format_answer_body(answer)
    maxLength = 150
    answer = strip_tags(answer)
    if (strlen(answer) > maxLength)
      answer = substr(answer, 0, maxLength) + "..."
    end
    return answer
  end

  def get_question_html(question)
    return %Q(
      <div class="score number">#{question['score']}</div>
      <p class="bodytext">
        <a href="http://stackoverflow.com/questions/#{question['question_id']}">
          #{question['title']}
        </a>
      </p>
      <strong class="left">- <a href="http://stackoverflow.com/users/#{question['owner']['user_id']}">#{question['owner']['display_name']}</a></strong>
      <span class="small right" style="text-align: right">#{format_date(question['creation_date'])}<br />#{implode(", ", question['tags'])}</span>
    )
  end

  def get_answer_html(answer)
    return %Q(
    <div class="score number">#{answer['score']}</div>
      <p class="bodytext"><a href="http://stackoverflow.com/questions/#{answer['question_id']}##{answer['answer_id']}">
        #{format_answer_body(answer['body'])}
      </a></p>
        <strong class="left">- <a href="http://stackoverflow.com/users/#{answer['owner']['user_id']}">#{answer['owner']['display_name']}</a></strong>
      <span class="small right">#{format_date(answer['creation_date'])}</span>
    )
  end
end
