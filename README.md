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

* Database creation

To create database and seed data, run:
* ```rake db:create```
* ```rake db:migrate```
* ```rake db:seed```

### Test Suite

For the capybara selenium specs you’ll need to have ChromeDriver installed.
With Homebrew, ChromeDriver can be installed with: ```brew install chromedriver.```
Ideally I would want my test suite running in the same environment as my application,
but I wanted to use a React front-end and still meet the requirements of the code
test by using capybara. Since this app is a backend rails api, the feature tests
ping the corresponding react app. [the-stay-home-philosopher-client](https://the-stay-at-home-philosopher.herokuapp.com)

#### Instructions for running the test
1) Make sure that you have pulled down the [React app](https://github.com/chadellison/the-stay-at-home-philosopher-client)
and have it running on "localhost: 3000" (this can be done with ```npm start``` from the app's root directory)

2) Make sure that you have seeded the development environment of the rails app. ```rake db:reset```

3) Run the rails API in development on port 3001 ```rails s -p 3001``` (In a development environment, this is where the React app will look.)

4) run ```rspec``` from the root directory
