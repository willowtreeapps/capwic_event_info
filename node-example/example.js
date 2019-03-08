/*
    Author: WillowTree Inc.
    Date: 03/08/19

    Description:
        This is a javascript node program that represents a component in a Rube
        Goldberg Machine. It beings by polling firebase for its trigger. Once
        triggered, it does something fun and then triggers the next component
        by uploading a document to firebase.

        Note: This program is incomplete. There are 4 TODOs for you to address ;)

    Usage:
        node example.js

    Dependencies:
        request (https://www.npmjs.com/package/request) (install w/ npm i request)
*/

const baseUrl = 'https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata'
const request = require('request')

// checkTrigger is called in a polling fashion (every 5 seconds). It fetches
// a document from firebase and checks it against a trigger condition. If the condition
// is met, it ends the polling and calls doFun() to kick off this component's special
// behavior.
function checkTrigger(doc) {
    const options = {
        headers: {
            'Cache-Control': 'no-cache'
        },
        json: true,
        url: `${baseUrl}/${doc}`
    }
    request(options, (err, res, body) => {
        if (err) { 
            return console.log(`check trigger failed with error: ${err}`) 
        }
        
        if (res.statusCode != 200) {
            return console.log(`check trigger received non-200 status code: ${res.statusCode}`)
        }

        console.log(`RECEIVED CHECK TRIGGER RESPONSE BODY: ${JSON.stringify(body)}`)
        if (body && body.trigger === 1) {   // TODO: CHANGE THIS LINE TO IMPLEMENT YOUR OWN CUSTOM CHECK
            clearInterval(intervalObj) // Important: Cancel the polling now that we've been triggered
            doFun()                    // Kick off the fun!
        } else {
            console.log('Trigger condition not yet met . . .')
        }
    })    
}

// doFun holds this component's special behavior. It is called from
// inside of checkTrigger() when the trigger condition passes (i.e.
// when the previous component triggers this one)
function doFun() {
    // TODO: Do some custom fun here
    console.log("fun!")

    // TODO: After the fun is over, trigger the next component by
    // calling sendTrigger with the name and body of a document to
    // upload to firebase.
    sendTrigger('team.json', {key: 0})
}

// sendTrigger uploads a document to firebase with the specified name and body.
// use this to trigger the next component in the Rube Goldberg Machine.
function sendTrigger(docName, docContents) {
    const options = {
        headers : {
            'Content-Type': 'application/json'
        },
        json: docContents,
        url: `${baseUrl}/${docName}`
    }

    request.put(options, (err, res, body) => {
        if (err) { 
            return console.log(`send trigger failed with error: ${err}`) 
        }
        
        if (res.statusCode != 200) {
            return console.log(`send trigger received non-200 status code: ${res.statusCode}`)
        }

        console.log(`RECEIVED SEND TRIGGER RESPONSE BODY: ${JSON.stringify(body)}`)
        console.log("Trigger Sent Successfully!")
    })
}

// The program starts here!

// setInterval schedules checkTrigger to be called every 5000ms with 'team.json'
// as a parameter (i.e. checkTrigger('team.json') gets called every 5 seconds).
// TODO: pass the name of the trigger document that we wish to fetch from firebase
// instead of team.json.
const intervalObj = setInterval(checkTrigger, 5000, 'team.json')
