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


import android.app.TabActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TabHost;

public class MainActivity extends TabActivity {
	
	private TabHost mTabHost;

	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        mTabHost = getTabHost();
        TabHost.TabSpec spec;
        Intent intent = getIntent();
        
        String username = intent.getStringExtra("username");
        String password = intent.getStringExtra("password");
        intent = new Intent(this, HomeTabbedActivity.class);
        intent.putExtra("username", username);
		intent.putExtra("password", password);
        spec = mTabHost.newTabSpec("home")
        		.setIndicator("Home",getResources().getDrawable(R.drawable.internet))
        		.setContent(intent);
        
        mTabHost.addTab(spec);
        
        intent = new Intent(this, DrawingTabbedActivity.class);
        spec = mTabHost.newTabSpec("drawing")
        		.setIndicator("Scratch Pad",getResources().getDrawable(R.drawable.drawing))
        		.setContent(intent);
        
        mTabHost.addTab(spec);  
    }
        
}