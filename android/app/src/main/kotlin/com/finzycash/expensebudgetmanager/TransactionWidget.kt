package com.finzycash.expensebudgetmanager

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home screen widget: today's and this month's spending, with quick-add
 * buttons. The numbers and labels are written by the Flutter side
 * (HomeWidgetService) so they follow the app language.
 */
class TransactionWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.transaction_widget).apply {
                setTextViewText(R.id.widget_title, widgetData.getString("w_title", "Hishab Rakhi"))
                setTextViewText(R.id.widget_today_label, widgetData.getString("w_today_label", "Today"))
                setTextViewText(R.id.widget_today, widgetData.getString("w_today", "৳0"))
                setTextViewText(R.id.widget_month_label, widgetData.getString("w_month_label", "This month"))
                setTextViewText(R.id.widget_month, widgetData.getString("w_month", "৳0"))
                setTextViewText(R.id.widget_left, widgetData.getString("w_left", ""))
                setTextViewText(R.id.widget_add, widgetData.getString("w_add_label", "+ Add"))

                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("hishabrakhi://open"))
                )
                setOnClickPendingIntent(
                    R.id.widget_add,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("hishabrakhi://add"))
                )
                setOnClickPendingIntent(
                    R.id.widget_voice,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("hishabrakhi://voice"))
                )
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
