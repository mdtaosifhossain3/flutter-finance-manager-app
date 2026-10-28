package com.finzycash.expensebudgetmanager



import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine

import android.os.Bundle

import android.util.Log

import android.app.Application

import io.flutter.plugin.common.MethodChannel



class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"
    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        // App signature helper for SMS verification

        val appSignatureHelper = AppSignatureHelper(this)

        for (signature in appSignatureHelper.appSignatures) {

            Log.d("AppSignatureHelper", "Hash: $signature")

        }
    }


}