package de.seemoo.pairsonic

import android.util.Log
import de.seemoo.pairsonic.channels.AudioControlChannel
import de.seemoo.pairsonic.channels.LocationServiceChannel
import de.seemoo.pairsonic.channels.WifiP2pChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

const val CHANNEL_AUDIOCONTROL = "audiocontrol"
const val CHANNEL_GPWIFIP2P = "gp_wifip2p"
const val CHANNEL_LOCATION_SERVICE = "location_service"

class MainActivity : FlutterActivity() {
    private val CHANNEL_AUDIOCONTROL = "audiocontrol"
    private var wifiP2pChannel: WifiP2pChannel? = null
    private var audioControlChannel: AudioControlChannel? = null
    private var locationServiceChannel: LocationServiceChannel? = null

    private val logTag = "MainActivity"

    override fun onResume() {
        super.onResume()
        Log.d(logTag, "onResume")
    }

    override fun onPause() {
        super.onPause()
        Log.d(logTag, "onPause")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()

        // audiocontrol implementation
        audioControlChannel = AudioControlChannel(
            this,
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_AUDIOCONTROL,
                StandardMethodCodec.INSTANCE,
                taskQueue
            )
        )

        // wifip2pimplementation audiocontrol implementation
        wifiP2pChannel = WifiP2pChannel(
            this,
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_GPWIFIP2P,
                StandardMethodCodec.INSTANCE,
                taskQueue
            )
        )

        locationServiceChannel = LocationServiceChannel(
            this,
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_LOCATION_SERVICE
            )
        )
    }
}
