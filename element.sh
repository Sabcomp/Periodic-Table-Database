#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument is provided
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.

elif [[ $1 -eq 1 || $1 == H || $1 == Hydrogen ]]
then
  echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."

else 
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1';")
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1';")

  # if input is any other element in the database
  if [[ $ATOMIC_NUMBER || $SYMBOL || $NAME ]]
  then
    if [[ $ATOMIC_NUMBER ]]
    then
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
    elif [[ $SYMBOL ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL';")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL';")
    elif [[ $NAME ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME';")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME';")
    fi

    # get other data for the element
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  
  else
    # if input does not exist as an atomic number, symbol, or name in the database
    echo I could not find that element in the database.
  fi
fi