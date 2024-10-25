# FCC-Salon-Appointment-Scheduler
Project for the FreeCodeCamp Relational Databases Certification.

For this project, I created an interactive Bash script program that uses PostgreSQL to manage customers and appointments for a salon.

Steps in the program:

1) Asks the user to select a Salon Service from the list
2) If service picked doesn't exist, it will show the same list of services again for the user to pick
3) Asks the user for a phone number after they pick a service
4) Detects if the phone number belongs to a customer in the database
5) Asks for a name if phone number doesn't exist and adds the new customer into the database
6) Asks for appointment time for the service
7) Adds appintment time into the database
