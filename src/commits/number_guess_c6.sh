#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  RES=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  AGG=$($PSQL "SELECT COUNT(game_id), MIN(num_guess) FROM games GROUP BY user_id HAVING  user_id=$USER_ID;")
  COUNT=$(echo $AGG | sed -E 's/([0-9]+)\|([0-9]+)/\1/')
  MIN=$(echo $AGG | sed -E 's/([0-9]+)\|([0-9]+)/\2/')
  echo "Welcome back, $USERNAME! You have played $COUNT games, and your best game took $MIN guesses."
fi


NUM=$(($RANDOM%1000+1))
GUESS=-1
ITTER=0

echo "Guess the secret number between 1 and 1000:"

while [[ $GUESS -ne $NUM ]]
do
  read GUESS
  ITTER=$(($ITTER+1))
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

echo "You guessed it in $ITTER tries. The secret number was $NUM. Nice job!"
RES=$($PSQL "INSERT INTO games(user_id, num_guess) VALUES($USER_ID, $ITTER);")
