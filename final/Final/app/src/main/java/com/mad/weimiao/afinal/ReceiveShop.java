package com.mad.weimiao.afinal;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

public class ReceiveShop extends AppCompatActivity {
    private String myshop;
    private String myURL;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receive_shop);
        Intent intent = getIntent();
        myshop = intent.getStringExtra("shop");
        myURL = intent.getStringExtra("url");

        TextView messageView = (TextView) findViewById(R.id.textView);
        messageView.setText("You should check out " + myshop);
    }
    void getStore(View view){
        loadWebSite(view);
    }
    public void loadWebSite(View view){
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(myURL));
        startActivity(intent);
    }
}
