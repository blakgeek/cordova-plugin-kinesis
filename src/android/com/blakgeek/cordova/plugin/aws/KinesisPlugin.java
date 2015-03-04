package com.blakgeek.cordova.plugin.aws;

import android.util.Log;
import com.amazonaws.auth.CognitoCachingCredentialsProvider;
import com.amazonaws.mobileconnectors.kinesis.kinesisrecorder.KinesisRecorder;
import com.amazonaws.regions.Regions;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.File;
import java.util.Arrays;
import java.util.List;

public class KinesisPlugin extends CordovaPlugin {

    private static final String LOGTAG = "KinesisPlugin";
    private static final List<String> SUPPORTED_ACTIONS = Arrays.asList(
            "initialize",
            "sendMessage"
    );
    private KinesisRecorder recorder;

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if (SUPPORTED_ACTIONS.contains(action)) {
            cordova.getThreadPool().execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        if ("initialize".equals(action)) {
                            init(args, callbackContext);
                        } else if ("sendMessage".equals(action)) {
                            sendMessage(args, callbackContext);
                        }
                    } catch (JSONException e) {
                        Log.d("Kinesis exception: ", e.getMessage());
                        callbackContext.error("json exception: " + e.getMessage());
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

    private void sendMessage(JSONArray args, CallbackContext callbackContext) throws JSONException {

        byte[] message = args.getString(0).getBytes();
        String streamName = args.getString(1);

        recorder.saveRecord(message, streamName);
        recorder.submitAllRecords();
        callbackContext.success();
    }

    private void init(JSONArray args, CallbackContext callbackContext) throws JSONException {

        String poolId = args.getString(0);
        Regions region = Regions.fromName(args.getString(1));
        String appName = args.optString(2, "KINESIS_RECORDER");

        CognitoCachingCredentialsProvider credentialsProvider = new CognitoCachingCredentialsProvider(
                cordova.getActivity(),
                poolId,
                region
        );

        File kinesisDirectory = cordova.getActivity().getDir(appName, 0);
        recorder = new KinesisRecorder(kinesisDirectory, region, credentialsProvider);
        callbackContext.success();
    }
}
