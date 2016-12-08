package com.mad.weimiao.afinal;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.ToggleButton;

public class MainActivity extends AppCompatActivity {

    private IceCream myShop = new IceCream();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Spinner flavorSpinner = (Spinner)findViewById(R.id.flavor_spinner);
        final ImageView treatImage = (ImageView)findViewById(R.id.treatImage);
        flavorSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                switch (i){
                    case 0:
                        treatImage.setImageResource(R.drawable.cookiescream);
                        break;
                    case 1:
                        treatImage.setImageResource(R.drawable.chocolate);
                        break;
                    case 2:
                        treatImage.setImageResource(R.drawable.caramel);
                        break;
                    default:
                        treatImage.setImageResource(R.drawable.caramel);
                        break;
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
                treatImage.setImageResource(R.drawable.caramel);
            }
        });

    }

    void treatMe(View view){
        EditText treatText = (EditText)findViewById(R.id.treat_in);
        Switch dairySwitch = (Switch)findViewById(R.id.dairy_switch);
        Spinner flavorSpinner = (Spinner)findViewById(R.id.flavor_spinner);
        ToggleButton isCup = (ToggleButton)findViewById(R.id.toggleButton);
        RadioGroup type = (RadioGroup)findViewById(R.id.radioGroup);
        CheckBox check1 = (CheckBox)findViewById(R.id.checkBox1);
        CheckBox check2 = (CheckBox)findViewById(R.id.checkBox2);
        CheckBox check3 = (CheckBox)findViewById(R.id.checkBox3);
        TextView orderText = (TextView)findViewById(R.id.orderText);

        String treat = treatText.getText().toString();
        String dairy = "";
        String cup = "";
        String treatType = "";
        String flavor= "";
        String acc = "";
        int flav = flavorSpinner.getSelectedItemPosition();
        switch (flav){
            case 0:
                flavor = "Death by Chocolate";
                break;
            case 1:
                flavor = "Cookies and Cream";
                break;
            case 2:
                flavor = "Salted Caramel";
                break;
            default:
                flavor = "Salted Caramel";
                break;
        }


        boolean isdairy = dairySwitch.isChecked();
        if(isdairy){
            dairy = " dairy free ";
        }else{
            dairy = " ";
        }

        boolean cups = isCup.isChecked();
        if(cups){
            cup = " cup ";
        }else{
            cup = " cone ";
        }

        int types = type.getCheckedRadioButtonId();
        switch (types){
            case -1:
                treatType = "ice cream";
                break;
            case R.id.radioButton1:
                treatType = " ice cream ";
                break;
            case R.id.radioButton2:
                treatType = " frozen yogurt ";
                break;
            case R.id.radioButton3:
                treatType = " gelato ";
                break;
            default:
                treatType = " ice cream ";
                break;
        }

        if(check1.isChecked()){
            acc+=" sprinkles ";
        }
        if(check2.isChecked()){
            acc+=" hot fudge ";
        }
        if(check3.isChecked()){
            acc+=" nuts ";
        }

        String order = "My " + treat +" is a " + dairy + flavor + treatType + cup + " with " + acc;
        orderText.setText(order);
    }

    void findStore(View view){
        Spinner flavorSpinner = (Spinner)findViewById(R.id.flavor_spinner);
        Integer cream = flavorSpinner.getSelectedItemPosition();
        myShop.setCreamInfo(cream);
        String suggestShop = myShop.getShop();
        String suggestURL = myShop.getURL();
        Intent intent = new Intent(this, ReceiveShop.class);
        intent.putExtra("shop",suggestShop);
        intent.putExtra("url",suggestURL);
        startActivity(intent);
    }


}
