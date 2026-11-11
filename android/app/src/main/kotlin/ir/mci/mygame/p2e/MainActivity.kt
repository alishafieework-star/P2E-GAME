package ir.mci.mygame.p2e

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var sms: SmsUserConsentHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val handler = SmsUserConsentHandler(this)
        sms = handler
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.mci.mygame.p2e/otp_sms",
        ).setStreamHandler(handler)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ir.mci.mygame.p2e/otp_sms_access",
        ).setMethodCallHandler { call, result ->
            // PLATFORM(PE-005): User Consent does not use an inbox permission.
            if (call.method == "ensure" || call.method == "status") {
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    @Deprecated("FlutterActivity still delivers the consent result here.")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (sms?.onActivityResult(requestCode, resultCode, data) == true) return
        super.onActivityResult(requestCode, resultCode, data)
    }
}
