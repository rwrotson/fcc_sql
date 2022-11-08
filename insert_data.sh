#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do

  if [[ $WINNER != "winner" ]]
  then 
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
  
    if [[ -z $WINNER_ID ]]
    then
    RESULT_INSERT_WINNER=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    fi

  fi  
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do

  if [[ $OPPONENT != 'opponent' ]]
    then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # If not found:
    if [[ -z $OPPONENT_ID ]]
    then ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  if [[ $YEAR != "year" ]]
  then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  echo $WINNER_ID
  echo LOG_GAME=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID','$OPPONENT_ID',$WG,$OG)")
  fi
done
