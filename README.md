## README

### The Staye at Home Philosopher Server

###### Description:
This is a Rails API that serves its corresponding front-end [ReactJs application](https://the-stay-at-home-philosopher.herokuapp.com/). Authentication is with devise; the client receives a token after logging in and uses that to interact with the API. Authentication is required to add posts and to add comments, but all users can read posts, read comments, and search on posts by keyword. Results are paginated with a page parameter```"page={page number}"```, and users can search on posts by keyword via search parameter```"search={keyword}"```. When a user is written to the database their Hashed email is also stored and sent to the client to fetch their
Gravatar without exposing the user's email.

#### API
The API returns data according the [JSON API spec](http://jsonapi.org/)
Routes:

* ```GET:  /api/v1/posts #=> post index```
* ```POST: /api/v1/posts #=> post create```
* ```GET:  /api/v1/posts/:id #=> post show```
* ```GET:  /api/v1/comments #=> comments index```
* ```POST: /api/v1/comments #=> comments create```
* ```POST: /api/v1/authentication #=> authentication create```
* ```POST: /api/v1/users #=> users create```
* Example: #=> post index
[https://philosopher-forum-server.herokuapp.com/api/v1/posts.json](https://philosopher-forum-server.herokuapp.com/api/v1/posts.json) returns the first ten posts ordered by the most recent ones first.
* Example with parameters: #=> post index with params
[https://philosopher-forum-server.herokuapp.com/api/v1/posts.json?page=2&search=egg](https://philosopher-forum-server.herokuapp.com/api/v1/posts.json?page=2&search=egg)
[https://philosopher-forum-server.herokuapp.com/api/v1/posts.json?] returns the second ten posts that include the key word "egg" in the title or body of the post.

* Ruby version
2.3.0

* Rails version
4.2.8

#### Test Suite
The test suite can be run with ```rspec``` from the root directory

Note about the capybara selenium specs:
To use Chrome you’ll need to have ChromeDriver installed. With Homebrew, ChromeDriver can be installed with: ```brew install chromedriver.```
Since this app is a backend rails api, the feature tests
ping the corresponding react app [the-stay-home-philosopher-client](https://the-stay-at-home-philosopher.herokuapp.com)

* Database creation
To create database and seed data, run:
* ```rake db:create```
* ```rake db:migrate```
* ```rake db:seed```
