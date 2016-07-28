# Zebra Bowl

Zebra Bowl is a bowling scoring service with a web interface built with Ruby on Rails.

## Screenshot
![Screenshot](http://i.imgur.com/vZnEJds.png)

## Installation
1. Clone the repository: `git clone git@github.com:changamanda/zebra_bowl.git`
2. `cd zebra_bowl/`
3. `rake db:create`
4. `rake db:migrate`
5. `rake db:seed`
6. `rails s`

## Usage
* Visit `http://localhost:3000/` to start bowling!
* Run `rspec` to run the test suite

## To-Do's
* Replace bowling forms for all players with a master form that keeps track of the current player
* Spares should update after the next throw, not the next frame
* Improve styling for the bowler frames
* Add AJAX so page does not reload after every form submission

## Contributing

1. Fork it!
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Submit a pull request
