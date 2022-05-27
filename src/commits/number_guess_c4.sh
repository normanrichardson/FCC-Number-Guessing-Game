#! /bin/bash

echo -e "\nEnter your username:"
read USERNAME

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
