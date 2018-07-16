# README

### How To Run This Program and Play 

- In order to run this application, there are a couple of steps you need to follow. First, clone this repository on your local machine by navigating to the folder you would like the application to live in. Once you are there, use the command `git clone git@github.com:Jliv316/battleshift.git `. This presupposes you have git already installed on your computer. If you don't, please follow <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git">this guide.</a>
- Once you have the repository cloned onto your machine, navigate to the folder (i.e. "./:example_folder/battleshift") and run the command ` bundle install ` in order to install the gems included in this application.
- Once the gems are installed, you can run our test suite by running the command ` rspec ` in your terminal. 
- In order to play the game, run the command `rake db:{create,migrate,seed}`. Once this command is finished, you can run the server on your local machine by typing `rails s` into the terminal. You can follow the guide below in order to actually play the game. Both players must register on the site itself before they can play the game.
- Alternatively, you can play the game with our Heroku application located at https://rocky-temple-24873.herokuapp.com. 

### Playing the Game
  In order to play, you will need your API key, the game ID and a browser or application capable of sending POST requests. The first step is to set your ship locations on your board. Your board is a 4x4 square, made of spaces named A1-D4. You have two ships, one of length 2 and one of length 3. In order to set your ships, send a POST request to the endpoint ":base_url/api/games/:game_id/ships" with a body consisting of a JSON object similar to the one below. Base url is either the Heroku web address from above or "http://localhost:3000" if you are running the server on your local machine.

  ```{ "ship_size": "3", "start_space": "A1", "end_space": "A3" }```

  This will place a ship of size 3 on the coordinates A1, A2, and A3. You may place a ship either horizontally or vertically on the board, but not diagonally. To finish setting your ships, send another POST request to the aforementioned endpoint and place a ship of length 2 in a different location. 

  Once you and your opponent have finished setting ships, you will be able to the first shot. In order to take a shot, send a POST request to the endpoint "/api/v1/games/:game_id/shots" with a body in as a JSON object formated like the one below.

  ```{ "target": "A1" }```

  This example command would send a shot to the A1 location on your opponents board. The response from the server will tell you whether that shot was a hit or miss and will also include information about the current game and board. Continue trading shots until one player has sunk all of the other players ships. Once that happens, a winner will be declared and the game will be over.

