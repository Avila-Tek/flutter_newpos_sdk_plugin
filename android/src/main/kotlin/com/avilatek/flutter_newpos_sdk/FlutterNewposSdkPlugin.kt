package com.avilatek.flutter_newpos_sdk

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.newpos.mposlib.sdk.*
import io.flutter.Log
import android.content.Context;
import android.Manifest;
import androidx.core.app.ActivityCompat;
import java.util.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;


/** FlutterNewposSdkPlugin */
class FlutterNewposSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var posManager: NpPosManager
  private var defaultGetCardNumberTimeOut = 20
  private var defaultScanBlueDeviceTimeOut = 500
  private var defaultDisplayKeepShowTime = 3
  private lateinit var _context : Context;
  private lateinit var _pluginBinding : FlutterPlugin.FlutterPluginBinding;
   private lateinit var _activity : FlutterActivity;

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      _activity = binding.activity as FlutterActivity
    }
    
  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onDetachedFromActivity(){}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    _activity = binding.activity as FlutterActivity
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    _pluginBinding = flutterPluginBinding;
    _context = _pluginBinding.getApplicationContext();

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_newpos_sdk/methods")
    channel.setMethodCallHandler(this)
    // El delegate del POS. Esta es la implementación del comportamiento que va a tomar el POS
    // al conectarse a la app
    var delegate = FlutterPosDelegate(channel)
    posManager = NpPosManager.sharedInstance(flutterPluginBinding.getApplicationContext(), delegate)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    // if (call.method == "getPlatformVersion") {
    //   result.success("Android ${android.os.Build.VERSION.RELEASE}")
    // } else {
    //   result.notImplemented()
    // }
    ActivityCompat.requestPermissions(_activity, arrayOf(Manifest.permission.BLUETOOTH_CONNECT,Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_PRIVILEGED), 1)

            when (call.method) {
                "flutterHotRestart" -> {
                    result.success(0);
                }
                "connectedCount" -> {
                    result.success(0);
                }
                "completeTransaction" -> {
                    try {
                        posManager.getDeviceInfo()
                        var cardReadEntity = CardReadEntity();
                        cardReadEntity.setSupportFallback(true)
                        cardReadEntity.setTimeout(60)
                        cardReadEntity.setAmount(String.format(Locale.forLanguageTag("es-VE"), "%012d", 0))
                        cardReadEntity.setTradeType(0)
                        cardReadEntity.setSupportDukpt(true)
                        cardReadEntity.setTrackEncrypt(false)
                        posManager.readCard(cardReadEntity)
                        result.success(true)
                    } catch (error : Exception) {
                        result.error("COMPLETE_TRX_FAILED", error.message, "");
                    }

                }
                "scanBlueDevice" -> {
                    Log.d("MethodChannel/Kotlin", "scanBluetoothDevices method received")
                    result.success(true)

                    var timeout = call.arguments as? Int ?: defaultScanBlueDeviceTimeOut
                    posManager.scanBlueDevice(timeout)
                }
                "clearRids" -> {
                    try {
                        posManager.clearRids()
                        result.success(true)
                    } catch (error : Exception) {
                        result.error("CLEAR_RIDS_FAILED", error.message, "");
                    }
                }
                "clearAids" -> {
                    try {
                        posManager.clearAids()
                        result.success(true)
                    } catch (error : Exception) {
                        result.error("CLEAR_AIDS_FAILED", error.message, "");
                    }
                }
                "addRid" -> {
                    var rid = call.arguments as? String
                    Log.d("MethodChannel/Kotlin", "addRid method received: $rid")
                    if (rid == null) {
                        result.error("ADD_RID_NULL", "RID parameter is null", "")
                    }else {
                        posManager.addRid(rid)
                        result.success(true)
                    }
                }
                "addAid" -> {
                    var aid = call.arguments as? String
                    Log.d("MethodChannel/Kotlin", "addAid method received: $aid")
                    if (aid == null) {
                        result.error("ADD_AID_NULL", "AID parameter is null", "")
                    }else {
                        posManager.addAid(aid)
                        result.success(true)
                    }
                }
                "stopScan" -> {
                    Log.d("MethodChannel/Kotlin", "stopScan method received")
                    posManager.stopScan()
                    result.success(true)
                }
                "connectToBluetoothDevice" -> {
                    Log.d("MethodChannel/Kotlin", "connectToBluetoothDevice method received")
                    var macAddress = call.arguments as? String
                    if(macAddress == null) {
                        result.error("NullMacAddress", "Mac Address is null", "")
                    }else {
                        posManager.connectBluetoothDevice(macAddress)
                        result.success(true)
                    }
                }
                "getDeviceInfo" -> {
                    Log.d("MethodChannel/Kotlin", "getDeviceInfo method received")
                    try {
                        posManager.getDeviceInfo()
                        result.success(true)
                    } catch ( error : Exception) {
                        Log.e("MethodChannel/Kotlin", "getCardNumber failed $error")
                        result.error("GET_CARD_NUMBER_ERROR", "Error getting card number", error);
                    }
                }
                "getCardNumber" -> {
                    var timeout = call.arguments as? Int ?: defaultGetCardNumberTimeOut
                    Log.d("MethodChannel/Kotlin", "getCardNumber method received with timeout $timeout")
                    try {
                        posManager.getCardNumber(timeout)
                        result.success(true)
                    } catch ( error : Exception) {
                        Log.e("MethodChannel/Kotlin", "getCardNumber failed $error")
                        result.error("GET_CARD_NUMBER_ERROR", "Error getting card number", error);
                    }
                }
                "disconnectDevice" -> {
                    Log.d("MethodChannel/Kotlin", "disconnectDevice method received")
                    try {
                        posManager.disconnectDevice()
                        result.success(true)
                    } catch (e : Exception) {
                        result.error("DISCONNECT_DEVICE_ERROR", "Disconnect device failed", "")
                    }
                }
                "getCurrentBatteryStatus" -> {
                    posManager.getCurrentBatteryStatus()
                }
                "getEmvApduLog" -> {
                    Log.d("MethodChannel/Kotlin", "getEmvApduLog method received")
                    posManager.getEmvApduLog()
                }
                "updateMasterKey" -> {

                    var args: Map<String, Any> = call.arguments as? Map<String, Any> ?: emptyMap()
                    Log.d("MethodChannel/Kotlin", "updateMasterKey method received with args: $args, ${args["masterKey"]}, ${args["ifDukpt"]}")
                    var masterKey = args["masterKey"] as String?
                    var ifDukpt = args["ifDukpt"] as Boolean?
                    if(masterKey != null && ifDukpt != null) {
                        posManager.updateMasterKey(masterKey, ifDukpt)
                        result.success(true)
                    }else {
                        result.error("UPDATE_MASTER_KEY_ERROR", "One or more parameters to update master key is null", "")
                    }

                }
                "displayTextOnScreen" -> {
                    Log.d("MethodChannel/Kotlin", "displayTextOnScreen method received")

                    var args: Map<String, Any> = call.arguments as? Map<String, Any> ?: emptyMap()
                    var message = args["message"] as String
                    var keepShowTime = args["keepShowTime"] as? Int ?: defaultDisplayKeepShowTime

                    posManager.displayTextOnScreen(
                        keepShowTime,
                        message
                    )
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
