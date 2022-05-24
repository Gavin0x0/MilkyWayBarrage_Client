package com.idealbroker.milkyway;

import android.os.Bundle;
import com.baidu.mobstat.StatService;
import com.xiaomi.market.sdk.XiaomiUpdateAgent;

import io.flutter.embedding.android.FlutterActivity;

public final class MainActivity extends FlutterActivity {
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        XiaomiUpdateAgent.update(this);
    }

    protected void onResume() {
        super.onResume();
        StatService.onResume(this);
    }

    protected void onPause() {
        super.onPause();
        StatService.onPause(this);
    }
}
