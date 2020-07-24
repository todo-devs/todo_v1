package com.cubanopensource.todo

import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "todoappchannel_android"
    lateinit var preferences: SharedPreferences

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        preferences = applicationContext.getSharedPreferences("${packageName}_preferences", Activity.MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            when {
                call.method == "getDrawPermissionState" -> result.success(getDrawPermissionState())
                call.method == "reqDrawPermission" -> result.success(reqDrawPermission())
                call.method == "getShowWidgetPreference" -> result.success(getShowWidgetPreference())
                call.method == "setFalseShowWidget" -> result.success(setFalseShowWidget())
                call.method == "setTrueShowWidget" -> result.success(setTrueShowWidget())
                else -> result.notImplemented()
            }
        }

        startService(Intent(this, FloatingWindow::class.java))
    }

    private fun getShowWidgetPreference(): Boolean {
        return preferences.getBoolean("showWidget", true)
    }

    private fun setFalseShowWidget() {
        with(preferences.edit()) {
            putBoolean("showWidget", false)
            apply()
        }
    }

    private fun setTrueShowWidget() {
        with(preferences.edit()) {
            putBoolean("showWidget", true)
            apply()
        }
    }

    private fun getDrawPermissionState(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            return (Settings.canDrawOverlays(this))

        return true
    }

    private fun reqDrawPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${packageName}"))
            startActivityForResult(intent, 1)
        }
    }
}
