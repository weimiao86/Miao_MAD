package com.mad.weimiao.subaruorder;

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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final ImageView modelImage = (ImageView)findViewById(R.id.carImage);
        Spinner modelSpinner = (Spinner)findViewById(R.id.modelSpinner);
        //spinner onItemSelectedListener to update image
        modelSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

                switch (position) {
                    case 0:
                        modelImage.setImageResource(R.drawable.brz);
                        break;
                    case 1:
                        modelImage.setImageResource(R.drawable.impreza);
                        break;
                    case 2:
                        modelImage.setImageResource(R.drawable.wrx);
                        break;
                    case 3:
                        modelImage.setImageResource(R.drawable.legacy);
                        break;
                    case 4:
                        modelImage.setImageResource(R.drawable.forester);
                        break;
                    case 5:
                        modelImage.setImageResource(R.drawable.crosstrek);
                        break;
                    case 6:
                        modelImage.setImageResource(R.drawable.outback);
                        break;
                    default:
                        modelImage.setImageResource(R.drawable.brz);
                        break;
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                modelImage.setImageResource(R.drawable.brz);
            }
        });
    }
    //update order info text
    public void placeOrder(View view) {
        //order text
        TextView orderInfo = (TextView)findViewById(R.id.orderText);
        //get username
        EditText userName = (EditText)findViewById(R.id.userNameEditText);
        //switch to control if name is visible
        Switch nameVisible = (Switch)findViewById(R.id.visibleSwitch);
        boolean isVisible = nameVisible.isChecked();
        String name;
        if(!isVisible) {
            name = "Someone";
        }else{
            name = userName.getText().toString();
        }
        //get model
        Spinner modelSpinner = (Spinner)findViewById(R.id.modelSpinner);
        String selectedModel = String.valueOf(modelSpinner.getSelectedItem());
        //get year
        RadioGroup years =(RadioGroup)findViewById(R.id.yearRadio);
        String year;
        int years_id=years.getCheckedRadioButtonId();
        switch(years_id){
            case -1:
                year=" ";
                break;
            case R.id.R_2015:
                year=" 2015 ";
                break;
            case R.id.R_2016:
                year=" 2016 ";
                break;
            case R.id.R_2017:
                year=" 2017 ";
                break;
            default:
                year=" ";
        }
        //get condition
        ToggleButton cdts = (ToggleButton)findViewById(R.id.cdtToggleButton);
        boolean isOld = cdts.isChecked();
        String ctd;
        if(isOld){
            ctd = " an old";
        }else{
            ctd = " a new";
        }
        //get color
        Spinner colors = (Spinner)findViewById(R.id.colorSpinner);
        String selectedColor = String.valueOf(colors.getSelectedItem());
        //get Acc
        String Acc = "";
        CheckBox Acc1 = (CheckBox)findViewById(R.id.checkBox1);
        boolean isAcc1 = Acc1.isChecked();
        if(isAcc1){
            Acc += " Subwoofer.";
        }
        CheckBox Acc2 = (CheckBox)findViewById(R.id.checkBox2);
        boolean isAcc2 = Acc2.isChecked();
        if(isAcc2){
            Acc += " Alloy Wheel.";
        }
        CheckBox Acc3 = (CheckBox)findViewById(R.id.checkBox3);
        boolean isAcc3 = Acc3.isChecked();
        if(isAcc3){
            Acc += " Cargo Tray.";
        }

        if(!isAcc1 && !isAcc2 && !isAcc3){
            Acc = " none.";
        }

        //set order info
        orderInfo.setText(name + " ordered"
                            + ctd + year + selectedModel
                            + " of color " + selectedColor
                            + " and with accessories: " + Acc);

    }
}
