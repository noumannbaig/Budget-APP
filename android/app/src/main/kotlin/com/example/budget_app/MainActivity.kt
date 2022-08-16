package com.example.budget_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Telephony
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {

//    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
//
//    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val smsReceiver = object:EventChannel.StreamHandler,BroadcastReceiver(){
            var eventSink: EventChannel.EventSink? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            override fun onReceive(p0: Context?, p1: Intent?) {
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){
                    for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
                        eventSink?.success(sms.displayMessageBody)
                    }
                }
            }
        }
        registerReceiver(smsReceiver,IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger,"com.example.app/budget_app")
                .setStreamHandler(smsReceiver)

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.example.app/budget_app").setMethodCallHandler {
//        call, result ->
//            if(call.method == "receive_sms"){
//                val smsReceiver = object: BroadcastReceiver(){
//                    override fun onReceive(p0: Context?, p1: Intent?) {
//                        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){
//                            for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
//                                result.success(sms.displayMessageBody)
//                                unregisterReceiver(this)
//                            }
//                        }
//                    }
//                }
//                registerReceiver(smsReceiver, IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
//            }else{
//                result.notImplemented()
//            }
//        }
    }
}
