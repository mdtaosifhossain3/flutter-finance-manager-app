package com.finzycash.expensebudgetmanager

/**
 * Decides whether a notification text is a bKash / Nagad / Rocket / bank
 * transaction. Mirrors lib/services/parser/sms_parser.dart so every message
 * we pop up can be parsed by the app; keep the two in step.
 */
object AutoSyncDetector {

    data class Detected(
        val amount: String,
        /** Translation-free kind used for the pop-up text. */
        val kind: String,
        val party: String?,
        val trxId: String?,
    )

    private val amountRe = Regex(
        """(?:tk\.?|bdt|৳)\s*:?\s*([\d,]+(?:\.\d{1,2})?)""",
        RegexOption.IGNORE_CASE,
    )
    private val labelBefore = Regex(
        """\b(?:fee|charge|balance|bal)\b\.?\s*:?\s*$""",
        RegexOption.IGNORE_CASE,
    )
    private val trxRe = Regex(
        """\b(?:trx\s*id|txn\s*id|trxid|txnid|transaction\s*id)\s*[:.]?\s*([A-Z0-9]{6,})""",
        RegexOption.IGNORE_CASE,
    )
    private val otpRe = Regex("""\b(?:otp|verification code|pin)\b""", RegexOption.IGNORE_CASE)
    private val phoneRe = Regex("""(?:\+?88)?(01\d{9})""")
    private val merchantRe = Regex(
        """\b(?:to|at)\s+([A-Za-z][A-Za-z0-9 &._-]{2,40}?)(?=\s+(?:successful|is successful|was|on|ref|fee|\.|,)|[.,]|$)""",
        RegexOption.IGNORE_CASE,
    )

    // Offers and ads mention "Tk" too; real transactions carry a TrxID or a
    // past-tense verb instead.
    private val promoRe = Regex(
        """\b(?:offer|get up to|upto|up to|enjoy|win|chance|campaign|discount|coupon|voucher|dial|click|download|http|www)\b|%""",
        RegexOption.IGNORE_CASE,
    )

    /** Sender names banks and wallets use in SMS (notification title). */
    // Only names that can't be a person or place; "bank" covers the rest
    // ("Jamuna Bank", "Prime Bank"…).
    private val financialSenders = listOf(
        "bkash", "nagad", "rocket", "16216", "upay", "mcash", "surecash",
        "dbbl", "dutch-bangla", "brac bank", "citybank", "city bank", "ebl",
        "ibbl", "islami bank", "sonali bank", "janata bank", "agrani bank",
        "rupali bank", "pubali bank", "mtb", "scb", "hsbc", "ucb", "ific",
        "sjibl", "aibl", "exim", "fsibl", "sibl", "lankabangla", "idlc", "bank",
    )

    fun isFinancialSender(title: String): Boolean {
        val t = title.lowercase()
        return financialSenders.any { t.contains(it) }
    }

    /** Strong signs of a bank/wallet message even from an unknown sender. */
    fun looksTransactional(text: String): Boolean {
        val l = text.lowercase()
        return trxRe.containsMatchIn(text) ||
            Regex("""a/c|acct|account""").containsMatchIn(l) &&
            Regex("""debited|credited|withdrawn|deposited""").containsMatchIn(l)
    }

    fun detect(raw: String): Detected? {
        val text = raw.replace(Regex("""\s+"""), " ").trim()
        val lower = text.lowercase()
        val trxId = trxRe.find(text)?.groupValues?.get(1)?.uppercase()
        if (otpRe.containsMatchIn(lower) && !lower.contains("trxid")) return null
        if (trxId == null && !looksTransactional(text) && promoRe.containsMatchIn(lower)) {
            return null
        }

        val amount = firstAmount(text) ?: return null
        val party = phoneRe.find(text)?.groupValues?.get(1)
            ?: merchantRe.find(text)?.groupValues?.get(1)?.trim()

        // Same order as SmsParser.parse.
        val kind = when {
            lower.contains("cash out") || lower.contains("cashout") -> "cash_out"
            lower.contains("cash in") -> "cash_in"
            lower.contains("atm") && isDebit(lower) -> "atm"
            lower.contains("add money") || lower.contains("added money") -> "add_money"
            lower.contains("recharge") || lower.contains("top up") ||
                lower.contains("top-up") -> "recharge"
            lower.contains("bill") -> "bill"
            lower.contains("received") || lower.contains("credited") ||
                lower.contains("deposited") || lower.contains("remittance") ||
                lower.contains("cashback") -> "received"
            lower.contains("send money") || lower.contains("sent") ||
                lower.contains("transferred to") -> "sent"
            lower.contains("payment") || lower.contains("paid") ||
                lower.contains("purchase") || lower.contains("pos ") -> "payment"
            isDebit(lower) -> "debit"
            else -> return null
        }
        return Detected(amount, kind, party, trxId)
    }

    private fun isDebit(lower: String) =
        lower.contains("debited") || lower.contains("withdrawn") || lower.contains("withdrawal")

    private fun firstAmount(text: String): String? {
        for (m in amountRe.findAll(text)) {
            if (labelBefore.containsMatchIn(text.substring(0, m.range.first))) continue
            val value = m.groupValues[1].replace(",", "").toDoubleOrNull() ?: continue
            if (value <= 0) return null
            val rounded = Math.round(value)
            return rounded.toString()
        }
        return null
    }
}
