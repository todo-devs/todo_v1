package com.cubanopensource.todo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class HomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?) {
        appWidgetIds?.forEach {
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

            val views = RemoteViews(context?.packageName, R.layout.home_widget)

            views.setOnClickPendingIntent(R.id.widget_button_saldo, pendingIntent)

            appWidgetManager?.updateAppWidget(it, views)
        }
    }
}