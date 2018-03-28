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

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Toast;

public class LoginActivity extends Activity {

	private EditText txtUsername, txtPassword;

	private Button btnLogin, btnRegister;

	private CheckBox remenberCB;

	private static final String PREFS_NAME = "preferences";
	private static final String PREF_UNAME = "Username";
	private static final String PREF_PASSWORD = "Password";

	private final String DefaultUnameValue = "";
	private String UnameValue;

	private final String DefaultPasswordValue = "";
	private String PasswordValue;

	private AlertDialogManager alert = new AlertDialogManager();

	@Override
	public void onResume() {
		super.onResume();
		txtUsername.clearFocus();
		txtPassword.clearFocus();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);

		txtUsername = (EditText) findViewById(R.id.txtUsername);
		txtPassword = (EditText) findViewById(R.id.txtPassword);

		txtUsername.setOnTouchListener(new View.OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				v.setFocusable(true);
				v.setFocusableInTouchMode(true);
				return false;
			}
		});
		txtPassword.setOnTouchListener(new View.OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				v.setFocusable(true);
				v.setFocusableInTouchMode(true);
				return false;
			}
		});

		loadPreferences();

		btnLogin = (Button) findViewById(R.id.btnLogin);
		btnLogin.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				String username = txtUsername.getText().toString();
				String password = txtPassword.getText().toString();

				if (remenberCB.isChecked()) {
					savePreferences();
				}
				if (username.equals("") || password.equals("")) {
					alert.showAlertDialog(LoginActivity.this, "Login failed..",
							"Please enter username and password", false);
				} else {
					Intent intent = new Intent(getApplicationContext(),
							MainActivity.class);
					intent.putExtra("username", username); 
					intent.putExtra("password", password);
					startActivity(intent);
					finish();
					Toast.makeText(getApplicationContext(), "Please log out before closing app", Toast.LENGTH_LONG).show();
				}
			}
		});
		
		btnRegister = (Button) findViewById(R.id.btnRegister);
		btnRegister.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent intent = new Intent(getApplicationContext(),
						MainActivity.class);
				intent.putExtra("username", "");
				intent.putExtra("password", "");
				startActivity(intent);
				finish();
				
			}
			
		});
		
		remenberCB = (CheckBox) findViewById(R.id.remenberCheckbox);

		SharedPreferences settings = getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		Log.i("test", settings.getString(PREF_UNAME, DefaultUnameValue));
		Log.i("test", settings.getString(PREF_PASSWORD, DefaultPasswordValue));
		if (settings.getString(PREF_UNAME, DefaultUnameValue).equals("")
				&& settings.getString(PREF_PASSWORD, DefaultPasswordValue)
						.equals("")) {
			remenberCB.setChecked(false);

		} else {
			remenberCB.setChecked(true);
		}

		remenberCB
				.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						if (isChecked) {
							Log.i("test", "checked");
							savePreferences();

						} else {
							Log.i("test", "unchecked");
							clearPreferences();
						}
					}
				});

		try {
			Intent intent = getIntent();
			if (intent.getStringExtra("showPopup").equals("true")) {
				alert.showAlertDialog(
						LoginActivity.this,
						"Login failed..",
						"Username or password incorrect", 
						false);
			}
		} catch (Exception e) {

		}
	}

	/**
	 * Save username and password
	 */
	private void savePreferences() {
		SharedPreferences settings = getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		UnameValue = txtUsername.getText().toString();
		PasswordValue = txtPassword.getText().toString();
		editor.putString(PREF_UNAME, UnameValue);
		editor.putString(PREF_PASSWORD, PasswordValue);
		editor.commit();
	}

	/**
	 * Load username and password
	 */
	private void loadPreferences() {

		SharedPreferences settings = getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		UnameValue = settings.getString(PREF_UNAME, DefaultUnameValue);
		PasswordValue = settings.getString(PREF_PASSWORD, DefaultPasswordValue);
		txtUsername.setText(UnameValue);
		txtPassword.setText(PasswordValue);
		Log.i("test", UnameValue);
	}

	/**
	 * Clear username and password
	 */
	private void clearPreferences() {
		SharedPreferences settings = getSharedPreferences(PREFS_NAME,
				Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		editor.putString(PREF_UNAME, "");
		editor.putString(PREF_PASSWORD, "");
		editor.commit();
	}
}