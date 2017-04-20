class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = List.where(:user_id => current_user.id)
    @tasks = Task.where(:list_id => @lists.ids).where(:is_done => false).where.not(:deadline => nil)
  end
end
