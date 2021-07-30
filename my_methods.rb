def get_lead_paragraph(content, max_length = 200)
  if content.length > max_length
    if content[max_length] == ' '
      return content[...max_length]
    end

    i = max_length - 1
    while content[i] != ' '
      i = i - 1
    end
    return content[...i] + '...'
  end

  content
end
