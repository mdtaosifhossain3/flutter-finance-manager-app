package com.finzycash.expensebudgetmanager

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** Same samples as test/services/auto_sync_test.dart; keep them in step. */
class AutoSyncDetectorTest {

    private fun kind(text: String) = AutoSyncDetector.detect(text)?.kind

    @Test
    fun bkashSendMoney() {
        val d = AutoSyncDetector.detect(
            "Send Money Tk 500.00 to 01712345678 successful. Ref grocery. Fee Tk 0.00. " +
                "Balance Tk 2,345.50. TrxID BJT8K2M1QX at 29/10/2026 10:15",
        )!!
        assertEquals("sent", d.kind)
        assertEquals("500", d.amount)
        assertEquals("01712345678", d.party)
        assertEquals("BJT8K2M1QX", d.trxId)
    }

    @Test
    fun bkashReceivedPaymentCashOutRecharge() {
        assertEquals(
            "received",
            kind(
                "You have received Tk 1,500.00 from 01812345678. Ref family. Fee Tk 0.00. " +
                    "Balance Tk 3,210.50. TrxID BJT8K2M1QY at 28/10/2026 19:42",
            ),
        )
        assertEquals(
            "payment",
            kind(
                "Payment Tk 850.00 to Shwapno successful. Fee Tk 0.00. Balance Tk 1,500.00. " +
                    "TrxID BJT8K2M1QZ at 29/10/2026 12:00",
            ),
        )
        val cashOut = AutoSyncDetector.detect(
            "Cash Out Tk 2,000.00 to 01912345678 successful. Fee Tk 37.00. " +
                "Balance Tk 500.00. TrxID BJT8K2M1RA at 29/10/2026 13:00",
        )!!
        assertEquals("cash_out", cashOut.kind)
        assertEquals("2000", cashOut.amount)
        assertEquals(
            "recharge",
            kind(
                "Recharge Tk 50.00 to 01712345678 successful. Fee Tk 0.00. " +
                    "Balance Tk 950.00. TrxID BJT8K2M1RB at 29/10/2026 15:00",
            ),
        )
    }

    @Test
    fun nagadAndBank() {
        val nagad = AutoSyncDetector.detect(
            "Money Sent. Amount: Tk 300.00 Receiver: 01612345678 Ref: N/A " +
                "TxnID: 73ABCDEF Balance: Tk 1,200.00 29/10/2026 14:22",
        )!!
        assertEquals("sent", nagad.kind)
        assertEquals("300", nagad.amount)
        assertEquals("73ABCDEF", nagad.trxId)

        val bank =
            "Your A/C XXXX1234 has been debited by BDT 5,000.00 on 29-10-2026 for POS " +
                "purchase at AGORA. Avl Bal BDT 20,000.00"
        assertEquals("payment", kind(bank))
        assertEquals("5000", AutoSyncDetector.detect(bank)!!.amount)
        assertTrue(AutoSyncDetector.looksTransactional(bank))
    }

    @Test
    fun rejectsOtpAndPromotions() {
        assertNull(kind("Your bKash verification code is 123456. Do not share it."))
        assertNull(kind("Get up to Tk 100 cashback on payment at Daraz! Offer valid till 31 Oct."))
        assertNull(kind("Enjoy 20% discount, pay Tk 99 only. Dial *247#"))
        assertNull(kind("Hello, how are you?"))
    }

    @Test
    fun bankMessageWithLinkIsNotTreatedAsPromo() {
        assertEquals(
            "payment",
            kind(
                "Your A/C XX1234 debited BDT 1,200.00 for purchase at DARAZ. " +
                    "Visit www.bank.com for details",
            ),
        )
    }

    @Test
    fun senders() {
        assertTrue(AutoSyncDetector.isFinancialSender("bKash"))
        assertTrue(AutoSyncDetector.isFinancialSender("NAGAD"))
        assertTrue(AutoSyncDetector.isFinancialSender("16216"))
        assertTrue(AutoSyncDetector.isFinancialSender("BRAC BANK"))
        assertTrue(AutoSyncDetector.isFinancialSender("Jamuna Bank"))
        assertFalse(AutoSyncDetector.isFinancialSender("Rahim"))
        assertFalse(AutoSyncDetector.isFinancialSender("Tapos Vai"))
        assertFalse(AutoSyncDetector.looksTransactional("vai Tk 500 sent korsi"))
    }
}
