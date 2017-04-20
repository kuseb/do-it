class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @tasks = @list.tasks

    if @list
      @is_edit_site = false
      if user_signed_in?
        @list_subscribers = ListSubscriber.where(:list_id => @list.id).joins(:user).select('list_subscribers.id, list_subscribers.user_id, users.email AS user_email')
        @lists = List.where(:user_id => current_user.id)

        if current_user.id == @list.user_id
          @is_edit_site = true
        end
        if @is_edit_site or @list_subscribers.any? {|ls| ls.user_id}
          respond_to do |format|
            format.html{}
          end
        else
          respond_to do |format|
            format.html{redirect_to home_index_path, notice: "You don't have permissions to show this list!"}
          end
        end
      elsif @list.is_public?
        respond_to do |format|
          format.html{}
        end
      end

      respond_to do |format|
      format.html{ redirect_to new_user_registration_url}
      end
    end

  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
    @list_subscribers = ListSubscriber.where(:list_id => @list.id).joins(:user).select('list_subscribers.id, list_subscribers.user_id, list_subscribers.list_id, users.email AS user_email')
    @lists = List.where(:user_id => current_user.id)
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.js { flash[:notice] = 'List was successfully created' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.js {}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.require(:list).permit(:name, :color, :is_public, :user_id)
  end

end
