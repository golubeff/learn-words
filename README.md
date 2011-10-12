Learn words
===========

Deploy this app to your local Mac and it will remind you foreign words to learn. 
It uses Growl to send notifications and embedded Mac OS X speech engine.

Installation
------------

* Install [http://growl.info/](Growl)
* Install Mac OS X Multi-Lingual Voices: (System Preferences -> Speech -> Text
  to Speech -> System Voice -> Customize)
* Create config/database.yml
* Run server:

    ./script/rails s

* Navigate to http://localhost:3000/ to fill database with words
* Start reminder in background: 

    nohup ~/learn-words/script/rails runner 'Word.start' &

* Alter crontab config to start application with system boot:

    crontab -e

    @reboot nohup /bin/bash -c "~/learn-words/script/rails  runner 'Word.start'" 

