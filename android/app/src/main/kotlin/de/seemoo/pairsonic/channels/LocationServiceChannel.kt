package de.seemoo.pairsonic.channels

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.location.LocationManager
import android.provider.Settings
import androidx.core.location.LocationManagerCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/// This channel is required to check if location services are enabled on the device.
/// Otherwise, WiFiP2P connections won't work.
class LocationServiceChannel(
    private val activity: Activity,
    channel: MethodChannel,
) : MethodChannel.MethodCallHandler {
    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "is_location_service_enabled" -> {
                val locationManager = activity.getSystemService(Context.LOCATION_SERVICE) as LocationManager
                val isEnabled = LocationManagerCompat.isLocationEnabled(locationManager)
                result.success(isEnabled)
            }
            "open_settings" -> {
                val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                activity.startActivity(intent)
            }
        }
    }
}