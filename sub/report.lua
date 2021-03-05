require"import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.Chimame_Core"

layout={
  RelativeLayout;
  layout_width="-1";
  background=backgroundc;
  layout_height="-1";
  {
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    orientation="vertical";

    {
      LinearLayout;
      layout_width="-1";
      layout_height="-2";
      elevation="0";
      background=backgroundc;
      orientation="vertical";
      {
        LinearLayout;
        layout_width="-1";
        layout_height="56dp";
        gravity="center|left";
        {
          LinearLayout;
          orientation="horizontal";
          layout_height="56dp";
          layout_width="56dp";
          gravity="center";
          onClick=function()关闭页面()end;
          {
            ImageView;
            ColorFilter=primaryc;
            src=图标("arrow_back");
            layout_height="32dp";
            layout_width="32dp";
            padding="4dp";
            id="fh";
          };
        };
        {
          TextView;
          textColor=primaryc;
          text="反馈问题";
          paddingLeft="16dp";
          textSize="20sp";
          layout_height="-2";
          layout_width="-2";
          Typeface=字体("product-Bold");
        };
      };
    };
    {
      LuaWebView;
      layout_width="fill";
      layout_height="fill";
      id="WebView";
    };
  };
};


activity.setContentView(loadlayout(layout))

波纹({fh},"圆自适应")

WebView.loadUrl("https://wj.qq.com/s2/7951611/98a4?_t=1611758176375")

function getCurrentAppearance()
  color="蓝粉"
  theme="浅色"
  if Boolean.valueOf(openActivity.getData("Setting_Auto_Night_Mode"))==true then
    theme="跟随系统"
   elseif Boolean.valueOf(openActivity.getData("Setting_Night_Mode"))==true then
    theme="深色"
  end
end
getCurrentAppearance()

WebView.setWebViewClient{
  onPageFinished=function(view,url)
    if theme=="深色" then
      WebView.evaluateJavascript([[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#212121 !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]],nil)
    end
  end}
  
