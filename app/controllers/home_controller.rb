class HomeController < MainController

  def index
    @tasks = Task.where(:list_id => @lists.ids).where(:is_done => false).where.not(:deadline => nil)
  end
end
