class MenuMessage
  attr_accessor :message

  def set_message(str)
    @message = str
  end

  def display
    if !message.nil?
      systext(message)
      message = nil
    end
  end
end
