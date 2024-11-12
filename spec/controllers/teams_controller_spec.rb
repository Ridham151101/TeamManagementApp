require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views
  
  let(:user) { create(:user) }
  let(:owned_team) { create(:team, user: user) }
  let(:team) { create(:team, user: user) }
  let(:member) { create(:user) }

  before do
    sign_in user
    owned_team # Ensure this is created before `get :index`
  end

  describe "GET #index" do
    let(:user) { create(:user) } # Create a user
    let(:owned_team) { create(:team, user: user) } # Create a team owned by the user

    before do
      # Give the user the :team_owner role
      user.add_role(:team_owner)
      # Stub the current_user to be the user we created
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "assigns owned teams to @teams when user is a team owner" do
      get :index
      expect(assigns(:teams)).to include(owned_team.reload)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested team to @team' do
      get :show, params: { id: team.id }
      expect(assigns(:team)).to eq(team)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new team' do
        expect {
          post :create, params: { team: { name: 'New Team', description: 'Team Description' } }
        }.to change(Team, :count).by(1)
      end

      it 'redirects to the new team page' do
        post :create, params: { team: { name: 'New Team', description: 'Team Description' } }
        expect(response).to redirect_to(Team.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a team' do
        expect {
          post :create, params: { team: { name: '', description: '' } }
        }.to_not change(Team, :count)
      end

      it 'renders the new template' do
        post :create, params: { team: { name: '', description: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the team' do
        patch :update, params: { id: team.id, team: { name: 'Updated Name' } }
        team.reload
        expect(team.name).to eq('Updated Name')
      end

      it 'redirects to the updated team page' do
        patch :update, params: { id: team.id, team: { name: 'Updated Name' } }
        expect(response).to redirect_to(team)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the team' do
        patch :update, params: { id: team.id, team: { name: '' } }
        team.reload
        expect(team.name).to_not eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { id: team.id, team: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the team' do
      team_to_delete = create(:team, user: user)
      expect {
        delete :destroy, params: { id: team_to_delete.id }
      }.to change(Team, :count).by(-1)
    end

    it 'redirects to the teams index' do
      delete :destroy, params: { id: team.id }
      expect(response).to redirect_to(teams_path)
    end
  end

  describe 'private methods' do
    describe '#authorize_team_owner' do
      context 'when user is not the team owner' do
        it 'redirects to teams path with an alert' do
          other_user = create(:user)
          sign_in other_user
          delete :destroy, params: { id: team.id }
          expect(response).to redirect_to(teams_path)
          expect(flash[:alert]).to eq('Not authorized')
        end
      end
    end
  end
end
