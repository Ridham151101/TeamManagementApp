# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :authorize_team_owner, only: [:new_member, :create_member]
  respond_to :html, :json

  # Action to render the form for creating a member user (HTML response only)
  def new_member
    @user = User.new
  end

  # Action to handle creating a member user for both web and API requests
  def create_member
    @user = User.new(user_params)
    @user.add_role(:member) # Assign the 'member' role

    if @user.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Member user created successfully'
          redirect_to some_path # Replace with the desired path after creation
        end
        format.json do
          render json: { message: 'Member user created successfully', user: @user }, status: :created
        end
      end
    else
      respond_to do |format|
        format.html { render :new_member }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  # Strong parameters to permit custom fields
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  # Ensure that only team owners can access this functionality
  def authorize_team_owner
    unless current_user.has_role?(:team_owner)
      respond_to do |format|
        format.html do
          redirect_to root_path, alert: 'You are not authorized to perform this action'
        end
        format.json do
          render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
        end
      end
    end
  end
end
