# Capwic Collaborative Code Jam Information

Hello and welcome to the first ever `Capwic Collaborative Code Jam` hosted by WillowTree and JMU!

## Idea of the event
We're all going to try to build a digital-ish [Rube Goldberg Machine](https://www.youtube.com/watch?v=RBOqfLVCDv8) together. So one person/team will start the chain and then it will chain all the way to the end where we'll trigger a celebratory video 

## Day Of Details
First 15 minutes:
* Split into teams (a team of 1 is fine)
* Find a team to consume data from
* Find a different team to consume your data
* **MAKE SURE YOU AGREE ON WHAT THE TRIGGER IS**
  * In other words - a team will need to create data - but you'll need to know what to trigger off of to start your action. We're recommending that you senda GET request to this URL (https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/capwic_willowtree.json) and listen for your team name  ```{"trigger":"my_team"}``` and then change it to the next team when your program is done ```{"trigger":"next_team"}```

Next 1.75 hours:
* Build anything that you have the skills to create. It doesn't have to have a UI but we encourage you to build something fun to look at since that'll make the chain more engaging
** Feel free to use projects you've already made for other purposes and retrofit them to work for the challenge

Starting at the end of Hour 2:
* We'll start trying to run the full chain. Hopefully it'll work the first time but if not we have an hour! We can do it!

# FAQ

## Can I use something I've already built before today?
Absolutely! This is about working together to build something fun so shortcuts are encouraged! Honestly, the more familiar you are with it, the better.

## What are the requirements around what I can build?
**The only requirement we have is that your total creation should run shorter than a minute.**
We don't want to be strict - use your imagination!
* You can use any language or framework
* You can even use fun physical interactions (Just have a line of people where one highfive leads to another highfive and so one until finally it leads to someone pressing enter on a keyboard)

## How can I get data from a different team?
Here's what we recommend that most people do. You can come up with your own method for coordinating if you want to be creative though! (Note that JMU's wireless network limits computer->computer communication so keep that in mind)
1) Agree on what your team name is. You'll use it in the api calls below
2) Agree on what the next team's name is.
3) Make these calls below (substitute the team names) and make sure it's working
** IMPORTANT! Please keep api requests to a minimum of every 5 seconds - if we go lower we may hit API request limits...**
Getting Data:
```
curl -X GET \
  'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/capwic_willowtree.json' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache'
```

Uploading Data:
```
curl -X PUT \
  'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/capwic_willowtree.json' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{ "trigger": "<next_team_name_here>" }'
```

# I need some ideas - I'm not sure what to build
No problem! Here are some random ideas that we've come up with: 
(Note that these are mostly random and silly but please feel free to do something that represents who you are or the story you want to tell)
* An Android app that counts down
* An iOS app that has a character walk around a maze
* A python script that displays the matrix for 10 seconds
* A selinium project that navigates to a funny picture of a cat on google photos
* A website that shakes around for a duration of 10 seconds
* A real life, in person, rock/paper/scissors tournament where the loser gets upset and bangs their head against the keyboard triggering the next event

# I'm too new at this - do you have an example project already set up?
We do! Note that you'll need to tweak the triggers to do what we suggest above. Feel free to reach out to someone from WillowTree for help!
* Here's a sample android project: https://github.com/willowtreeapps/capwic-android
* Here's a sample bash script: https://github.com/willowtreeapps/capwic_event_info/blob/master/example.sh
* Here's a sample golang script: https://github.com/willowtreeapps/capwic_event_info/blob/master/example.go
* Here's a sample iOS project: https://github.com/willowtreeapps/capwic_event_info/blob/master/iOS_Example
* Here's a sample node project: https://github.com/willowtreeapps/capwic_event_info/blob/master/node-example
* Here's a sample perl script: https://github.com/willowtreeapps/capwic_event_info/blob/master/example.pl
* Here's a sample python script: https://github.com/willowtreeapps/capwic_event_info/blob/master/example.py
