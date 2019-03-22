package com.willowtree.capwic;

import com.google.gson.Gson;
import okhttp3.*;

public class Main {

    private static final String ENDPOINT = "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata/capwic_willowtree.json";

    public static void main(String[] args) {
        listenForTrigger();
        triggerEvent();
        triggerNextTeam();
    }

    private static void listenForTrigger() {
        // Create request for remote resource.
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url(ENDPOINT)
                .build();

        while(true) {
            // Execute the request and retrieve the response.
            try (Response response = client.newCall(request).execute()) {

                //Extract the trigger from the response
                String responseString = response.body().string();
                Trigger triggerObj = new Gson().fromJson(responseString, Trigger.class);

                //TODO change this to be your team name
                String previousTeam = "INSERT_TEAM_HERE";

                System.out.println("Looking for our team: "+previousTeam);
                System.out.println("Found this payload: "+responseString);

                //Compare the trigger to your team name.
                //If it matches then exit the loop!
                if(previousTeam.equalsIgnoreCase(triggerObj.trigger)) {
                    break;
                }

                //If it doesn't match then sleep for 5 seconds
                Thread.sleep(5 * 1000);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * This method is where you do whatever you want!
     */
    private static void triggerEvent() {
        //TODO Do something fun! Whatever you want!
    }

    /**
     * This method will trigger the next team
     */
    private static void triggerNextTeam() {
        OkHttpClient client = new OkHttpClient();

        //TODO set this to be the next team!
        Trigger nextTeam = new Trigger();
        nextTeam.trigger = "nextTeam";

        //Actually upload the payload
        Request request = new Request.Builder()
                .put(RequestBody.create(MediaType.parse("application/json; charset=utf-8"), new Gson().toJson(nextTeam)))
                .url(ENDPOINT)
                .build();
            // Execute the request and retrieve the response.
            try (Response response = client.newCall(request).execute()) {
                System.out.println("If you see this then it worked!");
            } catch (Exception e) {
                e.printStackTrace();
            }
    }
}
