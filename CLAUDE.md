# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

This is a Rails 8.0.3 application named "Casks" that uses:
- **PostgreSQL** for the database
- **Bun** for JavaScript building and bundling
- **Turbo Rails** and **Stimulus** for Hotwire/SPA functionality
- **Solid Cache, Solid Queue, and Solid Cable** for database-backed caching, background jobs, and Action Cable
- **Kamal** for deployment via Docker containers

### Purpose
This is a multi-tenant cask warehouse inventory system where:
- **Warehouse companies** can operate multiple warehouse locations
- **Company owners** can:
  - Manage their company and warehouses
  - Add/remove warehouse managers
- **Warehouse managers** (and company owners) can:
  - Manage warehouses
  - Accept new casks into their warehouses
  - Manage storage locations within warehouses
  - Process relocation requests from cask owners
  - Move casks directly
  - Add/remove warehouse staff members
- **Warehouse staff** can:
  - View warehouse inventory
  - Cannot move casks by default (requires special permission)
- **Cask owners** (users) can:
  - View their casks
  - See current location of each cask
  - View the valuation/worth of their casks
  - Request casks to be moved to new locations
  - Track relocation request status

**Storage Location Hierarchy:**
Each warehouse contains multiple storage locations with hierarchical addressing:
- Example: "Shelf-Stack A, Shelf 13, Position 9"
- Allows precise tracking of where each cask is physically stored

**Authorization Hierarchy:**
- Company Owner → Warehouse Managers → Warehouse Staff
- Staff can be granted special permissions (e.g., ability to move casks)
- Cask owners operate independently but interact with warehouses for storage/moves

## Common Commands

### Development Server
```bash
bin/dev                    # Start development server (runs both Rails and JS build watcher)
bin/rails server           # Start Rails server only
bun run build --watch      # Start JavaScript build watcher only
```

### Database
```bash
bin/rails db:create        # Create databases
bin/rails db:migrate       # Run migrations
bin/rails db:seed          # Seed database
bin/rails db:reset         # Drop, create, migrate, and seed
bin/rails dbconsole        # Open database console
```

The app uses multiple PostgreSQL databases in production:
- `casks_production` (primary)
- `casks_production_cache` (Solid Cache)
- `casks_production_queue` (Solid Queue)
- `casks_production_cable` (Action Cable)

### Testing
```bash
bin/rails test                        # Run all tests
bin/rails test test/models            # Run model tests
bin/rails test test/path/to/test.rb  # Run single test file
bin/rails test:system                 # Run system tests
```

### Linting & Security
```bash
bin/rubocop                # Run RuboCop linter (Omakase style)
bin/rubocop -a             # Auto-correct RuboCop offenses
bin/brakeman               # Run security vulnerability scanner
```

### JavaScript/Assets
```bash
bun run build              # Build JavaScript assets once
bun bun.config.js          # Build using custom Bun config
```

JavaScript entrypoint: `app/javascript/application.js`
Build output: `app/assets/builds/`

### Deployment (Kamal)
```bash
bin/kamal setup            # Initial deployment setup
bin/kamal deploy           # Deploy application
bin/kamal console          # Open Rails console on server
bin/kamal shell            # Open bash shell on server
bin/kamal logs             # Tail application logs
bin/kamal dbc              # Open database console on server
```

Deployment config: `config/deploy.yml`
Target server: `192.168.0.1` (web)
Deployment uses Docker with Thruster for asset acceleration

## Architecture

### Background Jobs
- **Solid Queue** runs inside Puma process by default (`SOLID_QUEUE_IN_PUMA: true`)
- For multi-server deployments, split out job processing to dedicated machines
- Job concurrency controlled via `JOB_CONCURRENCY` env var

### Caching Strategy
- Database-backed via Solid Cache (config: `config/cache.yml`)
- Cache schema: `db/cache_schema.rb`

### Action Cable
- Database-backed via Solid Cable (config: `config/cable.yml`)
- Cable schema: `db/cable_schema.rb`

### Asset Pipeline
- Uses **Propshaft** (modern asset pipeline)
- JavaScript bundled with Bun (not Webpack/esbuild)
- Fingerprinted assets bridged between deployments to avoid 404s on in-flight requests

### Environment Configuration
- Uses dotenv-rails for `.env` file in development/test
- Production secrets via Kamal (`.kamal/secrets`)
- Required production env vars: `RAILS_MASTER_KEY`, `CASKS_DATABASE_PASSWORD`

## Key File Locations

- Routes: `config/routes.rb`
- Application config: `config/application.rb`
- Database config: `config/database.yml`
- Deployment config: `config/deploy.yml`
- Bun build config: `bun.config.js`
- Process file for dev: `Procfile.dev`

## Ruby Version
Check `.ruby-version` for the required Ruby version.