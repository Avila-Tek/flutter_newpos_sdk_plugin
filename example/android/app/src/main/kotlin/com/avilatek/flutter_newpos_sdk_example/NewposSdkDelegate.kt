package com.avilatek.flutter_newpos_sdk_example
import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import com.newpos.mposlib.sdk.CardInfoEntity
import com.newpos.mposlib.sdk.DeviceInfoEntity
import com.newpos.mposlib.sdk.INpSwipeListener
import io.flutter.Log

/// newPOS SDK Delegate. Declares the behavior and functionality to be executed when instantiating
/// the [NpPosManager] class.
class NewposSdkDelegate: INpSwipeListener {

    // NOTA para LUIS: Estos son los callbacks del POS. Sobrescribe los que necesites para que
    // retornen de vuelta a Flutter la data que necesites.

    override fun onDeviceDisConnected() {
        Log.d("onDeviceDisConnected","🛜❌ The POS has been disconnected!")
    }

    @SuppressLint("MissingPermission")
    override fun onScannerResult(devInfo: BluetoothDevice?) {
        Log.d("onScannerResult","--- 🛜NEW SCAN RESULT ---")
        Log.d("onScannerResult","ADDRESS -> ${devInfo?.address}")
        Log.d("onScannerResult","NAME -> ${devInfo?.name}")
        Log.d("onScannerResult","-------------------------")
    }

    override fun onDeviceConnected() {
        Log.d("onDeviceConnected","🛜✅ The POS has been connected!")

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

    }

    override fun onGetTransportSessionKey(encryTransportKey: String?) {
        TODO("Not yet implemented")
    }

    override fun onUpdateMasterKeySuccess() {
        Log.d("onUpdateMasterKeySuccess","✅ Master key updated!")
    }

    override fun onUpdateWorkingKeySuccess() {
        Log.d("onUpdateWorkingKeySuccess","✅ Working key updated!")
    }

    override fun onAddAidSuccess() {
        Log.d("onAddAidSuccess","✅ AID added successfully!")
    }

    override fun onAddRidSuccess() {
        print("✅ RID added successfully!")
    }

    override fun onClearAids() {
        print("AIDS cleared!")
    }

    override fun onClearRids() {
        print("RIDS cleared!")
    }

    override fun onGetCardNumber(cardNum: String?) {
        Log.d("onGetCardNumber","CARD NUMBER -> $cardNum")
    }

    override fun onGetDeviceBattery(result: Boolean) {
        print("🪫 POS BATTERY  -> $result")
    }

    override fun onDetachedIC() {
        print("IC detached!")
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
    }

    override fun onGetReadInputInfo(inputInfo: String?) {
        Log.d("onGetReadInputInfo","INPUT INFO -> $inputInfo")
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
        print("✅ SET TRANSACTION INFO SUCCEEDED")
    }

    override fun onGetTransactionInfoSuccess(transactionInfo: String?) {
        Log.d("onGetTransactionInfoSuccess","✅ TRANSACTION INFO SUCCESS -> $transactionInfo")
    }

    override fun onDisplayTextOnScreenSuccess() {
        Log.d("onDisplayTextOnScreenSuccess","✅ DISPLAY TEXT ON SCREEN SUCCEEDED")
    }

    override fun onReceiveErrorCode(error: Int, message: String?) {
        Log.d("onReceiveErrorCode","‼️ ERROR CODE -> code: $error; message: $message ")
    }

    override fun onSetAidSuccess() {
        Log.d("onSetAidSuccess","✅ SET AID SUCCEEDED")
    }

}