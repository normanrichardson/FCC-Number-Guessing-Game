#! /bin/bash

# Connection to postgres database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

USER_INTRO() {
  echo -e "\nEnter your username:"
  read USERNAME

  # Get the user id from the database
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

  # If the user id does not exist
  if [[ -z $USER_ID ]]
  then
    # Add the username to the database
    RES=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
    # Get the assigned user id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    # Get the user's history then aggregate it and get the number of games and min number of game guesses
    AGG=$($PSQL "SELECT COUNT(game_id), MIN(num_guess) FROM games GROUP BY user_id HAVING  user_id=$USER_ID;")
    # Get the 1st part of the query
    COUNT=$(echo $AGG | sed -E 's/([0-9]+)\|([0-9]+)/\1/')
    # Get the 2nd part of the query
    MIN=$(echo $AGG | sed -E 's/([0-9]+)\|([0-9]+)/\2/')
    echo "Welcome back, $USERNAME! You have played $COUNT games, and your best game took $MIN guesses."
  fi
}

PLAY_GAME() {
  # Generate a random number: target
  NUM=$(($RANDOM%1000+1))
  # Set the inital trial
  GUESS=-1
  # Guess counter
  ITTER=0

  echo "Guess the secret number between 1 and 1000:"

  # While the trial is not equal to the target
  while [[ $GUESS -ne $NUM ]]
  do
    read GUESS
    # increment the guess counter
    ITTER=$(($ITTER+1))
    # if the target is not a number, 
    # or if the trial is greater than the target,
    # or if the trial is less than the target
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    elif [[ $GUESS -gt $NUM ]]
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $NUM ]]
    then
      echo "It's higher than that, guess again:"
    fi
  done
}

END_GAME() {
  echo "You guessed it in $ITTER tries. The secret number was $NUM. Nice job!"
  # Save the games results to the database
  RES=$($PSQL "INSERT INTO games(user_id, num_guess) VALUES($USER_ID, $ITTER);")
}

USER_INTRO
PLAY_GAME
END_GAME
