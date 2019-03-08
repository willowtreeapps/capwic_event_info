package main

/*

Author: WillowTree Inc.
Date: 03/07/19

Description:
	This go program represents a component in a Rube Goldberg Machine. First, it polls
	firebase until a condition is met. Then, once triggered, this program does some
	custom fun behavior and then pushes a document to firebase to trigger the next
	component in the machine.

	Note: This program is incomplete. There are 4 TODOs for you to address below ;)

Usage:
	go run example.go
*/

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

const (
	baseURL = "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata"
)

// main is the program's entry point
func main() {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	// This section of the code kicks off a polling job that checks firebase
	// every 5 seconds. When a document matching our custom condition is met,
	// we send a message on the 'done' channel and the program proceeds.
	done := make(chan bool, 1)
	go poll(client, "team.json", done) // TODO: type in the name of the document you wish to fetch from firebase (your trigger)
	<-done                             // block until we get triggered (which is detected by polling)

	// TODO: Do something fun here!
	fmt.Println("Do The Fun 🤠")

	// send trigger to kick off the next component in the machine
	// TODO: type in the name of the document you wish to upload to firebase (the next component's trigger)
	// along with the contents of the document formatted as a map[string]interface{}
	if err := sendTrigger(client, "team.json", map[string]interface{}{"trigger": 0}); err != nil {
		fmt.Printf("Send Trigger Failed! %v", err)
	} else {
		fmt.Printf("Trigger Sent!\n")
	}
}

// poll runs a job every 5 seconds that calls checkTrigger and
// processes the results. It notifies the main thread by way of
// the 'done' channel when the trigger check finally succeeds.
func poll(client *http.Client, doc string, done chan<- bool) {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()
	for range ticker.C {
		if triggered, err := checkTrigger(client, doc); err != nil {
			fmt.Printf("Check Trigger encountered error: %v\n", err)
		} else if !triggered {
			fmt.Println("Trigger condition not yet met . . .")
		} else {
			// we've been triggered! Notify the main thread and break out
			// of this endless loop.
			done <- true
			break
		}
	}
}

// checkTrigger reads the specified document from firebase and
// returns true, nil if it meets our custom condition.
func checkTrigger(client *http.Client, doc string) (bool, error) {
	url := baseURL + "/" + doc
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return false, fmt.Errorf("unable to create request: %v %v", url, err)
	}
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Cache-Control", "no-cache")
	resp, err := client.Do(req)
	if err != nil {
		return false, fmt.Errorf("network error: %v", err)
	}

	defer resp.Body.Close()
	if resp.StatusCode != 200 {
		return false, fmt.Errorf("non 200 status code: %d", resp.StatusCode)
	}

	decoder := json.NewDecoder(resp.Body)
	var result map[string]interface{}
	if err := decoder.Decode(&result); err != nil {
		return false, fmt.Errorf("decode error: %v", err)
	}

	// TODO: Check whether the trigger condition is met!
	if value, ok := (result["trigger"]).(float64); ok && value == 1 {
		return true, nil
	}

	return false, nil
}

func sendTrigger(client *http.Client, doc string, content map[string]interface{}) error {
	url := baseURL + "/" + doc

	jsonBytes, err := json.Marshal(content)
	if err != nil {
		return fmt.Errorf("Unable to marshal content: %v", err)
	}

	req, err := http.NewRequest("PUT", url, bytes.NewBuffer(jsonBytes))
	if err != nil {
		return fmt.Errorf("Unable to create request: %v", err)
	}

	req.Header.Add("Content-Type", "application/json")
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("network error: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("received non-200 status code: %v", resp.StatusCode)
	}

	// drain the response body so that the connection gets released back to the system
	_, _ = ioutil.ReadAll(resp.Body)
	return nil
}
