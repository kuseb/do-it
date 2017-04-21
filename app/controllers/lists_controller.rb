class ListsController < MainController
  before_action :set_list, only: [:show, :show_with_edit, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [ :edit, :create, :update, :destroy, :show_with_edit ]
  before_action :require_permission, except: [ :show, :create]

  # GET /lists/1/show_with_edit
  def show_with_edit
    @tasks = @list.tasks
    @is_edit_site = true
    respond_to do |format|
      format.html{render :show}
    end
  end

  # GET /lists/1
  def show
    @tasks = @list.tasks
    @is_edit_site = false
      if List.is_user_can_show? @list, current_user
        respond_to do |format|
          format.html{}
        end
      end
  end

  # GET /lists/1/edit
  def edit
    @list_subscribers = ListSubscriber.where(:list_id => @list.id).joins(:user).select('list_subscribers.id, list_subscribers.user_id, list_subscribers.list_id, users.email AS user_email')
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
      if List.is_user_can_modify? @list, current_user
        if @list.save
          format.js { }
          format.json { render :show, status: :created, location: @list }
        else
          format.json { render json: @list.errors, status: :unprocessable_entity }
        end
      else
        format.json { render :json => {}, status: :unauthorized }
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

  def require_permission
    if user_signed_in?
      unless List.is_user_can_modify? @list, current_user
        redirect_to home_index_path, notice: "You don't have permissions to show this list!"
      end
    else
      redirect_to new_user_registration_url, notice: "Log in to show this list"
    end
  end
end
