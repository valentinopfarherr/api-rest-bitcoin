# README

This repository contains the solution to the evaluation challenge for the Development and Technology team at VitaWallet. Below are the instructions for setting up the local server and testing the implemented functionalities.

## Usage Instructions

### Production Deployment

You can access the application directly from the production environment hosted on Railway. The URL is: https://api-rest-bitcoin-production.up.railway.app. If you choose this option, jump to Postman Collection & Application Usage sections.

Railway app link: https://railway.app/project/7f88c052-f091-4167-9209-c4f6c336e133/service/3909a6ee-6f96-4c3b-835e-24fec84d190c

### Setting Up the Server (Local)

Alternatively to using the production deployment, you can also set up the local server following these steps:

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

- Email: usertest@gmail.com
- Password: password

9. Start the Rails server with the command:
```bash
`rails server`.
```

## Environment Variables Configuration

Before running the application, please make sure to set up the following environment variables:

### Database Configuration

Configure the database connection by setting the following environment variables:

- `LOCAL_DATABASE_HOST`: The database host address (usually `localhost`).
- `LOCAL_DATABASE_PASSWORD`: The username.
- `LOCAL_DATABASE_PASSWORD`: The database password.

### Coindesk Configuration

- `COINDESK_URL`: The Coindesk API URL.

Some of the variables are found in ENV.test

## Running Tests

The project includes RuboCop for code linting and RSpec for testing. You can run the tests using the following command:

```bash
rspec
```
In addition to using the local server, you can also access the application directly from the production environment hosted on Railway. The URL is: `api-rest-bitcoin-production.up.railway.app`.

## Postman Collection

[postman_collection](https://www.postman.com/valentinopfarherr/workspace/api-rest-bitcoin/collection/27478968-ac4b94aa-607e-4626-855c-6f4fbcd6141d?action=share&creator=27478968&active-environment=27478968-1d83708c-5ff0-4b92-b485-70d161e408d4)

[postman_collection_json](postman/collection.json)

## Swagger documentation

[swagger](https://api-rest-bitcoin-production.up.railway.app/api-docs/index.html)

Please note that the Swagger documentation provides insights into the structure of the APIs and guidance on how to interact with them.

Ensure to keep these resources and documentation updated as the project progresses.

### Application Usage

1. **Create and Log In with User:**
  - Use Postman to send a POST request to the registration endpoint with the necessary user details (e.g., email and password).
  - Upon successful registration, use Postman to send a POST request to the login endpoint with the registered credentials.
  - Upon successful login, the application will create a session and set cookies

2. **Load the Wallet:**
  - With the authentication token obtained from the login process, send a POST request to the wallet credit endpoint, providing the desired currency and the amount to load.


3. **Perform Transactions:**
  - Once the wallet is loaded, initiate transactions by sending POST requests to the transaction endpoint, specifying the currency sent, the currency received and the amount to transfer.

4. **View Transactions:**
  - To view transaction history, send a GET request to the transactions endpoint using Postman.

