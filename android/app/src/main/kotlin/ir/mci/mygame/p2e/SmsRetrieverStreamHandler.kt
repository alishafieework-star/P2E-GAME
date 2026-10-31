package ir.mci.mygame.p2e

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Telephony
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.plugin.common.EventChannel

/// D-071: one SMS Retriever listen. The message text is forwarded and not logged.
class SmsRetrieverStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        stop()
        sink = events
        SmsDelivery.sink = { body -> events.success(body) }
        val next = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                if (SmsRetriever.SMS_RETRIEVED_ACTION != intent.action) return
                val extras = intent.extras ?: return
                val status = extras.get(SmsRetriever.EXTRA_STATUS) as? Status ?: return
                when (status.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        val message = extras.getString(SmsRetriever.EXTRA_SMS_MESSAGE)
                        if (message != null) events.success(message)
                        unregister(receiver)
                        receiver = null
                    }
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
            context.registerReceiver(
                next,
                filter,
                SmsRetriever.SEND_PERMISSION,
                null,
                Context.RECEIVER_EXPORTED,
            )
        } else {
            context.registerReceiver(next, filter, SmsRetriever.SEND_PERMISSION, null)
        }
        SmsRetriever.getClient(context).startSmsRetriever().addOnFailureListener {
            events.success("unavailable")
            unregister(receiver)
            receiver = null
        }
    }

    override fun onCancel(arguments: Any?) {
        stop()
    }

    private fun unregister(registered: BroadcastReceiver?) {
        registered?.let {
            try {
                context.unregisterReceiver(it)
            } catch (_: IllegalArgumentException) {
            }
        }
    }

    private fun stop() {
        unregister(receiver)
        receiver = null
        sink = null
        SmsDelivery.sink = null
    }
}

/// PE-003: debug and profile manifests receive an emulator SMS. Release does not.
object SmsDelivery {
    var sink: ((String) -> Unit)? = null
}

class DeliveredSmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Telephony.Sms.Intents.SMS_RECEIVED_ACTION != intent.action) return
        val body = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            .joinToString(separator = "") { it.displayMessageBody }
        if (body.isNotEmpty()) SmsDelivery.sink?.invoke(body)
    }
}
