/*******************************************************************************
 * Copyright (c) 2014 Worcester Polytechnic Institute.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors: Fangming Ning
 ******************************************************************************/
package com.wpi.assistments;

import org.apache.http.util.EncodingUtils;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

public class HomeTabbedActivity extends Activity {

	private WebView homeWebView = null;
	
	private Button btnBack, btnRefresh, btnForward, btnOffline;
	
	private boolean isTeacher, toggle, logoutFlag;
	
	private final Context webviewContext = this; 

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.activity_webview); 
		
		final ProgressDialog pd = ProgressDialog.show(this, "", "Loading...",true);
		
		isTeacher = false;
		toggle = true;
		logoutFlag = false;

		homeWebView = (WebView) findViewById(R.id.homeWebView);
		homeWebView.setWebViewClient(new WebViewClient() {
			public void onPageFinished(WebView view, String url) {
				Log.i("test", view.getUrl());
				if (view.getUrl().equals(
						"https://www.assistments.org/account/login") && !logoutFlag) {

					Intent intent = new Intent(getApplicationContext(),
							LoginActivity.class);
					intent.putExtra("showPopup", "true");
					startActivity(intent);
					finish();
				}else if(view.getUrl().equals("https://www.assistments.org/teacher")){
					isTeacher = true;
				}else if(view.getUrl().equals(
						"https://www.assistments.org/account/login") && logoutFlag){
					Intent intent = new Intent(getApplicationContext(),
							LoginActivity.class);
					startActivity(intent);
				}
				
				if(!homeWebView.canGoBack()){
					btnBack.setEnabled(false);
				}else{
					btnBack.setEnabled(true);
				}
				
				if(!homeWebView.canGoForward()){
					btnForward.setEnabled(false);
				}else{
					btnForward.setEnabled(true);
				}
				
				if(pd.isShowing()&&pd!=null)
                {
                    pd.dismiss();
                }
			}

			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				pd.show();    
				view.loadUrl(url);
				return true;
			}
		});
		homeWebView.setWebChromeClient(new WebChromeClient(){
			@Override
		    public boolean onJsConfirm(WebView view, String url, String message, final JsResult result) {
		        new AlertDialog.Builder(webviewContext)
		        .setTitle("ASSISTments")
		        .setMessage(message)
		        .setPositiveButton(android.R.string.ok,
		                new DialogInterface.OnClickListener()
		        {
		            public void onClick(DialogInterface dialog, int which)
		            {
		            	logoutFlag = true;
		                result.confirm();
		            }
		        })
		        .setNegativeButton(android.R.string.cancel,
		                new DialogInterface.OnClickListener()
		        {
		            public void onClick(DialogInterface dialog, int which)
		            {
		                result.cancel();
		            }
		        })
		        .create()
		        .show();

		        return true;
		    }
		});

		if (savedInstanceState != null) {
			homeWebView.restoreState(savedInstanceState);
		} else {
			/** Scaling, replaced by overview mode and wide view port
			Display display = getWindowManager().getDefaultDisplay();
			Point size = new Point();
			display.getSize(size);
			if (size.x <= 780) {
				int scaleRate = (int) ((size.x) / 7.8);
				Log.i("test", Integer.toString(size.x));
				homeWebView.setInitialScale(scaleRate);
			}
			*/
 
			Intent intent = getIntent();

			if (intent.getStringExtra("username").equals("") && 
					intent.getStringExtra("password").equals("")) {
				homeWebView.loadUrl("https://www.assistments.org/signup");

				
			} else {
				String username = intent.getStringExtra("username");
				String password = intent.getStringExtra("password");

				String postData = "login=" + username + "&password=" + password
						+ "&commit=Log in";
				homeWebView.postUrl(
						"https://www.assistments.org/account/login",
						EncodingUtils.getBytes(postData, "BASE64"));
			}

		}

		WebSettings settings = homeWebView.getSettings();
		settings.setSaveFormData(false);
		settings.setSavePassword(false);
		settings.setJavaScriptEnabled(true);
		settings.setBuiltInZoomControls(true);
		settings.setDisplayZoomControls(false);
		settings.setJavaScriptCanOpenWindowsAutomatically(true);
		settings.setSupportMultipleWindows(true);
		settings.setCacheMode(WebSettings.LOAD_NO_CACHE);
		settings.setAppCacheEnabled(false);
		settings.setDomStorageEnabled(true);
		settings.setDatabaseEnabled(true);
		settings.setUseWideViewPort(false);
		settings.setLoadWithOverviewMode(true);
		homeWebView.clearCache(true);
		homeWebView.setPadding(0,0,0,0);
		homeWebView.setInitialScale(getScale());
		
		
		btnBack = (Button) findViewById(R.id.btnBack);
		btnBack.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				homeWebView.goBack();
			}
		});
		
		btnRefresh = (Button) findViewById(R.id.btnRefresh);
        btnRefresh.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				
				//homeWebView.zoomOut();
				homeWebView.scrollTo(1000, 0);
				Log.i("test","111");
				//homeWebView.reload();
			}
		});
		
		btnForward = (Button) findViewById(R.id.btnForward);
		btnForward.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				homeWebView.goForward();
			}
		});
		
		btnOffline = (Button) findViewById(R.id.btnOffline);
		btnOffline.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if(toggle){
					homeWebView.loadUrl("https://www.assistments.org/assistments/student/index.html#offlineUserAssignmentList/");
					btnOffline.setText("Home");
					toggle = false;
				}else{
					if(isTeacher){
						homeWebView.loadUrl("https://www.assistments.org/teacher");
					}else{
						homeWebView.loadUrl("https://www.assistments.org/tutor");
					}
					btnOffline.setText("Offline");
					toggle = true;
				}
				
				
			}
		});
	}

	/**
	 * Save state of the web site for device rotation.
	 */
	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		homeWebView.saveState(outState);
	}
	
	 private int getScale()
	    {
	        Display display = ((WindowManager) getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
	        int width = display.getWidth();
	        Double val = new Double(width) / 800d;
	        val = val * 100d;
	        Log.i("test", Integer.toString(val.intValue()));
	        return val.intValue();
	    }

}
