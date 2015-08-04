# Not to be executed directly. This is just an example for downloading files
# using telnet or netcat. Handy if you are in a state with limited resources.

# Telnet

(echo 'GET /'; echo; sleep 1; ) | telnet www.google.com 80

# netcat

/usr/bin/printf 'GET / \n' | nc www.google.com 80
