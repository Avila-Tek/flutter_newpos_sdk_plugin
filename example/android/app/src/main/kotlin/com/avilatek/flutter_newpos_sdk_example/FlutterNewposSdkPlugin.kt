package com.avilatek.flutter_newpos_sdk

import androidx.annotation.NonNull
import com.avilatek.flutter_newpos_sdk_example.NewposSdkDelegate
import com.newpos.mposlib.sdk.NpPosManager
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.runBlocking

/** FlutterNewposSdkPlugin */
class FlutterNewposSdkPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {

    /// POS manager instance. This is the object that will be used to communicated with the
    /// newPOS device.
    private lateinit var posManager: NpPosManager

    /// Estas son unas variables que cree antes para parametrizar algunos comportaminetos.
    /// Te recomiendo que parametrices todo lo posible.
    private var defaultGetCardNumberTimeOut = 20
    private var defaultScanBlueDeviceTimeOut = 500
    private var defaultDisplayKeepShowTime = 3

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "newpos.com/channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        // Acá suscribes los method calls
        // NOTA:  when es el equivalente a switch/case
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "scanBluetoothDevices" -> {
                Log.d("MethodChannel/Kotlin", "scanBluetoothDevices method received")

                var timeout = call.arguments as? Int ?: defaultScanBlueDeviceTimeOut

                runBlocking {
                    posManager.scanBlueDevice(timeout)
                }
            }
            "connectToBluetoothDevice" -> {
                Log.d("MethodChannel/Kotlin", "connectToBluetoothDevice method received")
                var macAddress = call.arguments as? String

                if(macAddress == null) {
                    // TODO(andres): Throw exception back
                }

                posManager.connectBluetoothDevice(macAddress)
            }
            "getDeviceInfo" -> {
                Log.d("MethodChannel/Kotlin", "getDeviceInfo method received")
                posManager.getDeviceInfo()
            }
            "getCardNumber" -> {
                Log.d("MethodChannel/Kotlin", "getCardNumber method received")
                var timeout = call.arguments as? Int ?: defaultGetCardNumberTimeOut
                posManager.getCardNumber(timeout)
            }
            "disconnectDevice" -> {
                Log.d("MethodChannel/Kotlin", "disconnectDevice method received")
                posManager.disconnectDevice()
            }
            "getCurrentBatteryStatus" -> {
                posManager.getCurrentBatteryStatus()
            }
            "getEmvApduLog" -> {
                Log.d("MethodChannel/Kotlin", "getEmvApduLog method received")
                posManager.getEmvApduLog()
            }
            "updateMasterKey" -> {
                Log.d("MethodChannel/Kotlin", "updateMasterKey method received")

                var args: Map<String, Any> = call.arguments as? Map<String, Any> ?: emptyMap()

                if(!args.containsKey("masterKey") || !args.containsKey("ifDukpt")) {
                    var masterKey = args["masterKey"] as String
                    var ifDukpt = args["ifDukpt"] as Boolean

                    posManager.updateMasterKey(masterKey, ifDukpt)
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
            }

            else -> {
                result.notImplemented()

            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // 🚨 NOTA SOLO EN CASO DE ERROR!!! 🚨 ( SI FUNCIONA, ELIMINAR ESTA NOTA ) ->
    // EL CONSTRUCTOR DEL NpPosManager NECESITA EL APPLICATION CONTEXT PARA CREAR EL OBJETO
    //
    // NO SE SI EL Context CORRECTO ES binding.activity.applicationContext, O binding.activity.baseContext
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // El delegate del POS. Esta es la implementación del comportamiento que va a tomar el POS
        // al conectarse a la app
        var delegate = NewposSdkDelegate()

        /// Instancia del POS.
        posManager = NpPosManager.sharedInstance(binding.activity.applicationContext,  delegate)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
