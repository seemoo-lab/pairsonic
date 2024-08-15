package de.seemoo.pairsonic

import android.app.PendingIntent
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import de.seemoo.pairsonic.channels.*

class MainActivity : FlutterActivity() {
    private val CHANNEL_AUDIOCONTROL = "audiocontrol"
    private val CHANNEL_GPWIFIP2P = "gp_wifip2p"

    private val TAG = "MainActivity"

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
        val intent = Intent(context, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
    }

    private var audioControlChannel: AudioControlChannel? = null;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
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
        val wifiP2pChannel = WifiP2pChannel(
            this,
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL_GPWIFIP2P,
                StandardMethodCodec.INSTANCE,
                taskQueue
            )
        )
    }
}
