class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    if session[:activate] == true
      @user.update(activated: true)
      flash.now[:notice] = "User was activated."
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    if params[:from] == "invitation" && params[:start]
      create_and_activate(user_params)
    else
      regular_create(user_params)
    end 
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def create_and_activate(user_params)
      params = user_params.merge(api_key: User.generate_api_key)
      @user = User.new(params)
      @user.activated = true
      player_1 = User.find(params[:start])
      if @user.save
        login(@user)
        response = Faraday.post('/api/v1/games', params: { opponent_email: @user.username }, headers: {"HTTP_X_API_KEY" => player_1.api_key})
        BattleshipNotifierMailer.special_invitation(User.find(params[:start]), @user, response.body[:id], request.base_url).deliver_now
        flash[:notice] = "Logged in as #{@user.username}. Your account has been activated. Check your email for game invite from #{player_1.first_name}"
        redirect_to "/dashboard/#{@user.id}"
      else
        render :new
      end
    end

    def regular_create(user_params)
      params = user_params.merge(api_key: User.generate_api_key)
      @user = User.new(params)
      if @user.save
        login(@user)
        BattleshipNotifierMailer.welcome(@user, request.base_url).deliver_now
        flash[:notice] = "Logged in as #{@user.username}"
        redirect_to "/dashboard/#{@user.id}"
      else
        render :new
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :password, :api_key, :activated, :password_confirmation, :start, :from)
    end
end
