package de.seemoo.pairsonic.channels

import java.io.IOException
import android.app.Activity
import android.os.Build
import android.util.Log
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.net.wifi.p2p.WifiP2pConfig
import android.net.wifi.p2p.WifiP2pGroup
import android.net.wifi.p2p.WifiP2pInfo
import android.net.wifi.p2p.WifiP2pManager
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class WifiP2pChannel(
    private val activity: Activity,
    private val channel: MethodChannel
) : MethodChannel.MethodCallHandler, BroadcastReceiver() {

    private val intentFilter = IntentFilter()

    init {
        channel.setMethodCallHandler(this)
        intentFilter.addAction(WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION)
        intentFilter.addAction(WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION)
        intentFilter.addAction(WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION)
        intentFilter.addAction(WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION)
    }

    private var isRegistered = false;
    private var manager: WifiP2pManager? = null
    private var wifiChannel: WifiP2pManager.Channel? = null

    private var SSID: String? = null
    private var netId: Int = -1

    /// Called when this BroadcastReceiver is receiving an Intent broadcast.
    override fun onReceive(context: Context, intent: Intent) {   
        when(intent.action) {
            WifiP2pManager.WIFI_P2P_STATE_CHANGED_ACTION -> {
                // Determine if Wifi P2P mode is enabled or not, alert
                // the Activity.
                val state = intent.getIntExtra(WifiP2pManager.EXTRA_WIFI_STATE, -1)
                activity.runOnUiThread(Runnable() {
                    channel.invokeMethod("wifi_p2p_available", state == WifiP2pManager.WIFI_P2P_STATE_ENABLED);
                })
            }
            WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION -> {
            }
            WifiP2pManager.WIFI_P2P_CONNECTION_CHANGED_ACTION -> {
                if (manager != null) {
                    val group: WifiP2pGroup? = intent.getParcelableExtra(WifiP2pManager.EXTRA_WIFI_P2P_GROUP);
                    activity.runOnUiThread(Runnable() {
                        if (group == null) {
                            channel.invokeMethod("wifi_p2p_group_info", null);
                        } else {
                            channel.invokeMethod("wifi_p2p_group_info", mapOf(
                                "ssid" to group.getNetworkName(),
                                "passphrase" to group.getPassphrase()
                            ));
                        }
                    })

                    val connection: WifiP2pInfo? = intent.getParcelableExtra(WifiP2pManager.EXTRA_WIFI_P2P_INFO);
                    activity.runOnUiThread(Runnable() {
                        if (connection == null || connection.groupOwnerAddress == null) {
                            channel.invokeMethod("wifi_p2p_connection_info", null);
                        } else {
                            channel.invokeMethod("wifi_p2p_connection_info", mapOf(
                                "isOwner" to connection.isGroupOwner,
                                "ownerAddress" to connection.groupOwnerAddress.getHostAddress()
                            ));
                        }
                    })
                }
            }
            WifiP2pManager.WIFI_P2P_THIS_DEVICE_CHANGED_ACTION -> {
            }
        }
    }

    /// Handle the incoming method call for the gp_wifip2p channel.
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "init") {
            if (manager == null) {
                manager = activity.getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
                wifiChannel = manager!!.initialize(activity, activity.getMainLooper(), null)
                result.success(true)
            } else {
                result.success(false)
            }
        } else if (call.method == "req_connection_info") {
            if (Build.VERSION.SDK_INT >= 29) {
                manager!!.requestConnectionInfo(wifiChannel) { connection: WifiP2pInfo? -> 
                    if (connection == null || connection.groupOwnerAddress == null) {
                        result.success(null);
                    } else {
                        result.success(mapOf(
                            "isOwner" to connection.isGroupOwner,
                            "ownerAddress" to connection.groupOwnerAddress.getHostAddress()
                        ));
                    }
                }
            } else {
                val wifiManager = activity.getSystemService(Context.WIFI_SERVICE) as WifiManager
                val dhcpInfo = wifiManager.getDhcpInfo()
                if (dhcpInfo == null || dhcpInfo.gateway == 0) {
                    result.success(null);
                } else {
                    result.success(mapOf(
                        "isOwner" to false,
                        "ownerAddress" to android.text.format.Formatter.formatIpAddress(dhcpInfo.gateway)
                    ));
                }
            }
        } else if (call.method == "req_group_info") {
            if (Build.VERSION.SDK_INT >= 29) {
                manager!!.requestGroupInfo(wifiChannel) { group: WifiP2pGroup? -> 
                    if (group == null) {
                        result.success(null);
                    } else {
                        result.success(mapOf(
                            "ssid" to group.getNetworkName(),
                            "passphrase" to group.getPassphrase()
                        ));
                    }
                }
            } else {
                val wifiManager = activity.getSystemService(Context.WIFI_SERVICE) as WifiManager
                val wifiInfo = wifiManager.getConnectionInfo()
                if (wifiInfo.getSSID() == SSID) {
                    result.success(mapOf(
                        "ssid" to SSID,
                        "passphrase" to ""
                    ));
                } else {
                    result.success(null)
                }
            }
        } else if (call.method == "create_group") {
            manager!!.createGroup(wifiChannel, object : WifiP2pManager.ActionListener {
                override fun onSuccess() {
                    result.success(true)
                }
                override fun onFailure(reason: Int) {
                    // result.error("create_group", "Failed to create group", reason)
                    Log.d("WifiP2pChannel", "create_group failed with reason: ${reason}")
                    result.success(false)
                }
            })
        } else if (call.method == "remove_group") {
            manager!!.removeGroup(wifiChannel, object : WifiP2pManager.ActionListener {
                override fun onSuccess() {
                    result.success(true)
                }
                override fun onFailure(reason: Int) {
                    // result.error("remove_group", "Failed to remove group", reason)
                    result.success(false)
                }
            })
        } else if (call.method == "connect") {
            if (Build.VERSION.SDK_INT >= 29) {
                val config = WifiP2pConfig.Builder()
                    .setNetworkName(call.argument<String>("ssid")!!)
                    .setPassphrase(call.argument<String>("passphrase")!!)
                    .build()
                manager!!.connect(wifiChannel, config, object : WifiP2pManager.ActionListener {
                    override fun onSuccess() {
                        result.success(true)
                    }
                    override fun onFailure(reason: Int) {
                        result.success(false)
                        //result.error("connect", "Failed to connect", reason)
                    }
                })
            } else {
                // https://stackoverflow.com/a/20504821
                val wifiConfiguration = WifiConfiguration()
                wifiConfiguration.SSID = String.format("\"%s\"", call.argument<String>("ssid")!!)
                wifiConfiguration.preSharedKey = String.format("\"%s\"", call.argument<String>("passphrase")!!)
                SSID = String.format("\"%s\"", call.argument<String>("ssid")!!)


                val wifiManager = activity.getSystemService(Context.WIFI_SERVICE) as WifiManager
                netId = wifiManager.getConnectionInfo().getNetworkId()
                val newNetId = wifiManager.addNetwork(wifiConfiguration)
                wifiManager.disconnect()
                wifiManager.enableNetwork(newNetId, true)
                wifiManager.reconnect()
                result.success(true)
            }
        } else if (call.method == "disconnect") {
            if (Build.VERSION.SDK_INT < 29 && netId != -1) {
                val wifiManager = activity.getSystemService(Context.WIFI_SERVICE) as WifiManager
                wifiManager.disconnect()
                wifiManager.enableNetwork(netId, true)
                wifiManager.reconnect()
                netId = -1
                result.success(true)
            } else {
                result.success(true)
            } 
        } else if (call.method == "register") {
            if (isRegistered) {
                result.success(false)
            } else {
                activity.registerReceiver(this, intentFilter)
                isRegistered = true
                result.success(true)
            }
        } else if (call.method == "unregister") {
            if (isRegistered) {
                activity.unregisterReceiver(this)
                isRegistered = false
                result.success(true)
            } else {
                result.success(false)
            }
        } else {
            result.notImplemented()
        }
    }
    
}