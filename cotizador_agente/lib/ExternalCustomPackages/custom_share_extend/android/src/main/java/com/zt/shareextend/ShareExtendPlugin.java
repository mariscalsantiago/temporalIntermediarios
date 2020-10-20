package com.zt.shareextend;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import androidx.core.content.PermissionChecker;


import java.io.File;
import java.util.Map;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Plugin method host for presenting a share sheet via Intent
 */
public class ShareExtendPlugin implements MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    /// the authorities for FileProvider
    private static final int CODE_ASK_PERMISSION = 100;
    private static final int WRITE_EXTERNAL_STORAGE_CODE = 0;
    private static final String CHANNEL = "custom_share_extend";

    private final Registrar mRegistrar;
    private String text;
    private String type;
    private List<String>  list;
    private ArrayList pathList;
    boolean status;

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        final ShareExtendPlugin instance = new ShareExtendPlugin(registrar);
        registrar.addRequestPermissionsResultListener(instance);
        channel.setMethodCallHandler(instance);
    }


    private ShareExtendPlugin(Registrar registrar) {
        this.mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("share")) {
            if (!(call.arguments instanceof Map)) {
                throw new IllegalArgumentException("Map argument expected");
            }
            // Android does not support showing the share sheet at a particular point on screen.
            share2((List) call.argument("list"), (String) call.argument("type"));
            result.success(null);
        } else if (call.method.equals("share_multi")) {
            if (!(call.arguments instanceof Map)) {
                throw new IllegalArgumentException("Map argument expected");
            }
            // Android does not support showing the share sheet at a particular point on screen.
            shareMulti((ArrayList) call.argument("fileList"),(String) call.argument("text"), (String) call.argument("type"));
            result.success(null);
        }else if (call.method.equals("download_gallery_multi")) {
            if (!(call.arguments instanceof Map)) {
                throw new IllegalArgumentException("Map argument expected");
            }
            downloadGalleryMulti((ArrayList) call.argument("fileList"));
            result.success(null);
        } else if (call.method.equals("get_permissions")) {
            getPermissions();
            result.success(status);
        } else {
            result.notImplemented();
        }
    }

    private void share2(List<String> list, String type) {

        if (list == null || list.isEmpty()) {
            throw new IllegalArgumentException("Non-empty list expected");
        }
        this.list = list;
        this.text = this.list.get(0);
        this.type = type;

        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        if ("text".equals(type)) {
            shareIntent.putExtra(Intent.EXTRA_TEXT, text);
            shareIntent.setType("text/plain");
        } else {
            File f = new File(text);
            if (!f.exists()) {
                throw new IllegalArgumentException("file not exists");
            }

            if (ShareUtils.shouldRequestPermission(text)) {
                if (!checkPermisson()) {
                    requestPermission();
                    return;
                }
            }

            Uri uri = ShareUtils.getUriForFile(mRegistrar.activity(), f, type);

            if ("image".equals(type)) {
                shareIntent.setType("image/*");
            } else if ("video".equals(type)) {
                shareIntent.setType("video/*");
            } else {
                shareIntent.setType("application/*");
            }
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
        }

        Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
        if (mRegistrar.activity() != null) {
            mRegistrar.activity().startActivity(chooserIntent);
        } else {
            chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mRegistrar.context().startActivity(chooserIntent);
        }
    }

    private void shareMulti(ArrayList pathList, String text, String type) {
        if (text == null || text.isEmpty()) {
            throw new IllegalArgumentException("Non-empty text expected");
        }
        if (pathList == null || pathList.isEmpty()) {
            throw new IllegalArgumentException("Non-empty text expected");
        }

        this.text = text;
        this.pathList = pathList;
        this.type = type;

        ArrayList<Uri> urisList = new ArrayList<Uri>();
        ArrayList<String> fileList = pathList;
        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND_MULTIPLE);
        if ("text".equals(type)) {
            shareIntent.putExtra(Intent.EXTRA_TEXT, text);
            shareIntent.setType("text/plain");
        } else {
            for(int i=0; i < fileList.size(); i++){
                File f = new File(fileList.get(i));
                if (!f.exists()) {
                    throw new IllegalArgumentException("file not exists");
                }
                if (ShareUtils.shouldRequestPermission(text)) {
                    if (!checkPermisson()) {
                        requestPermission();
                        return;
                    }
                }
                Uri uri = ShareUtils.getUriForFile(mRegistrar.activity(), f, type);
                urisList.add(uri);
            }
            shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, urisList);
            shareIntent.setType("image/*");
        }

        Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
        if (mRegistrar.activity() != null) {
            mRegistrar.activity().startActivity(chooserIntent);
        } else {
            chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mRegistrar.context().startActivity(chooserIntent);
        }
    }

    private void downloadGalleryMulti(ArrayList pathList) {





    }

    private void getPermissions() {
        status = false;
        if (hasPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            status = true;
        } else {
            ActivityCompat.requestPermissions(mRegistrar.activity(), new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, WRITE_EXTERNAL_STORAGE_CODE);
        }

    }

    private boolean hasPermission(String permission) {
        return ContextCompat.checkSelfPermission(mRegistrar.activity(), permission) == PermissionChecker.PERMISSION_GRANTED;
    }

    private boolean checkPermisson() {
        if (ContextCompat.checkSelfPermission(mRegistrar.context(), Manifest.permission.WRITE_EXTERNAL_STORAGE)
                == PackageManager.PERMISSION_GRANTED) {
            return true;
        }
        return false;
    }

    private void requestPermission() {
        ActivityCompat.requestPermissions(mRegistrar.activity(), new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},CODE_ASK_PERMISSION);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] perms, int[] grantResults) {
        if (requestCode == CODE_ASK_PERMISSION && grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            share2(list, type);
            return true;
        } else if (requestCode == WRITE_EXTERNAL_STORAGE_CODE && grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            status = true;
            return true;
        } else{
            return false;
        }
        //return status;
    }
}
