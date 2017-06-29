module ApplicationHelper
  def get_color
    if logged_in?
      @cur = current_user
      color = @cur.read_attribute :color
      color = "orange" if color == nil
    else
      color = "orange"
    end
    "top_bar " + color
  end
end
