package com.idealbroker.milkyway;

import com.baidu.mobstat.StatService;
import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        StatService.start(this);
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
    }
}