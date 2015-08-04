#!/bin/bash

# Script for testing a simple REST service's ability to receive JSON POST requests

curl -H "Content-Type: application/json" -X POST -d \
'{"first_name": "Joe", "last_name": "Smith", "userid": "jsmith", "groups": ["admins", "users"]}' \
http://localhost:5000/users
