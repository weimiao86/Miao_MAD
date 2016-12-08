package com.mad.weimiao.afinal;

/**
 * Created by mira67 on 12/8/16.
 */

public class IceCream {
    private String icecreamShop;
    private String icecreamURL;

    void setCreamInfo(Integer cream){
        switch(cream){
            case 0:
                icecreamShop = "Glacier";
                icecreamURL = "http://www.glaciericecream.com/";
                break;
            case 1:
                icecreamShop = "Sweet Cow";
                icecreamURL = "http://www.sweetcowicecream.com/";
                break;
            case 2:
                icecreamShop = "Fior di Latte";
                icecreamURL = "http://fiordilattegelato.com/";
                break;
            default:
                icecreamShop = "None";
                icecreamURL = "http://www.glaciericecream.com/";
                break;
        }
    }

    public void seticecreamShop(Integer cream){

        setCreamInfo(cream);
    }

    public void seticecreamURL(Integer cream){

        setCreamInfo(cream);
    }

    public String getShop(){

        return icecreamShop;
    }

    public String getURL(){

        return icecreamURL;
    }
}
