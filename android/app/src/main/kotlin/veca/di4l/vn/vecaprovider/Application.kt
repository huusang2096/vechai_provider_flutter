package veca.di4l.vn.vecaprovider


import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import android.content.Context

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun registerWith(p0: PluginRegistry?) {
    }

    override fun onCreate() {
        super.onCreate()
    }
}