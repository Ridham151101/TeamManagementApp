class MembersController < ApplicationController
  before_action :set_team]

  # GET /teams/:team_id/members or /teams/:team_id/members.json
  def index
    # Build the query starting with members and properly joining users
    @members = @team.members
      .includes(:user)  # Use includes for eager loading
      .references(:users)  # Required when using conditions on included associations
      .where("LOWER(users.last_name) LIKE LOWER(?)", "%#{params[:last_name]}%")  # Case-insensitive search
      .page(params[:page])
      .per(10)
  
    respond_to do |format|
      format.html # Renders default HTML view for web requests
      format.json { render json: @members, each_serializer: MemberSerializer }
    end
  rescue => e
    # Handle any errors that might occur
    respond_to do |format|
      format.html { 
        flash[:error] = "Error loading members: #{e.message}"
        redirect_to team_path(@team)
      }
      format.json { 
        render json: { error: e.message }, status: :unprocessable_entity 
      }
    end
  end

  private

  # Find and set the team based on the team_id from nested routes.
  def set_team
    @team = Team.find(params[:team_id])
  end
end
