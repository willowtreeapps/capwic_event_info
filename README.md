# Capwic Collaborative Code Jam Information

Hello and welcome to the first ever `Capwic Collaborative Code Jam` hosted by WillowTree and JMU!

## Idea of the event
We're all going to try to build a digital-ish [Rube Goldberg Machine](https://www.youtube.com/watch?v=Qtp9Aur8zNU) together. So one person/team will start the chain and then it will chain all the way to the end where we'll trigger [TODO figure this out] 

## Day Of Details
First 15 minutes:
* Split into teams (a team of 1 is fine)
* Find a team to consume data from
* Find a different team to consume your data

Next 1.75 hours:
* Build anything that you have the skills to create. It doesn't have to have a UI but we encourage you to build something fun to look at since that'll make the chain more enganging

Starting at the end of Hour 2:
* We'll start trying to run the full chain. Hopefully it'll work the first time but if not we have an hour so we can do it!

## What are the requirements around what I can build?
**The only requirement we have is that your total creation should run shorter than a minute.**
We don't want to be strict - use your imagination!
* You can use any language or framework
* You can even use fun physical interactions (Just have a line of people where one highfive leads to another highfive which finally leads to someone pressing enter on a keyboard)

## How can I get data from a different team?
**We're hoping teams will come up with creative solutions for this!**

HOWEVER - if you need a fallback then here is a fallback that you can do:
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
