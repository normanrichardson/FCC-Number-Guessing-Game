commit_fn() {
  cp "../src/commits/number_guess_c$1.sh" "./number_guess.sh"
  git add number_guess.sh
  git commit -m "$2"
}

# make the directory if it does not exist
mkdir -p number_guessing_game

# remove the .git folder if it exists
rm -rf number_guessing_game/.git
cd number_guessing_game
git init

# perform the 1st commit
commit_fn 1 "Initial commit"

# rename the branch to main
git branch -m master main

# create a feature branch
git checkout -b feat/game_mechanic

# perform the 2nd-4th commit
commit_fn 2 "feat: Add user input"
commit_fn 3 "feat: Add random number"
commit_fn 4 "feat: Add guessing element"

# merge commits 2-4 into main
git checkout main
git merge feat/game_mechanic

# create a feature branch
git checkout -b feat/data_persistence

# perform the 5th-9th commit
commit_fn 5 "feat: Add username"
commit_fn 6 "feat: Add game history"
commit_fn 7 "refactor: Function blocks"
commit_fn 8 "chore: Add comments"
commit_fn 9 "fix: Existing user with no previous games"

# merge commits 5-9 into main
git checkout main
git merge feat/data_persistence

# make the file executable
chmod +x number_guessing_game.sh

# copy the file as required by the project description
cp number_guessing_game.sh ../number_guessing_game.sh
