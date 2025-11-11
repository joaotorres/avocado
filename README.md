# Avocado Fleet Management System

A multi-tenant fleet management application built with Ruby on Rails for managing vehicles, drivers, assignments, and incidents across different companies.

## Overview

Avocado is a comprehensive fleet management system that enables companies to:
- Manage their vehicle fleet
- Track driver assignments on a daily basis
- Report and monitor incidents
- Analyze costs associated with vehicle incidents
- Enforce role-based access control

## Features

### Multi-Tenancy
- Path-based routing with all resources nested under companies
- Complete data isolation between companies
- Admin users can manage multiple companies

### Role-Based Access Control
The system supports three user roles:

**Admin**
- Manage all companies
- Full access to all features across all companies

**Manager**
- Manage drivers (create, edit, delete driver accounts)
- Manage vehicles (full CRUD)
- Create and manage driver-vehicle assignments
- View and edit all incidents
- Access cost dashboard for financial analysis

**Driver**
- View their own assignments
- Report incidents for assigned vehicles
- View incidents they have reported

### Vehicle Management
- Track vehicle details (make, model, year, license plate, VIN, color, mileage)
- View vehicle assignments history
- View vehicle incidents history
- Tabbed interface for easy navigation

### Assignment System
- Daily driver-to-vehicle assignments
- Validation ensures:
  - One driver per vehicle per day
  - One vehicle per driver per day
  - Drivers and vehicles belong to the same company
- Only managers can create, edit, or delete assignments

### Incident Reporting
- Drivers can report incidents for their assigned vehicles
- Incident categories:
  - Mechanical Issue
  - Electrical Issue
  - Body Damage
  - Interior Issue
  - Accident or Collision
  - Flat Tire
  - Missing or Damaged Equipment
  - Other
- Incident statuses:
  - Open
  - In Progress
  - Resolved
  - Dismissed
- Cost tracking for financial analysis
- Drivers can only report incidents (no editing after creation)
- Managers can update incident status and cost

### Cost Dashboard
- Monthly cost breakdown from company inception to present
- Detailed view of incidents per month
- Total cost aggregation
- Manager-only access

## Technical Stack

- **Ruby**: 3.1.7
- **Rails**: 8.1.1
- **Database**: SQLite (development)
- **Authentication**: Devise
- **Authorization**: Pundit
- **Styling**: Tailwind CSS

## Setup

### Prerequisites
- Ruby 3.1.7 or higher
- Rails 8.1.1
- SQLite3

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd avocado
```

2. Install dependencies:
```bash
bundle install
```

3. Setup the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the server:
```bash
rails server
```

5. Visit `http://localhost:3000`

## Seed Data

The application includes seed data for testing with the following accounts:

**Admin Account**
- Email: admin@example.com
- Password: 123123

**Manager Accounts**
- Email: manager1@acme.com (Acme Corporation)
- Email: manager2@globex.com (Globex Industries)
- Password: 123123

**Driver Accounts**
- Email: driver1@acme.com (Acme Corporation)
- Email: driver2@acme.com (Acme Corporation)
- Email: driver3@globex.com (Globex Industries)
- Password: 123123

## Database Schema

### Key Models

**User**
- Handles authentication via Devise
- Roles: admin, manager, driver
- Belongs to a company (except admin)

**Company**
- Has many users, vehicles, assignments, and incidents

**Vehicle**
- Belongs to a company
- Has many assignments and incidents

**Assignment**
- Daily driver-to-vehicle assignment
- Belongs to driver (User), vehicle, and company
- Unique constraints on driver and vehicle per date

**Incident**
- Tracks vehicle incidents
- Belongs to vehicle, reporter (User), and company
- Includes category, status, description, and cost

## Authorization Policies

Authorization is handled by Pundit with the following policies:

- **CompanyPolicy**: Controls access to company resources
- **VehiclePolicy**: Manages vehicle access based on company and role
- **AssignmentPolicy**: Only managers can manage assignments
- **DriverPolicy**: Managers can manage driver accounts within their company
- **IncidentPolicy**: Drivers can create, managers can create and update

## Routes Structure

All resources are nested under companies for multi-tenancy:

```
/companies/:company_id/vehicles
/companies/:company_id/assignments
/companies/:company_id/drivers
/companies/:company_id/incidents
/companies/:company_id/cost_dashboard
/companies/:company_id/cost_dashboard/:year/:month
```

## Development Notes

### Virtual Resources
The Drivers resource is a virtual resource that manages User records with `role: driver`. This is implemented using a standard Rails controller with explicit `policy_class: DriverPolicy` to handle Pundit authorization correctly.

### Date-Based Constraints
The Assignment model enforces unique constraints at both the database and model level to ensure:
- No driver is assigned to multiple vehicles on the same date
- No vehicle is assigned to multiple drivers on the same date

### Cost Tracking
The Cost Dashboard generates monthly summaries starting from the date of the first vehicle created for the company through the current month, ensuring complete historical tracking.

## License

This project is available for use under standard terms.
