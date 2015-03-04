package com.blakgeek.cordova.plugin.aws;

import android.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class KinesisPlugin extends CordovaPlugin {

    private static final String LOGTAG = "KinesisPlugin";
    private static final List<String> SUPPORTED_ACTIONS = Arrays.asList(
            "initialize",
            "logEvent",
            "endTimedEvent",
            "logPageView",
            "logError",
            "setLocation"
    );


    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if(SUPPORTED_ACTIONS.contains(action)) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        if ("initialize".equals(action)) {
                            init(args, callbackContext);
                        } else if ("logEvent".equals(action)) {
                            logEvent(args, callbackContext);
                        } else if ("endTimedEvent".equals(action)) {
                            endTimedEvent(args, callbackContext);
                        } else if ("logPageView".equals(action)) {
                            logPageView(args, callbackContext);
                        } else if ("logError".equals(action)) {
                            logError(args, callbackContext);
                        } else if ("setLocation".equals(action)) {
                            setLocation(args, callbackContext);
                        }
                    } catch (JSONException e) {
                        Log.d("Flurry exception: ", e.getMessage());
                        callbackContext.error("flurry json exception: " + e.getMessage());
                    }
                }
            });
            return true;
        } else {
            Log.d(LOGTAG, "Invalid Action: " + action);
            callbackContext.error("Invalid Action: " + action);
            return false;
        }
    }

    private Map<String, String> jsonObjectToMap(JSONObject json) throws JSONException {
        if (json == null) {
            Log.d(LOGTAG, "not json");
            return null;
        }
        @SuppressWarnings("unchecked")
        Iterator<String> nameItr = json.keys();
        Map<String, String> params = new HashMap<String, String>();
        while (nameItr.hasNext()) {
            String name = nameItr.next();
            params.put(name, json.getString(name));
        }
        return params;
    }
}
