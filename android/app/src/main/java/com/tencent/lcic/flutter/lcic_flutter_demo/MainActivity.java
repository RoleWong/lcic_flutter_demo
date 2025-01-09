package com.tencent.lcic.flutter.lcic_flutter_demo;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.tencent.tcic.TBSSdkManageCallback;
import com.tencent.tcic.TCICClassConfig;
import com.tencent.tcic.TCICConstants;
import com.tencent.tcic.TCICManager;
import com.tencent.tcic.pages.TCICClassActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "lcic_sdk";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("initX5Core")) {
                        String licenseKey = call.argument("licenseKey");
                        initX5Core(licenseKey, result);
                    } else if (call.method.equals("joinClass")) {
                        int schoolId = call.argument("schoolId");
                        int classId = call.argument("classId");
                        String userId = call.argument("userId");
                        String token = call.argument("token");
                        joinClass(schoolId, classId, userId, token, result);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void initX5Core(String licenseKey, MethodChannel.Result result) {
        TCICManager.getInstance().initX5Core(licenseKey, new TBSSdkManageCallback() {
            @Override
            public void onCoreInitFinished() {}

            @Override
            public void onViewInitFinished(boolean isX5Core) {
                if (isX5Core) {
                    result.success("INIT_SUCCEED"); // X5 内核初始化成功
                } else {
                    result.error("INIT_FAILED", "X5 kernel initialization failed", null);
                }
            }
        });
    }

    private void joinClass(int schoolId, int classId, String userId, String token, MethodChannel.Result result) {
        Intent intent = new Intent(this, TCICClassActivity.class);
        Bundle bundle = new Bundle();
        TCICClassConfig initConfig = new TCICClassConfig.Builder()
                .schoolId(schoolId)
                .classId(classId)
                .userId(userId)
                .token(token)
                .build();
        bundle.putParcelable(TCICConstants.KEY_INIT_CONFIG, initConfig);
        intent.putExtras(bundle);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        startActivity(intent);
        result.success(null); // 加入课堂成功
    }
}
