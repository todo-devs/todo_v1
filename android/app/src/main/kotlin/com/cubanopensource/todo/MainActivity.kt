package com.cubanopensource.todo

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "todoappchannel_android"
    lateinit var preferences: SharedPreferences
    lateinit var wifiManager: WifiManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        preferences = applicationContext.getSharedPreferences("${packageName}_preferences", Activity.MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            when {
                call.method == "getDrawPermissionState" -> result.success(getDrawPermissionState())
                call.method == "reqDrawPermission" -> reqDrawPermission()
                call.method == "getShowWidgetPreference" -> result.success(getShowWidgetPreference())
                call.method == "getTurnOffWifiPreference" -> result.success(getTurnOffWifiPreference())
                call.method == "setFalseShowWidget" -> setFalseShowWidget()
                call.method == "setFalseTurnOffWifi" -> setFalseTurnOffWifi()
                call.method == "setTrueShowWidget" -> setTrueShowWidget()
                call.method == "setTrueTurnOffWifi" -> setTrueTurnOffWifi()
                call.method == "turnOnWifi" -> turnOnWifi()
                call.method == "turnOffWifi" -> turnOffWifi()
                call.method == "isWifiEnabled" -> result.success(isWifiEnabled())
                else -> result.notImplemented()
            }
        }

        wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        startService(Intent(this, FloatingWindow::class.java))
    }

    private fun turnOnWifi() {
        wifiManager.isWifiEnabled = true
    }

    private fun turnOffWifi() {
        if (getTurnOffWifiPreference())
            wifiManager.isWifiEnabled = false
    }

    private fun isWifiEnabled(): Boolean {
        return wifiManager.isWifiEnabled
    }

    private fun getTurnOffWifiPreference(): Boolean {
        return preferences.getBoolean("turnOffWifi", true)
    }

    private fun getShowWidgetPreference(): Boolean {
        return preferences.getBoolean("showWidget", true)
    }

    private fun setFalseTurnOffWifi() {
        with(preferences.edit()) {
            putBoolean("turnOffWifi", false)
            apply()
        }
    }

    private fun setFalseShowWidget() {
        with(preferences.edit()) {
            putBoolean("showWidget", false)
            apply()
        }
    }

    private fun setTrueTurnOffWifi() {
        with(preferences.edit()) {
            putBoolean("turnOffWifi", true)
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
