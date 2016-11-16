package com.mad.weimiao.voicesearch_lite;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;

import java.util.ArrayList;

public class VoiceInTextActivity extends ListActivity {

    //save the array list form first activity to a list view.
    private ArrayList<String> listItems=new ArrayList<String>();
    private ArrayAdapter<String> adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_voice_in_text);

        Intent get_intent = getIntent();
        listItems = get_intent.getStringArrayListExtra("result_array");

        adapter = new ArrayAdapter<String>(this,
                  android.R.layout.simple_list_item_1,listItems);
        setListAdapter(adapter);

        getListView().setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> myAdapter, View myView, int myItemInt, long mylng) {
                String selectedFromList = (String) (getListView().getItemAtPosition(myItemInt));
                Intent returnIntent = new Intent();
                if(selectedFromList.isEmpty()){
                    setResult(Activity.RESULT_CANCELED, returnIntent);
                    finish();
                }else {
                    returnIntent.putExtra("result", selectedFromList);
                    setResult(Activity.RESULT_OK, returnIntent);
                    //System.out.println(selectedFromList);
                    finish();
                }
            }
        });
    }

}
