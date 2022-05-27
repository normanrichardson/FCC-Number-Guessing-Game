# [FCC Number Guessing Game](https://www.freecodecamp.org/learn/relational-database/build-a-number-guessing-game-project/build-a-number-guessing-game)

This was put together for the Relational Database (Beta) course on [FCC](https://www.freecodecamp.org/learn/relational-database/). 
The aim was to:
* create a schema for a PostgreSQL database
* create an interactive Bash program that uses a PostgreSQL database
* use version control.

## Project Improvements

I have extended this project in the following ways:
* local development with Docker

## Setup

Clone the Repository

```
$ git clone git@github.com:normanrichardson/FCC-Number-Guessing-Game.git
$ cd FCC-Number-Guessing-Game
```

### Running postgres with Docker:
Using the standard postgres docker image create the container:
```
$ docker run --name=num-guess-proj \
-e POSTGRES_USER=freecodecamp \
-e POSTGRES_PASSWORD=1234 \
-e POSTGRES_DB=number_guess \
-v "$(pwd)"/.:/home \
-d \
--rm \
postgres:latest
```
This will:
* launch a new container named num-guess-proj in the background (see `$ docker ps`). 
* remove the container after stopping it.
* map the `./` directory onto the container's directory `home`. 
The mapped files are accessible within the container and the host.

Launch psql in the num-guess-proj container and run the `createDB.sql` file:
```
$ docker exec -it -w /home/src/ num-guess-proj \
psql -U freecodecamp -d number_guess -f createDB.sql
```
This will perform the project specific database set up.

Run the `git_component.sh` bash script on the host in the project folder
```
./src/git_component.sh
```
This will initialize the project specific git repositiory, create branches and commits in the `number_guessing_game` folder.

Run the `number_guessing_game.sh` bash script on the container:
```
$ docker exec -it -w /home/number_guessing_game num-guess-proj \
./number_guessing_game.sh
```

Dump the file as required by the project description
```
$ docker exec -i -w /home/number_guessing_game num-guess-proj \
pg_dump -cC --inserts -U freecodecamp number_guess > number_guess.sql
```

Stop the container
```
docker stop num-guess-proj
```
