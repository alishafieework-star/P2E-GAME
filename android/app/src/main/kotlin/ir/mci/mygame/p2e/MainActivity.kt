package ir.mci.mygame.p2e

import android.Manifest
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var smsPermission: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.mci.mygame.p2e/otp_sms",
        ).setStreamHandler(SmsRetrieverStreamHandler(this))
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.mci.mygame.p2e/otp_sms_access",
        ).setMethodCallHandler { call, result ->
            if (call.method != "ensure" && call.method != "status") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            // SMS Retriever needs no permission; only debug builds read raw SMS.
            val debuggable =
                applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0
            val granted =
                !debuggable ||
                    checkSelfPermission(Manifest.permission.RECEIVE_SMS) ==
                    PackageManager.PERMISSION_GRANTED
            if (call.method == "status") {
                result.success(granted)
                return@setMethodCallHandler
            }
            if (granted) {
                result.success(true)
                return@setMethodCallHandler
            }
            smsPermission = result
            requestPermissions(arrayOf(Manifest.permission.RECEIVE_SMS), requestSms)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != requestSms) return
        smsPermission?.success(
            grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED,
        )
        smsPermission = null
    }

    private companion object {
        const val requestSms = 4103
    }
}
