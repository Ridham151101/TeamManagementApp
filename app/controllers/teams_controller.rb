class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :authorize_team_owner, only: %i[edit update destroy]

  # GET /teams or /teams.json
  def index
    @teams = current_user.has_role?(:team_owner) ? current_user.owned_teams : current_user.teams

    respond_to do |format|
      format.html # Renders the default HTML view for web requests
      format.json { render json: @teams, each_serializer: TeamSerializer } # Serializes @teams using TeamSerializer for API requests
    end
  end

  # GET /teams/1 or /teams/1.json
  def show
    @members = @team.members.includes(:user)

    respond_to do |format|
      format.html # Renders the default HTML view for web requests
      format.json { render json: @team, serializer: TeamSerializer } # Serializes @team using TeamSerializer for API requests
    end
  end

  # GET /teams/new
  def new
    filter = params[:filter]
    @team = current_user.owned_teams.build
    @members = User.with_role(:member)
    
    # Filter @members based on filter, if present
    if filter.present?
      @members = @members.where('LOWER(last_name) LIKE ?', "%#{filter.downcase}%")
    end
  end

  # GET /teams/1/edit
  def edit
    filter = params[:filter]
    
    # Start with the base query for @members
    @members = User.with_role(:member)
    
    # Filter @members based on filter, if present
    if filter.present?
      @members = @members.where('LOWER(last_name) LIKE ?', "%#{filter.downcase}%")
    end
    
    # Get @team_members with associated users
    @team_members = @team.members.includes(:user)
    
    # Apply the filter to @team_members, if present
    if filter.present?
      # Filter the @team_members by last_name in a case-insensitive manner
      @team_members = @team_members.select do |member|
        member.user.last_name.downcase.include?(filter.downcase)
      end
    end
  
    # Optionally map to only the user objects if needed
    @team_members = @team_members.map(&:user)
  end  

  # POST /teams or /teams.json
  def create
    @team = current_user.owned_teams.build(team_params)
  
    respond_to do |format|
      if @team.save
        # Add selected members to the team after the team is saved
        add_members_to_team(@team, params[:team][:member_ids])
  
        format.html { redirect_to @team, notice: "Team was successfully created." }
        format.json { render json: @team, status: :created, serializer: TeamSerializer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        # Update team members based on submitted member_ids
        update_team_members(@team, params[:team][:member_ids])
        
        format.html { redirect_to @team, notice: "Team was successfully updated." }
        format.json { render json: @team, status: :ok, serializer: TeamSerializer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!

    respond_to do |format|
      format.html { redirect_to teams_path, status: :see_other, notice: "Team was successfully destroyed." }
      format.json { head :no_content } # For API responses, sends a no-content response to indicate successful deletion
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  def authorize_team_owner
    redirect_to teams_url, alert: 'Not authorized' unless @team.user == current_user
  end
  def add_members_to_team(team, member_ids_param)
    return unless member_ids_param.present?
  
    member_ids = member_ids_param.split(",").map(&:to_i)
    member_ids.each do |member_id|
      member = team.members.build(user_id: member_id)
      member.save
    end
  end

  def update_team_members(team, member_ids_param)
    return unless member_ids_param.present?
  
    # Convert the member IDs from the form into an array of integers
    member_ids = member_ids_param.split(",").map(&:to_i)
  
    # Find current members' user IDs for the team
    current_member_ids = team.members.pluck(:user_id)
  
    # Identify members to be added and removed
    members_to_add = member_ids - current_member_ids
    members_to_remove = current_member_ids - member_ids
  
    # Add new members to the team
    members_to_add.each do |member_id|
      team.members.create(user_id: member_id)
    end
  
    # Remove members no longer in the selected member list
    team.members.where(user_id: members_to_remove).destroy_all
  end
  
  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :description)
  end
end
