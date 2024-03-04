# Class Control (CMS GraphQL)

Class Control is a course management service, a GraphQL server designed to efficiently manage courses, chapters, and units within an educational platform.

Functional Requirements:
- **Read Operations**: Retrieve detailed information about courses, chapters, and units.
- **Creation Operations**: Create a new course, including chapters, and populate chapters with multiple units.
- **Update Operations**: Modify course, chapter, and unit details individually.
- **Deletion Operations**: Delete courses, chapters, and units individually.
- **Reordering**: Reorder chapters within a course and units within a chapter.
- **Authentication**: Sign-up, sign-in and sign-off a user.

Non-functional Requirements:
- **Scalability**: The system is built to handle growing data volumes and increasing user loads.
- **Low-Latency Performance**:  It prioritizes efficiency for heavy-write requests, delivering swift responses to users and minimizing latency.

## 📁 Project Structure

- **app**: contains the core application code.
  - controllers: handles HTTP requests and responses.
  - graphql: contains GraphQL-specific code and schema definitions.
  - models: includes the ActiveRecord or Mongoid models representing the application's data structure.
- **config**: holds configuration files for the application.
  - database.yml: configures database connections.
  - mongoid.yml: defines MongoDB configuration if using Mongoid.
  - routes.rb: defines the URL routes for the application.
- **db**: manages database-related files.
  - migrate: contains database migration files to manage changes to the database schema.
  - schema.rb: represents the current state of the database schema.
- **spec**: contains the test suite for the application.
  - factories: contains codes used for generating test data.
  - graphql: contains GraphQL-specific test files.
  - models: holds the application's model test files.
  - support: provides supporting files for testing utilities.
- **Gemfile**: lists all the dependencies required by the project.

## 🔥 Prerequisite

1. Ruby version: 3.2
2. Docker version: 24.0
  
## 🚀 How to Run

1. Clone the repository to your local machine.
2. Navigate to the project directory.
3. Create a `.env` file and set the following values: 
   ```dotenv
   # postgres
   POSTGRES_USER=test
   POSTGRES_PASSWORD=test
   POSTGRES_HOST=postgres
   
   # rails app
   APP_CNAME=classroom
   
   # MongoDB 
   MONGODB_HOST=mongodb
   ```
4. Execute `make app.build` to boot up the Rails server and Postgres:
5. Execute `make db.setup` to create development, test databases, and run db migration
6. Open the browser and go to http://localhost:3000.
7. Run all tests `make test` or run a specific test `make test path=spec/{spec_file_path}`
