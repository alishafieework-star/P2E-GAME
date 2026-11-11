package ir.mci.mygame.p2e

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.plugin.common.EventChannel

/// D-156: one SMS User Consent listen. The message is forwarded and not logged.
class SmsUserConsentHandler(private val activity: Activity) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null
    private var sink: EventChannel.EventSink? = null
    private var consentStarted = false

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        stop()
        sink = events
        consentStarted = false
        val sender = arguments as? String
        val next = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                if (SmsRetriever.SMS_RETRIEVED_ACTION != intent.action) return
                val extras = intent.extras ?: return
                val status = extras.get(SmsRetriever.EXTRA_STATUS) as? Status ?: return
                when (status.statusCode) {
                    CommonStatusCodes.SUCCESS -> launchConsent(extras)
                    CommonStatusCodes.TIMEOUT -> {
                        events.success("timeout")
                        unregister(receiver)
                        receiver = null
                    }
                }
            }
        }
        receiver = next
        val filter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
        if (Build.VERSION.SDK_INT >= 33) {
            activity.registerReceiver(
                next,
                filter,
                SmsRetriever.SEND_PERMISSION,
                null,
                Context.RECEIVER_EXPORTED,
            )
        } else {
            activity.registerReceiver(next, filter, SmsRetriever.SEND_PERMISSION, null)
        }
        SmsRetriever.getClient(activity).startSmsUserConsent(sender).addOnFailureListener {
            events.success("unavailable")
            unregister(receiver)
            receiver = null
        }
    }

    override fun onCancel(arguments: Any?) {
        stop()
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != consentRequest) return false
        val events = sink
        if (resultCode == Activity.RESULT_OK && data != null) {
            val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
            if (message != null) events?.success(message) else events?.success("unavailable")
        } else {
            events?.success("consent_denied")
        }
        return true
    }

    private fun launchConsent(extras: Bundle) {
        if (consentStarted) return
        val consent = consentIntent(extras) ?: run {
            sink?.success("unavailable")
            return
        }
        consentStarted = true
        activity.startActivityForResult(consent, consentRequest)
    }

    private fun consentIntent(extras: Bundle): Intent? =
        if (Build.VERSION.SDK_INT >= 33) {
            extras.getParcelable(SmsRetriever.EXTRA_CONSENT_INTENT, Intent::class.java)
        } else {
            @Suppress("DEPRECATION")
            extras.getParcelable(SmsRetriever.EXTRA_CONSENT_INTENT)
        }

    private fun unregister(registered: BroadcastReceiver?) {
        registered?.let {
            try {
                activity.unregisterReceiver(it)
            } catch (_: IllegalArgumentException) {
            }
        }
    }

    private fun stop() {
        unregister(receiver)
        receiver = null
        sink = null
        consentStarted = false
    }

    private companion object {
        const val consentRequest = 4104
    }
}
