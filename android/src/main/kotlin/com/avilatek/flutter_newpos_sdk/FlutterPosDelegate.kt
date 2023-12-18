package com.avilatek.flutter_newpos_sdk

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.content.res.AssetManager
import android.os.Handler
import android.os.Looper
import com.newpos.mposlib.sdk.NpPosManager
import com.newpos.mposlib.sdk.CardInfoEntity
import com.newpos.mposlib.sdk.DeviceInfoEntity
import com.newpos.mposlib.sdk.INpSwipeListener
import com.newpos.mposlib.sdk.InputInfoEntity
import io.flutter.Log
import io.flutter.plugin.common.MethodChannel
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.xml.sax.SAXException
import java.io.IOException
import java.io.InputStream
import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.parsers.ParserConfigurationException

/// newPOS SDK Delegate. Declares the behavior and functionality to be executed when instantiating
/// the [NpPosManager] class.
class FlutterPosDelegate(private val channel: MethodChannel, private val posManager: NpPosManager, private val needingPin: InputStream,) : INpSwipeListener {


    fun needsPin(code: String, file: InputStream): Boolean {
        try {
            val documentBuilderFactory = DocumentBuilderFactory.newInstance()
            val documentBuilder = documentBuilderFactory.newDocumentBuilder()
            val document = documentBuilder.parse(file)
            document.documentElement.normalize()
    
            val rowNodes = document.getElementsByTagName("ROW")
    
            for (index in 0 until rowNodes.length) {
                val rowNode = rowNodes.item(index)
    
                if (rowNode.nodeType == Node.ELEMENT_NODE) {
                    val rowElement = rowNode as Element
    
                    if (code == rowElement.getElementsByTagName("tag_res").item(0).textContent) {
                        return rowElement.getElementsByTagName("need_pin").item(0).textContent == "Y"
                    }
                }
            }
    
            return false
        } catch (e: ParserConfigurationException) {
            throw e
        } catch (e: IOException) {
            throw e
        } catch (e: SAXException) {
            throw e
        }
    }

    override fun onDeviceDisConnected() {
        Log.d("onDeviceDisConnected","🛜❌ The POS has been disconnected!")
        Handler(Looper.getMainLooper()).post {
            /// Update to Flutter engine device connection status
            channel.invokeMethod("OnDeviceConnection", false)
            /// Return to Flutter method result successfully
            channel.invokeMethod("OnDeviceDisConnected", true)
        }

    }

    @SuppressLint("MissingPermission")
    override fun onScannerResult(devInfo: BluetoothDevice?) {
        val data = hashMapOf<String, Any>()
        var address = devInfo?.address ?: ""
        var name = devInfo?.name ?: ""
        var type = devInfo?.type ?: 0
        data["address"] = address
        data["name"] = name
        data["type"] = type
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnScanResponse", data)
        }

        Log.d("onScannerResult","--- 🛜NEW SCAN RESULT ---")
        Log.d("onScannerResult","--- 🛜 LESANPI ---")
        Log.d("onScannerResult","ADDRESS -> ${devInfo?.address}")
        Log.d("onScannerResult","NAME -> ${devInfo?.name}")
        Log.d("onScannerResult","-------------------------")
    }

    override fun onDeviceConnected() {
        Log.d("onDeviceConnected","🛜✅ The POS has been connected, device connection changed")
        Handler(Looper.getMainLooper()).post {
            /// Update to Flutter engine device connection status
            channel.invokeMethod("OnDeviceConnection", true)
            /// Return to Flutter method result successfully
            channel.invokeMethod("OnDeviceConnected", true)
        }
    }

    override fun onGetDeviceInfo(info: DeviceInfoEntity?) {
        var firmwareVersion = info?.firmwareVer
        var deviceType = info?.deviceTypeStr
        var ksn = info?.ksn
        var currentElePer = info?.currentElePer
        Log.d("onGetDeviceInfo", "--- POS DEVICE INFO ---")
        Log.d("onGetDeviceInfo","FIRMWARE VERSION -> $firmwareVersion")
        Log.d("onGetDeviceInfo","DEVICE TYPE -> $deviceType")
        Log.d("onGetDeviceInfo","KSN -> $ksn")
        Log.d("onGetDeviceInfo","CURRENT ELE PER -> $currentElePer")
        Log.d("onGetDeviceInfo","-----------------------")

        val data = hashMapOf<String, Any?>()
        data["firmwareVersion"] = firmwareVersion
        data["deviceType"] = deviceType
        data["ksn"] = ksn
        data["currentElePer"] = currentElePer
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnGetDeviceInfo", data)
            Log.d("onGetDeviceInfo","OnGetDeviceInfo method invoked")
        }

    }

    override fun onGetTransportSessionKey(encryTransportKey: String?) {
        Log.d("onGetTransportSessionKey", "🔐 Transport Session Key $encryTransportKey")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnGetTransportSessionKey", encryTransportKey)
        }
    }

    override fun onUpdateMasterKeySuccess() {
        Log.d("onUpdateMasterKeySuccess","✅ Master key updated!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnUpdateMasterKeySuccess", true)
        }
    }

    override fun onUpdateWorkingKeySuccess() {
        Log.d("onUpdateWorkingKeySuccess","✅ Working key updated!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnUpdateWorkingKeySuccess", true)
        }
    }

    override fun onAddAidSuccess() {
        Log.d("onAddAidSuccess","✅ AID added successfully!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnAddAidSuccess", true)
        }
    }

    override fun onAddRidSuccess() {
        Log.d("onAddRidSuccess","✅ RID added successfully!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnAddRidSuccess", true)
        }
    }

    override fun onClearAids() {
        Log.d("AIDS cleared!", "AIDS cleared!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnClearAids", true)
        }
    }

    override fun onClearRids() {
        Log.d("RIDS cleared!", "RIDS cleared!")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnClearRids", true)
        }
    }

    override fun onGetCardNumber(cardNum: String?) {
        Log.d("onGetCardNumber","CARD NUMBER -> $cardNum")
    }

    override fun onGetDeviceBattery(result: Boolean) {
        Log.d("🪫 POS BATTERY", "Battery Status $result")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnGetDeviceBattery", result)
        }
    }

    override fun onDetachedIC() {
        Log.d("IC detached!", "IC Detached!")
    }

    override fun onGetReadCardInfo(cardInfoEntity: CardInfoEntity?) {
        Log.d("onGetReadCardInfo","----- CARD INFO -----")
        Log.d("onGetReadCardInfo","CARD NUMBER -> ${cardInfoEntity?.cardNumber}")
        Log.d("onGetReadCardInfo","CARD TYPE -> ${cardInfoEntity?.cardType}")
        Log.d("onGetReadCardInfo","CARDHOLDER NAME -> ${cardInfoEntity?.cardholderName}")
        Log.d("onGetReadCardInfo","CSN -> ${cardInfoEntity?.csn}")
        Log.d("onGetReadCardInfo","ENCRYPT PIN -> ${cardInfoEntity?.encryptPin}")
        Log.d("onGetReadCardInfo","ENCRYPTED SN -> ${cardInfoEntity?.encryptedSN}")
        Log.d("onGetReadCardInfo","EXPIRATION DATE -> ${cardInfoEntity?.expDate}")
        Log.d("onGetReadCardInfo","IC55 DATA -> ${cardInfoEntity?.ic55Data}")
        Log.d("onGetReadCardInfo","TRACK 1 -> ${cardInfoEntity?.track1}")
        Log.d("onGetReadCardInfo","TRACK 2 -> ${cardInfoEntity?.track2}")
        Log.d("onGetReadCardInfo","TRACK 3 -> ${cardInfoEntity?.track3}")
        Log.d("onGetReadCardInfo","TUSN -> ${cardInfoEntity?.tusn}")
        Log.d("onGetReadCardInfo","---------------------")

        var cardNumber = cardInfoEntity?.cardNumber;
        var cardType = cardInfoEntity?.cardType;
        var cardholderName = cardInfoEntity?.cardholderName;
        var csn = cardInfoEntity?.csn;
        var encryptPin = cardInfoEntity?.encryptPin;
        var encryptedSN = cardInfoEntity?.encryptedSN;
        var expDate = cardInfoEntity?.expDate;
        var ic55Data = cardInfoEntity?.ic55Data;
        var track1 = cardInfoEntity?.track1;
        var track2 = cardInfoEntity?.track2;
        var track3 = cardInfoEntity?.track3;
        var tusn = cardInfoEntity?.tusn;

        val data = hashMapOf<String, Any?>()
        data["cardNumber"] = cardNumber
        data["cardType"] = cardType
        data["cardholderName"] = cardholderName
        data["csn"] = csn
        data["encryptPin"] = encryptPin
        data["encryptedSN"] = encryptedSN
        data["expDate"] = expDate
        data["ic55Data"] = ic55Data
        data["track1"] = track1
        data["track2"] = track2
        data["track3"] = track3
        data["tusn"] = tusn
        Handler(Looper.getMainLooper()).post {

            /// Get requiresPin field
            val track2 = cardInfoEntity!!.track2
            val exp = cardInfoEntity!!.expDate
            val tag9F34 = cardInfoEntity!!.ic55Data.split("9F34").toTypedArray()[1]
            val requiresPin: Boolean = needsPin(tag9F34.substring(2, 4), needingPin)
            data["requiresPin"] = requiresPin
            

            /// Requires pin flow
            if (requiresPin) {
                val codeInputEntity = InputInfoEntity()
                codeInputEntity.setInputType(1);
                codeInputEntity.setTimeout(30);
                codeInputEntity.setTitle("Inserte PIN");
                codeInputEntity.setPan(cardInfoEntity.cardNumber)
                posManager.getInputInfoFromKB(codeInputEntity);

            } else {
                // datosIso = TDD_TDC_Data.DatosIso(data_for_iso, dbDatosIso);
            }

            channel.invokeMethod("OnGetReadCardInfo", data)
        }

    }

    override fun onGetReadInputInfo(inputInfo: String?) {
        Log.d("onGetReadInputInfo","INPUT INFO -> $inputInfo")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnGetReadInputInfo", inputInfo)
        }
    }

    override fun onGetICCardWriteback(result: Boolean) {
        Log.d("onGetICCardWriteback","IC CARD WRITEBACK -> $result")
    }

    override fun onCancelReadCard() {
        Log.d("onCancelReadCard","❌ Cancelled card reading")
    }

    override fun onGetCalcMacResult(encryMacData: String?) {
        print("EncryMacData -> $encryMacData")
    }

    override fun onUpdateFirmwareProcess(percent: Float) {
        TODO("Not yet implemented")
    }

    override fun onUpdateFirmwareSuccess() {
        TODO("Not yet implemented")
    }

    override fun onGenerateQRCodeSuccess() {
        print("✅ GENERATE QR CODE SUCCEEDED")
    }

    override fun onSetTransactionInfoSuccess() {
        Log.d("onSetTransactionInfoSuccess","✅ SET TRANSACTION INFO SUCCEEDED")
    }

    override fun onGetTransactionInfoSuccess(transactionInfo: String?) {
        Log.d("onGetTransactionInfoSuccess","✅ TRANSACTION INFO SUCCESS -> $transactionInfo")
    }

    override fun onDisplayTextOnScreenSuccess() {
        Log.d("onDisplayTextOnScreenSuccess","✅ DISPLAY TEXT ON SCREEN SUCCEEDED")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnDisplayTextOnScreenSuccess", true)
        }

    }

    override fun onReceiveErrorCode(error: Int, message: String?) {
        Log.d("onReceiveErrorCode","‼️ ERROR CODE -> code: $error; message: $message ")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnReceiveErrorCode", true)
        }

    }

    override fun onSetAidSuccess() {
        Log.d("onSetAidSuccess","✅ SET AID SUCCEEDED")
        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("OnSetAidSuccess", true)
        }
    }

}