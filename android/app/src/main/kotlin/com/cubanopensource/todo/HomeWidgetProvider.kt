package com.cubanopensource.todo

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class HomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?) {
        appWidgetIds?.forEach {

            val pendingIntentSaldo = PendingIntent.getActivity(context, 0,
                    Intent(Intent.ACTION_CALL, Uri.parse("tel:*222${Uri.encode("#")}")), 0)

            val pendingIntentBono = PendingIntent.getActivity(context, 0,
                    Intent(Intent.ACTION_CALL, Uri.parse("tel:*222*266${Uri.encode("#")}")), 0)

            val pendingIntentDatos = PendingIntent.getActivity(context, 0,
                    Intent(Intent.ACTION_CALL, Uri.parse("tel:*222*328${Uri.encode("#")}")), 0)

            val pendingIntentVoz = PendingIntent.getActivity(context, 0,
                    Intent(Intent.ACTION_CALL, Uri.parse("tel:*222*869${Uri.encode("#")}")), 0)

            val pendingIntentSms = PendingIntent.getActivity(context, 0,
                    Intent(Intent.ACTION_CALL, Uri.parse("tel:*222*767${Uri.encode("#")}")), 0)


            val views = RemoteViews(context?.packageName, R.layout.home_widget)

            views.setOnClickPendingIntent(R.id.widget_button_saldo, pendingIntentSaldo)
            views.setOnClickPendingIntent(R.id.widget_button_bonos, pendingIntentBono)
            views.setOnClickPendingIntent(R.id.widget_button_saldo_datos, pendingIntentDatos)
            views.setOnClickPendingIntent(R.id.widget_button_saldo_voz, pendingIntentVoz)
            views.setOnClickPendingIntent(R.id.widget_button_saldo_sms, pendingIntentSms)

            appWidgetManager?.updateAppWidget(it, views)
        }
    }
}