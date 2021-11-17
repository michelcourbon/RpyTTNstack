# RpyTTNstack

bash macro to install TTN stack on platform like Raspberry pi4 
OS = ubuntu server 64 bits

prerequis
- install Docker and docker-compose 
- install cfssl to generate certificates ($ sudo apt install golang-cfssl)

usage
- clone this respository
- run the "setup.sh" to create the environnement
- run "exec.sh" to configure the local TTS

finally start the local TTS 
$ docker-compose up

last step :  install this docker-compose as daemon... 

TODO : smtp configuration... tutorial and some documentation 
