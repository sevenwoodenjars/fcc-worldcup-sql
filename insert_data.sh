#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    #get winning team_id
    WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found 
    if [[ -z $WIN_TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    
    fi

    #get losing team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $TEAM_ID ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi

    WINNING_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    INSERT_INTO_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNING_TEAM, $OPPONENT_TEAM, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_INTO_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into Games
    fi

  fi

done
