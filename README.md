# Micolet coding challenge

![Micolet coding challenge](micolet-logo.png)

## Table of contents
* [Setup](#setup)
* [General info](#general-info)
* [Technologies](#technologies)


## Setup
To get the Rails server running locally:

- Clone this repo
- `bundle install` to install all required dependencies
- `rails db:create` to create postgresQL database we're using,
- `rails db:migrate` to make all database migrations
- `rails db:seed` to create the topics
- Create a copy of .env.example a put your API key from https://www.abstractapi.com/email-verification-validation-api 
- `rails s` to start the local server


## General info
This project is about to persist the email of the users and his preferences in a postgreSQL database. An email is sended when the subscription is successfull. In addition, we could add more preferences options, this have to be add in seeds.rb file, the form will update automatically .

We based on database schema showing in the image below:

![avatar](ERD.png)

## Technologies
Project is created with:
* Ruby version:  2.7.5
* Rails version: 7.0.2.3
* PostgreSQL: 12.9
	
