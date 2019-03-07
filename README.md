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
** In other words - a team will need to create data - but you'll need to know what to trigger off of to start your action. An easy thing to do would be to post an object like this ```{"status":"off"}``` and then change it to this when it's ready ```{"status":"on"}```

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
**We're hoping teams will come up with creative solutions for this!**

HOWEVER - if you need a fallback then here is a fallback that you can do:
1) Agree on what the team name is where you're getting you data from. You'll use it in the api calls below
2) Agree on what the data will look like (What is the Json Format)
3) Agree on how the data will change so your script knows it's new! (Maybe a boolean that is false until the official run-through)
3) Make these calls below (substitute the team names) and make sure it's working
** IMPORTANT! Please keep api requests to a minimum of every 5 seconds - if we go lower we may hit API request limits...**
Getting Data:
```
curl -X GET \
  'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/<their_team_here>.json' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache'
```

Uploading Data:
```
curl -X POST \
  'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/<their_team_here>.json' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
  "any_json": {
    "data": "and values",
    "you_want": "here"
  }
}'
```

# I need some ideas - I'm not sure what to build
No problem! Here are some random ideas that we've come up with:
* An Android app that counts down
* An iOS app that has a character walk around a maze
* A python script that displays the matrix for 10 seconds
* A selinium project that navigates to a funny picture of a cat on google photos
* A website that shakes around for a duration of 10 seconds

# I'm too new at this - do you have an example project already set up?
* Here's a sample android project: https://github.com/willowtreeapps/capwic-android
* Here's a sample perl script: https://github.com/willowtreeapps/capwic_event_info/blob/master/example.pl
