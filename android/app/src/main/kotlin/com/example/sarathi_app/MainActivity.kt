package com.example.sarathi_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        println("SARATHI_DEBUG: configureFlutterEngine started")
        super.configureFlutterEngine(flutterEngine)
        println("SARATHI_DEBUG: GeneratedPluginRegistrant called")
    }
}
