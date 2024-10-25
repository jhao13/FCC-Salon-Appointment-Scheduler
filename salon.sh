#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n" 

#main menu that displays list of the services
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE"
    done
  
  #read from user to ask service choice
  read SERVICE_ID_SELECTED
  #service availability variable to check if service selection is within service table
  SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  #return to main menu list if service picked doesn't exist
  if [[ -z $SERVICE_AVAILABILITY ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  #else for if service picked exist
  else
    #prompt for phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #variable to check for if phone number belongs to existing customer on customers list
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # prompt for name if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new customer name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

      #ask them for time
      echo -e "\nWhat time would you like your $(echo $SERVICE_AVAILABILITY | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
      read SERVICE_TIME

      #insert appointment(creating a new customer_id variable)
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      
      #print appointment confirmation message
      echo -e "\nI have put you down for a $(echo $SERVICE_AVAILABILITY | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
    #else if customer exists
    else
      #ask them for time
      echo -e "\nWhat time would you like your $(echo $SERVICE_AVAILABILITY | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')?"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

      #print appointment confirmation message
      echo -e "\nI have put you down for a $(echo $SERVICE_AVAILABILITY | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
    fi
    
  fi

}
MAIN_MENU