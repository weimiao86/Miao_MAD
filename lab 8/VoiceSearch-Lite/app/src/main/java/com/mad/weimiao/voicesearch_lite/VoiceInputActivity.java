package com.mad.weimiao.voicesearch_lite;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Locale;

public class VoiceInputActivity extends AppCompatActivity {

    private TextView resultText;
    private ImageButton searchBtn;
    private final int REQ_CODE_SPEECH_INPUT = 100;
    private final int DISPLAY_VOICE_RESULT = 101;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_voice_input);
        resultText = (TextView)findViewById(R.id.resultText);
        searchBtn = (ImageButton)findViewById(R.id.searchButton);
        searchBtn.setVisibility(View.INVISIBLE);
        ImageButton voiceInput = (ImageButton)findViewById(R.id.voiceButton);
        voiceInput.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                promptSpeechInput();
                searchBtn.setVisibility(View.INVISIBLE);
            }
        });
        searchBtn.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v){
                searchGoogle();
            }
        });
    }

    // show speech input dialog
    private void promptSpeechInput() {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault());
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT,
                getString(R.string.speech_prompt));
        try {
            startActivityForResult(intent, REQ_CODE_SPEECH_INPUT);
        } catch (ActivityNotFoundException a) {
            Toast.makeText(getApplicationContext(),
                    getString(R.string.speech_not_supported),
                    Toast.LENGTH_SHORT).show();
        }
    }

    //get the voice recognized result.
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        switch (requestCode) {
            case REQ_CODE_SPEECH_INPUT: {
                if (resultCode == RESULT_OK && null != data) {

                    ArrayList<String> result = data
                            .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                    voice2text(result);
                }
                break;
            }
            case DISPLAY_VOICE_RESULT: {
                if (resultCode == Activity.RESULT_OK && null != data){
                    String selectedStr = data.getStringExtra("result");
                    System.out.println(selectedStr);
                    resultText.setText(selectedStr);
                    searchBtn.setVisibility(View.VISIBLE);
                }
                if (resultCode == RESULT_CANCELED) {
                    resultText.setText(R.string.nothing_catched);
                }
                break;
            }
            default: break;
        }
    }

    //pass the result array to second activity
    protected void voice2text(ArrayList<String> result_strs) {
        Intent intent = new Intent(this, VoiceInTextActivity.class);
        intent.putStringArrayListExtra("result_array", result_strs);
        try {
            startActivityForResult(intent, DISPLAY_VOICE_RESULT);
        } catch (ActivityNotFoundException a) {
            Toast.makeText(getApplicationContext(),
                    getString(R.string.nothing_catched),
                    Toast.LENGTH_SHORT).show();
        }
    }

    //search the selected text
    protected void searchGoogle(){
        String searchValue = resultText.getText().toString();
        String searchText = "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q="
                + searchValue;
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(searchText));
        startActivity(intent);
    }

}
