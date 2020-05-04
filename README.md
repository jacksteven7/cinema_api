# README

## Settings

* Clone repository 
  git clone https://github.com/jacksteven7/cinema_api.git

* Go inside the project
`cd cinema_api`

* Bundle the project
`bundle install`

* Create databases
`rake db:create`

* Run migrations
`rake db:migrate`

* Seed the database
`rake db:seed`

* Start server
`rails s`


## Testing 

* You can import the next postman collection in order to test all the avaliable endpoints to test the functionality

https://www.getpostman.com/collections/95b1f7114a2ae30d3347

### Endpoints

* GET `/movies` => Get all the movies
* GET `/people` => Get all the people
* POST `/movie` => Create a new the movie
* POST `/people` => Create a new the people
* PUT `/movie/:movie_id` => Update a movie with id movie_id
* PUT `/people/:person_id` => Update a person with id person_id
* DELETE `/movie/:movie_id` => Delete de movie with id movie_id
* DELETE `/people/:person_id` => Delete de person with id person_id



## Important

file app/controllers/application_controller.rb was updated adding the next line to avoid the csrf validation.

`protect_from_forgery with: :null_session`

Please in POST and PUT requests change the content-type from text/plain to JSON
