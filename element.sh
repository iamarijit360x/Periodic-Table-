PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELEMENT_NAME=''
ELEMENT_SYMBOL=''
ELEMENT_ATOMIC_NUMBER=0
arg="$1"
LEN=${#arg}
if [[ $1 ]]
then
    if [[ $1 =~ ^[0-9]+$ ]]
    then
        ELEMENT_ATOMIC_NUMBER=$1
    elif [[ $LEN < 3 ]]
    then
        ELEMENT_SYMBOL=$1
        ELEMENT_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1'")
        
    else
        ELEMENT_NAME=$1
        ELEMENT_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name='$1'")
       
    fi
    ELEMENT_NAME=$($PSQL "select name from elements where atomic_number=$ELEMENT_ATOMIC_NUMBER")
    if [[ -z $ELEMENT_NAME  ]]
    then
        echo 'I could not find that element in the database.'
    else
        ELEMENT_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ELEMENT_ATOMIC_NUMBER")
        ELEMENT_TYPE=$($PSQL "select types.type from types inner join properties using(type_id) where properties.atomic_number=$ELEMENT_ATOMIC_NUMBER ")
        ELEMENT_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")
        MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")
        BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")  

        echo -e "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  

  
else
  echo -e "Please provide an element as an argument."
fi