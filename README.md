# Team Management System

This is a full-stack application built using Ruby on Rails for managing teams and members within an organization. It provides both a RESTful API backend and a web-based user interface for team and member management.

## Table of Contents

1. Overview
2. Technologies Used
3. Setup Instructions
4. Prerequisites
5. Installation
6. Database Setup
7. Running the Server
8. Frontend & API Endpoints
9. Authentication
10. Team Management Endpoints
11. Member Management Endpoints
12. Testing Instructions
13. Unit Tests
14. End-to-End Tests
15. Database Schema
16. Assumptions Made
17. License

## Overview
This project provides a Team Management System with both an API backend and a web interface. The application allows users to manage teams and members in an organization with role-based access control (team owners can manage teams and members).

### Key Features:
- Team Management: Create, update, delete, view, and list teams.
- Member Management: Add, remove, and list members in teams with filtering by last name.
- Authorization: Only team owners can modify teams and manage members.
- Web Interface: Provides a user-friendly interface to interact with the system.
- API: Exposes RESTful endpoints for all core features, allowing interaction programmatically.

## Technologies Used
- Ruby on Rails 7: Web application framework for both the backend API and frontend views.
- PostgreSQL: Database used to store teams and members.
- JWT Authentication: Secure token-based authentication for API endpoints.
- HTML/CSS/Bootstrap: Frontend technologies for the web interface.
- JavaScript: For dynamic client-side interactions (such as form validation).
- RSpec: For unit and API testing.
- Cypress: For end-to-end testing.
- Swagger/OpenAPI: (Optional) For API documentation.

## Setup Instructions

## Prerequisites
Ensure you have the following software installed:

- Ruby 3.0+
- Rails 7+
- PostgreSQL: Ensure PostgreSQL is installed and running on your system.
- Node.js: For managing JavaScript dependencies.
- Yarn: To install JavaScript packages.

## Installation
1. Clone the repository to your local machine:
```git clone https://github.com/your-username/team-management-system.git```
```cd team-management-system```

2. Install Ruby gems:
```bundle install```

3. Install JavaScript dependencies:
```yarn install```

4. Create and migrate the database:
```rails db:create db:migrate```

5. Seed the database with initial data:
```rails db:seed```

6. Start the Rails server:
```rails s```

The application should now be running on http://localhost:3000.

## Frontend & API Endpoints

## Authentication
- POST /users/sign_in.json: Logs in a user and returns a JWT token for subsequent requests.

### Request Body:
```{  "email": "user@example.com",  "password": "password" }```

### Response:
```{
    "user": {
        "id": 1,
        "email": "example@gmail.com",
        "created_at": "2024-11-12T21:32:44.622Z",
        "updated_at": "2024-11-12T21:32:44.622Z",
        "first_name": "Example",
        "last_name": "Test"
    },
    "jwt": "your_generated_jwt_token"
}
```

## Team Management Endpoints

1. GET /teams.json: List all teams.

2. POST /teams.json: Create a new team.

3. GET /teams/{team_id}.json: Get details of a specific team.

4. PUT /teams/{team_id}.json: Update team details.

5. DELETE /teams/{team_id}.json: Delete a team.

## Member Management Endpoints

1. GET /teams/{team_id}/members: List all members of a team with pagination support.

## Frontend Views

The web interface provides views to interact with the system. These include:

- Teams List: Displays all teams with options to create, edit, or delete teams.
- Team Details: Shows detailed information about a team and its members.
- Member Management: Allows the owner to add or remove members from a team.

## Pages and Routes

- Teams Page: /teams
- Team Management: /teams/:id
- Login Page: /users/sign_in

# Testing Instructions

## Unit Tests (RSpec)
1. Run the tests using RSpec:
```bundle exec rspec```

## Assumptions Made
- Authentication: Users are authenticated using JWT tokens, which are passed in the Authorization header for protected routes.
- Authorization: Only the owner of the team can update team details or modify members.
- Error Handling: The application returns proper error messages for invalid requests and unauthorized actions.
- Pagination: Lists of members include pagination support.

## License
This project is licensed under the MIT License.

