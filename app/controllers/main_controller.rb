class MainController < ApplicationController
  before_action :authenticate_user!
  before_action 'get_lists'

  protected
  def get_lists
    if user_signed_in?
    @lists = List.where(:user_id => current_user.id)
  end
  end
end
