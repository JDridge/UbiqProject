# Converge

# About 
This application is designed to make it convenient for multiple people to find locations with the shortest
distance between everybody. The app calculates the midway point between all the users and finds all of
the places that fits the user-inputted category, like “bars” or “food”.

# Functionality
The functionality is simple, straight-forward and robust. There is a user registration system that utilizes
the Parse database. We use the Yelp API to provide more details about each location with addresses,
phone numbers, etc. We use Apple Maps to calculate and navigate the users to the locations. We also
use email notifications for users to communicate and interact with each other. We also save the history
of all the locations that have been traveled to.

# Architecture
Converge uses Core Location, Map Kit, Parse, and Mailgun. Core Location and Map Kit are for the map
portion of the app where we calculate the halfway point. Parse is used for user registration and back
end. Mailgun is used to send emails to the users.

# User Interface Design
The app is structured in a very clear and cohesive way, with each screen having a purpose and direction.
For instance, the login screen has a few clearly labeled text boxes so the user knows what is happening.
Everything is also simple and easy to use. All options and available functions are visible to the user and if
they make a wrong step, we account for all incorrect inputs and output error messages. 

# Screenshots 
## [Click here for screenshots!](screenshots.md)
