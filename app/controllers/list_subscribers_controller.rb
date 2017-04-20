
class ListSubscribersController < ApplicationController
  before_action :authenticate_user!

  # POST /listsubscribers
  # POST /listsubscribers.json
  def create
    list_id = params[:list_id]
    user_email = params[:email]

    @user = User.where(:email => user_email).take
    list = List.find(list_id)
    if @user and list.user_id == current_user.id
      @list_subscriber = ListSubscriber.new(:user_id => @user.id, :list_id => list_id)
      respond_to do |format|
        if @list_subscriber.save
          format.js {}
        else
          format.js { render js: 'alert(Save error: Please try later)' }
        end
      end
    else
      respond_to do |format|
        format.js {render js: 'alert("User must be registered in system")'}
      end
    end
  end

  # DELETE /listsubscribers/1
  def delete
    @list_subscriber= ListSubscriber.find(params[:id])
    if @list_subscriber.list.user_id == current_user.id and @list_subscriber.destroy
      respond_to do |format|
        format.js {}
      end
    end
  end

end
