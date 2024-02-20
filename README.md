# README

This repository contains the solution to the evaluation challenge for the Development and Technology team at VitaWallet. Below are the instructions for setting up the server and testing the implemented functionalities.

## Usage Instructions

### Setting Up the Server

To set up the server, follow these steps:

1. Clone this repository to your local machine.
2. Install project dependencies using `bundle install`
4. Configure the PostgreSQL database and ensure you have Ruby 3.0 and Rails 7.
5. Run `rake db:create` to create the database.
6. Run database migrations with the command:
```bash
`rake db:migrate`.
```
7. Populate the database with seed data using:
```bash
`rake db:seed`.
```
8. After running the seeds, you can use the following credentials to access the user or you can create another one if you want:

- Email: user@example.com
- Password: password

9. Start the Rails server with the command:
```bash
`rails server`.
```

## Environment Variables Configuration

Before running the application, please make sure to set up the following environment variables:

### Database Configuration

Configure the database connection by setting the following environment variables:

- `DATABASE_HOST`: The database host address (usually `localhost`).
- `DATABASE_PASSWORD`: The database password.

## Running Tests

The project includes RuboCop for code linting and RSpec for testing. You can run the tests using the following command:

```bash
rspec
```

## Postman Collection

[postman_collection](https://www.postman.com/valentinopfarherr/workspace/api-rest-bitcoin/collection/27478968-ac4b94aa-607e-4626-855c-6f4fbcd6141d?action=share&creator=27478968&active-environment=27478968-1d83708c-5ff0-4b92-b485-70d161e408d4)

## Swagger documentation

[swagger](swagger/openapi.yaml)

The Swagger documentation for this project is located in the `swagger` folder. You can refer to this file to understand the structure of the APIs and how to interact with them.

Please remember to keep these resources and documentation updated as the project progresses.
