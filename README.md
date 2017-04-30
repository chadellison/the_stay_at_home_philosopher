## README

### The Stay at Home Philosopher Server

###### Description:
This Rails API serves data to its corresponding front-end [ReactJs application](https://the-stay-at-home-philosopher.herokuapp.com/). Authentication is with devise; the client receives a token after logging in and then uses that to interact with the API. Authentication is required to add posts and to add comments, but all users can read posts, read comments, and search on posts by keyword. Results are paginated with a page parameter```"page={page number}"```, and users can search on posts by keyword via a search parameter```"search={keyword}"```. When a user is written to the database their Hashed email is also stored and sent to the client to fetch their
Gravatar without exposing the user's email.

The finished product in production can be viewed [here](https://the-stay-at-home-philosopher.herokuapp.com/)

#### API
The API returns data according to the [JSON API spec](http://jsonapi.org/)
Routes:

* ```GET:  /api/v1/posts #=> post index```
* ```POST: /api/v1/posts #=> post create```
* ```GET:  /api/v1/posts/:id #=> post show```
* ```GET:  /api/v1/comments #=> comments index```
* ```POST: /api/v1/comments #=> comments create```
* ```POST: /api/v1/authentication #=> authentication create```
* ```POST: /api/v1/users #=> users create```
* Example of post index
[https://philosopher-forum-server.herokuapp.com/api/v1/posts.json](https://philosopher-forum-server.herokuapp.com/api/v1/posts.json) returns the first ten posts ordered by the most recent ones first.
* Example of post index with parameters:
[https://philosopher-forum-server.herokuapp.com/api/v1/posts.json?page=2&search=egg](https://philosopher-forum-server.herokuapp.com/api/v1/posts.json?page=2&search=egg) returns the second set of ten posts that include the key word "egg" in the title or body of the post.

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
With Homebrew, ChromeDriver can be installed with: ```brew install chromedriver```.
Ideally I would want my test suite running in the same environment as my application,
but I wanted to use a React front-end and still meet the requirements of the code
test by using capybara. Since this app is a backend rails api, the feature tests
ping the corresponding react app. [the-stay-home-philosopher-client](https://github.com/chadellison/the-stay-at-home-philosopher-client)
on (localhost3000).

#### Instructions for running the test suite
1) Run the rails API in development on port 3001 ```rails s -p 3001``` (In a development environment, this is where the React app will look.)

2) Make sure that you reset and seed the development environment of the rails app. ```rake db:reset```

3) Make sure that you have pulled down the [React app](https://github.com/chadellison/the-stay-at-home-philosopher-client)
and that you have it running on "localhost:3000" (this can be done with ```npm start``` from the react app's root directory)

4) run ```rspec``` from the root directory of the rails app.

#### The result should be this:

![Capybara Selenium Test Suite](https://media.giphy.com/media/3og0IL5qbzaF5r64bC/giphy.gif)

#### Project Spec

Make a barebones messaging board

1. Users can register and then must be authenticated before logging in (we use Devise).
Users should have an email (used for logging in), and a first and last name at a minimum.
You can add things like a description or “about me” if you’d like.

2. Users can create posts (title, body, author (user_id), etc)

3. Users can comment on other users’ posts (Comments have post_id, body, author

(user_id))

4. There is a posts index page that lists all posts (for entire site). This is the ‘homepage’.

This should display a list of posts with the title and the author’s name

5. Order posts with most recent posts at the top of the page

6. There is a post show page, that shows a single post. Underneath the post are all the

comments, ordered by date created (oldest at the top)

7. When commenting on a post, you have freedom as far as the layout goes, you can just

have a little box that opens, and the user types in their comment. You can also use a

modal, etc, whatever you want. It makes more sense to have the form for adding a

comment be close to where the comment will end up.

#### Project Requirements

* Upload finished project to github

* Use latest version of Rails 4

* Use ruby 2.2 or newer (we use 2.3 on our main project)

* Rspec unit tests minimum of 10

* One feature test (rspec/capybara)

* If not specified, use whatever gem(s) get the job done

#### Bonus features (not required, but nice to have)

* Style using Bootstrap 3

* Add a modal for creating a new post

* Add a modal for logging in

* Paginate posts#index and/or posts#show (comments)

* Upload to heroku (make an account for free)
