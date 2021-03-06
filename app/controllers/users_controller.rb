class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  before_filter :can_only_edit_self, :only => [:edit, :update]

  # GET /users/1/edit
  def edit
    @user = User.find_by_username(params[:id])
  end

  # PUT /users/1
  def update
    @user = User.find_by_username(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "Profile updated."
      redirect_to edit_user_url(@user)
    else
      flash[:notice] = "There were errors saving the form."
      render action: "edit", status: :unprocessible_entity
    end
  end

  protected

    def can_only_edit_self
      unless current_user.username == params[:id]
        flash[:error] = "You cannot edit another user's profile."
        redirect_to root_url
        false
      end
    end

    def user_params
      params.require(:user).permit(:name, :company, :location, :website, :bio, :available_for_hire, :email, :password)
    end

end
