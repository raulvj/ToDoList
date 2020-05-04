class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]
  
  # GET /todo_lists
  def index
    if user_signed_in?
      @shared = Sharedlist.where(:id_user => current_user.id)
      #puts(@shared.id_user)
      @todo_lists = TodoList.where(:user_id => current_user.id)
      for s in @shared
        @todo_lists = @todo_lists + TodoList.where(:id => s.id_list)
      end
    end
    #@todo_lists = TodoList.all
  end

  # GET /todo_lists/1
  def show
  end

  # GET/todo_lists/1/share
  def share
    if !params[:commit].nil?
      receiver = User.find_by_username(params[:receiver])
      Notification.create(status: "Pending", sender_id: current_user.id, receiver_id: receiver.id, todo_list: params[:id])
    end
  end

  # GET /todo_lists/new
  def new
    #@todo_list = TodoList.new
    @todo_list = current_user.todo_lists.build
  end

  # POST /todo_lists
  def create
    #@todo_list = TodoList.new(todo_list_params)
    @todo_list = current_user.todo_lists.build(todo_list_params)
    respond_to do |format|
      if @todo_list.save
        format.html { redirect_to @todo_list, notice: 'To-Do list was successfully created.' }
        format.json { render :show, status: :created, location: @todo_list }
      else
        format.html { render :new }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /todo_lists/1/edit
  def edit
  end

  # PATCH/PUT /todo_lists/1
  def update
    respond_to do |format|
      if @todo_list.update(todo_list_params)
        format.html { redirect_to @todo_list, notice: 'To-Do list was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo_list }
      else
        format.html { render :edit }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1
  def destroy
    if @todo_list.user_id == current_user.id
      @todo_list.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'To-Do list was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Could not delete To-Do list as you are not the owner.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = TodoList.find(params[:id])
    end

    #def pending
    #  if user_signed_in?
    #    @notifications = Notification.where(:receiver_id => current_user.id, :status => "Pending")
    #    if !@notifications.nil?
    #      render html: "<script>alert('You've new notifications!')</script>".html_safe
    #    end
    #  end
    #end

    # Only allow a list of trusted parameters through.
    def todo_list_params
      params.require(:todo_list).permit(:title, :description)
    end
end
