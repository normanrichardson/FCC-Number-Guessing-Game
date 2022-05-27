
CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(40) UNIQUE NOT NULL);

CREATE TABLE games(
  game_id SERIAL PRIMARY KEY,
  num_guess INT,
  user_id INT);

ALTER TABLE games ADD FOREIGN KEY(user_id) REFERENCES users(user_id);
