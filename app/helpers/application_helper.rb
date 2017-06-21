module ApplicationHelper
  def get_color
    if logged_in?
      @cur = current_user
      color = @cur.read_attribute :color
    else
      "orange"
    end
  end
end
