package de.seemoo.pairsonic.channels

import java.io.IOException
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import android.media.AudioManager
import android.media.AudioFocusRequest
import android.media.AudioAttributes

class AudioControlChannel(
    private val context: Context,
    private val channel: MethodChannel
) : MethodChannel.MethodCallHandler {

    init {
        channel.setMethodCallHandler(this)
    }

    private var audioFocusRequest: AudioFocusRequest? = null;

    /// Handle the incoming method call for the audiocontrol channel.
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "get_max_volume" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                result.success(audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC))
            }
            "get_current_volume" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                result.success(audioManager.getStreamVolume(AudioManager.STREAM_MUSIC))
            }
            "set_volume" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                val volume: Int = call.argument("volume")!!
                try {
                    audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, AudioManager.FLAG_PLAY_SOUND)
                    result.success(true)
                } catch (e: SecurityException) {
                    result.success(false)
                }
            }
            "request_focus" -> {
                if (Build.VERSION.SDK_INT < 26) {
                    result.success(false)
                    return
                }
                if (audioFocusRequest == null) {
                    val playbackAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                    audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                        .setAudioAttributes(playbackAttributes)
                        .setAcceptsDelayedFocusGain(false)
                        .build()
                }
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                val res = audioManager.requestAudioFocus(audioFocusRequest!!)
                result.success(res == AudioManager.AUDIOFOCUS_REQUEST_GRANTED)
            }
            "abandon_focus" -> {
                if (Build.VERSION.SDK_INT < 26) {
                    result.success(false)
                    return
                }
                if (audioFocusRequest == null) {
                    result.success(false)
                } else {
                    val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    val res = audioManager.abandonAudioFocusRequest(audioFocusRequest!!)
                    result.success(res == AudioManager.AUDIOFOCUS_REQUEST_GRANTED)
                }
            }
            "mic_support_ultrasound" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                result.success(audioManager.getProperty(AudioManager.PROPERTY_SUPPORT_MIC_NEAR_ULTRASOUND) == "true")
            }
            "speaker_support_ultrasound" -> {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                result.success(audioManager.getProperty(AudioManager.PROPERTY_SUPPORT_SPEAKER_NEAR_ULTRASOUND) == "true")
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
}