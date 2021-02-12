--弃用appbarlayout,重写了兼容androlua+的伸缩标题栏
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "com.github.ksoichiro.android.observablescrollview.*"--导入ObservableScrollView，容易监听滑动
import "mods.Chimame_Core"

沉浸状态栏()
activity.overridePendingTransition(android.R.anim.slide_in_left,android.R.anim.fade_out)

function GetAppVer(包名,类别)
  import "android.content.pm.PackageManager"
  local 版本号 = activity.getPackageManager().getPackageInfo(包名, 0).versionCode
  local 版本名 = activity.getPackageManager().getPackageInfo(包名, 0).versionName
  if 类别==nil then
    return 版本名
   else
    return 版本号
  end
end

if openactivity.getData("Setting_Theme_Color")==0 then
  bkg="res/about_appbar_bg1.png"
 else
  bkg="res/about_appbar_bg2.png"
end

layout={--页面布局
  LinearLayout;
  layout_height="-1";
  layout_width="-1";
  id="_root";
  orientation="vertical";
  {
    RelativeLayout;--RelativeLayout中
    layout_height="-1";
    layout_width="-1";
    background=write;
    {
      LinearLayout;
      layout_height="-1";
      layout_width="-1";
      orientation="vertical";
      {
        ObservableScrollView;
        layout_width="-1";
        layout_height="-1";
        id="obs_1";
        overScrollMode=2;
        {
          LinearLayout;
          layout_height="-1";
          layout_width="-1";
          orientation="vertical";
          --paddingTop=dp2px(200)+状态栏高度;--抵消顶部遮盖部分高度
          {
            LinearLayout;
            layout_height="150dp";
            layout_width="-1";
            background=primaryc;
            {
              ImageView;
              layout_height="-1";
              layout_width="-1";
              src=bkg;
              scaleType="centerCrop";
              id="pho_top";
            };
          };
          {
            LinearLayout;
            layout_width="fill";
            layout_height="fill";
            Orientation="vertical";
            {
              CardView;
              CardElevation="0dp";
              CardBackgroundColor=卡片边框灰色;
              Radius="8dp";
              layout_width="-1";
              layout_height="-2";
              layout_margin="16dp";
              layout_marginBottom="24dp";
              {
                CardView;
                CardElevation="0dp";
                CardBackgroundColor=backgroundc;
                Radius=dp2px(8)-2;
                layout_margin="2px";
                layout_width="-1";
                layout_height="-1";
                {
                  LinearLayout;
                  layout_width="fill";
                  gravity="center|left";
                  orientation="horizontal";
                  {
                    ImageView;
                    layout_width="30dp";
                    layout_margin="10dp";
                    layout_height="30dp";
                    src="res/greenAppOfAndroid.png";
                    -- ColorFilter=primaryc,
                  };
                  {
                    LinearLayout;
                    layout_width="fill";
                    layout_marginLeft="10dp";
                    layout_marginRight="10dp";
                    orientation="vertical";
                    {
                      TextView;
                      text="遵循《Android绿色应用公约》(Comply to “Convention of Green Apps for Android”)";
                      Typeface=字体("product-Bold");
                      textColor=textc;
                      textSize="11sp";
                    };
                  };
                };
              };
            };
            {
              LinearLayout;
              layout_width="fill";
              layout_height="fill";
              padding="8dp";
              layout_marginBottom="24dp",
              Orientation="vertical";
              {
                TextView;
                layout_width="100dp";
                layout_height="-2";
                gravity="center";
                text="开发人员";
                Typeface=字体("product-Bold");
                layout_marginLeft="8dp";
                textColor=primaryc;
                textSize="17dp";
              };
              {
                LinearLayout;
                layout_width="fill";
                gravity="center|left";
                orientation="vertical";
                {
                  LinearLayout;
                  orientation="horizontal";
                  layout_width="fill";
                  {
                    ImageView;
                    layout_width="72dp";
                    layout_height="72dp";
                    padding="12dp";
                    layout_marginLeft="12dp";
                    src="res/watashi.png";
                  };
                  {
                    LinearLayout;
                    layout_weight="1",
                  },
                  {
                    ImageView;
                    layout_width="38dp";
                    layout_height="38dp";
                    padding="7dp";
                    layout_gravity="center|right",
                    src="res/coolapk.png";
                    id="coolapk",
                    onClick=function()
                      if pcall(function() activity.getPackageManager().getPackageInfo("com.coolapk.market",0) end) then
                        intent=Intent("android.intent.action.VIEW")
                        intent.setPackage("com.coolapk.market")
                        intent.setData(Uri.parse("coolmarket://u/2492447"))
                        intent.addFlags(intent.FLAG_ACTIVITY_NEW_TASK)
                        this.startActivity(intent)
                       else
                        提示("未安装酷安(com.coolapk.market)")
                      end
                    end,
                  };
                  {
                    ImageView;
                    layout_width="38dp";
                    layout_height="38dp";
                    padding="7dp";
                    layout_gravity="center|right",
                    src="res/github.png";
                    id="gayhub",
                    onClick=function()浏览器打开("https://github.com/daisukiKaffuChino")end,
                  };
                  {
                    ImageView;
                    layout_width="38dp";
                    layout_height="38dp";
                    padding="7dp";
                    layout_marginRight="8dp",
                    layout_gravity="center|right",
                    src="res/bili.png";
                    id="bili",
                    onClick=function()提示("UID:178423358")end,
                  };
                },
                {
                  TextView;
                  text="酷安@得想办法娶了智乃";
                  Typeface=字体("product-Bold");
                  textColor=textc;
                  layout_marginLeft="24dp";
                  textSize="15sp";
                };
                {
                  TextView;
                  text="前端/后端/运营";
                  textColor=stextc;
                  layout_marginLeft="24dp";
                  layout_marginTop="4dp";
                  Typeface=字体("product");
                  textSize="12sp";
                };
              };
            };
            {
              CardView;
              CardElevation="0dp";
              CardBackgroundColor=卡片边框灰色;
              Radius="8dp";
              layout_width="-1";
              layout_height="-2";
              layout_margin="16dp";
              layout_marginTop="0";
              id="up_card";
              Visibility=0;
              {
                CardView;
                CardElevation="0dp";
                CardBackgroundColor=backgroundc;
                Radius=dp2px(8)-2;
                layout_margin="2px";
                layout_width="-1";
                layout_height="-1";
                {
                  LinearLayout;
                  layout_width="-1";
                  layout_height="-2";
                  orientation="vertical";
                  layout_marginBottom="-10dp";
                  padding="24dp";
                  paddingTop="12dp";
                  {
                    TextView;
                    text="应用更新";
                    textColor=primaryc;
                    textSize="17dp";
                    gravity="center|left";
                    Typeface=字体("product-Bold");
                  };
                  {
                    LinearLayout;
                    layout_width="fill";
                    gravity="center|left";
                    orientation="horizontal";
                    {
                      ImageView;
                      layout_width="40dp";
                      padding="8dp";
                      paddingLeft="0dp";
                      layout_height="40dp";
                      src="res/update.png";
                      layout_gravity="center|left";
                      ColorFilter=primaryc,
                    };
                    {
                      LinearLayout;
                      layout_width="fill";
                      layout_marginLeft="8dp";
                      orientation="vertical";
                      {
                        TextView;
                        text="正在检查更新...";
                        Typeface=字体("product-Bold");
                        layout_marginTop="8dp";
                        textColor=textc;
                        textSize="15sp";
                        id="up_title";
                      };
                      {
                        TextView;
                        text="";
                        layout_marginTop="4dp";
                        textColor=textc;
                        Typeface=字体("product");
                        textSize="13sp";
                        id="up_subtitle";
                      };
                    };
                  };
                  {
                    CardView;
                    layout_width="-2";
                    layout_height="-2";
                    radius="4dp";
                    background="#00ffffff";
                    layout_gravity="right";
                    Elevation="0";
                    layout_marginTop="4dp";
                    {
                      LinearLayout;
                      layout_width="-1";
                      layout_height="-1";
                      orientation="horizontal";
                      {
                        TextView;
                        layout_width="-1";
                        layout_height="-2";
                        textSize="14sp";
                        padding="12dp";
                        paddingBottom="2dp";
                        layout_gravity="center";
                        Text="去下载";
                        textColor=primaryc;
                        id="gotoUpdate";
                        gravity="center";
                        Visibility=8,
                        Typeface=字体("product-Bold");
                        onClick=function()浏览器打开("https://chino.lanzous.com/b0ddp10mf")end;
                        BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
                      };
                      {
                        CardView;
                        layout_width="90dp";
                        layout_gravity="center";
                        layout_height="35dp";
                        layout_marginLeft="16dp";
                        layout_marginRight="0dp";
                        background=primaryc;
                        Elevation='1dp';--阴影属性
                        id="check_update";
                        radius='6dp';--卡片圆角
                        {
                          LinearLayout;
                          layout_width="fill";
                          -- layout_gravity="right";
                          layout_height="fill";
                          gravity="center";
                          onClick=function()update()end;
                          id="check_update_layout";
                          {
                            TextView;
                            text="检查更新";
                            layout_gravity="center";
                            textSize="14dp";
                            Typeface=字体("product-Bold");
                            textColor=backgroundc;
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
            {
              CardView;
              CardElevation="0dp";
              CardBackgroundColor=卡片边框灰色;
              Radius="8dp";
              layout_width="-1";
              layout_height="-2";
              layout_margin="16dp";
              layout_marginTop="0";
              {
                CardView;
                CardElevation="0dp";
                CardBackgroundColor=backgroundc;
                Radius=dp2px(8)-2;
                layout_margin="2px";
                layout_width="-1";
                layout_height="-1";
                {
                  LinearLayout;
                  layout_width="-1";
                  layout_height="-1";
                  orientation="vertical";
                  padding="24dp";
                  paddingTop="12dp";
                  paddingBottom="8dp";
                  {
                    TextView;
                    text="此项目已开源";
                    textColor=primaryc;
                    textSize="17sp";
                    gravity="center|left";
                    Typeface=字体("product-Bold");
                  };
                  {
                    TextView;
                    text="基于轻量级框架 Androlua+的开发实践——为了更优美、更优质的Lua应用，冲鸭！ヾ(❀╹◡╹)ﾉ~";
                    textColor=stextc;
                    textSize="13sp";
                    gravity="center|left";
                    Typeface=字体("product");
                    layout_marginTop="12dp";
                  };
                  {
                    CardView;
                    layout_width="-2";
                    layout_height="-2";
                    radius="4dp";
                    background="#00ffffff";
                    layout_gravity="right";
                    Elevation="0";
                    layout_marginTop="4dp";
                    --     onClick=function()浏览器打开("http://mukapp.top/index.php/mdesign.html")end;
                    onClick=function()浏览器打开("https://github.com/daisukiKaffuChino/TuMeng")end;
                    {
                      TextView;
                      layout_width="-1";
                      layout_height="-1";
                      textSize="14sp";
                      paddingRight="12dp";
                      paddingLeft="12dp";
                      paddingTop="8dp";
                      paddingBottom="8dp";
                      Text="访问Github…";
                      textColor=primaryc;
                      id="open_source";
                      gravity="center";
                      Typeface=字体("product-Bold");
                    };
                  };
                };
              };
            };
            {
              LinearLayout;
              layout_height="fill";
              layout_width="fill";
              orientation="horizontal";
              {
                LinearLayout;
                layout_height="fill";
                layout_weight="1";
                layout_width="0";
                {
                  CardView;
                  CardElevation="0dp";
                  CardBackgroundColor=卡片边框灰色;
                  Radius="8dp";
                  layout_width="-1";
                  layout_height="140dp";
                  layout_margin="16dp";
                  layout_marginRight="8dp";
                  {
                    CardView;
                    CardElevation="0dp";
                    CardBackgroundColor=backgroundc;
                    Radius=dp2px(8)-2;
                    layout_margin="2px";
                    layout_width="-1";
                    layout_height="-1";

                    {
                      LinearLayout;
                      orientation="vertical";
                      layout_width="fill";
                      layout_height="fill";
                      {
                        ImageView;
                        src=图标("info");
                        layout_height="48dp";
                        layout_width="48dp";
                        paddingLeft="16dp",
                        ColorFilter=primaryc,
                        padding="12dp",
                      };
                      {
                        TextView;
                        text="VersionName:\n"..GetAppVer(activity.getPackageName(),_);
                        Typeface=字体("product-Medium");
                        textColor=textc;
                        textSize="13sp";
                        paddingLeft="16dp",
                        paddingRight="12dp",
                      };
                      {
                        TextView;
                        text="VersionCode:\n"..tostring(GetAppVer(activity.getPackageName(),"1"));
                        Typeface=字体("product-Medium");
                        textColor=textc;
                        textSize="13sp";
                        paddingTop="6dp",
                        paddingLeft="16dp",
                        layout_width="fill";
                        paddingRight="12dp",
                      };
                    };
                  };
                };
              },
              {
                LinearLayout;
                layout_height="fill";
                layout_weight="1";
                layout_width="0";
                {
                  CardView;
                  CardElevation="0dp";
                  CardBackgroundColor=卡片边框灰色;
                  Radius="8dp";
                  layout_width="-1";
                  layout_height="140dp";
                  layout_margin="16dp";
                  layout_marginLeft="8dp";
                  {
                    CardView;
                    CardElevation="0dp";
                    CardBackgroundColor=backgroundc;
                    Radius=dp2px(8)-2;
                    layout_margin="2px";
                    layout_width="-1";
                    layout_height="-1";

                    {
                      LinearLayout;
                      orientation="vertical";
                      layout_width="fill";
                      layout_height="fill";
                      {
                        ImageView;
                        src="res/xml_black.png";
                        layout_height="48dp";
                        layout_width="48dp";
                        ColorFilter=primaryc,
                        padding="12dp",
                      };
                      {
                        TextView;
                        text="图萌的诞生离不开这些开源项目。";
                        Typeface=字体("product-Bold");
                        textColor=textc;
                        textSize="13sp";
                        paddingLeft="12dp",
                        paddingRight="12dp",
                      };
                      {
                        TextView;
                        text="查看详情...";
                        Typeface=字体("product-Bold");
                        textColor=stextc;
                        gravity="right";
                        textSize="13sp";
                        paddingTop="12dp",
                        layout_width="fill";
                        paddingRight="12dp",
                        id="opensource",
                        onClick=function()
                          activity.newActivity("mods/openSource")
                        end,
                      };
                    };
                  };
                },
              },
            },
            {
              LinearLayout;
              layout_width="fill";
              gravity="center|left";
              orientation="horizontal";
              layout_marginLeft="8dp";
              {
                ImageView;
                layout_width="20dp";
                layout_margin="15dp";
                layout_height="20dp";
                src="res/twotone_copyright_black_24dp.png";
                ColorFilter=stextc,
              };
              {
                LinearLayout;
                layout_width="fill";
                layout_marginLeft="3dp";
                layout_marginRight="10dp";
                orientation="vertical";
                {
                  TextView;
                  text="版权所有©2019-2021 得想办法娶了智乃。保留所有权利。";
                  Typeface=字体("product-Bold");
                  textColor=textc;
                  textSize="11sp";
                };
                {
                  LinearLayout;
                  orientation="horizontal";
                  {
                    TextView;
                    text="软件许可使用协议";
                    Typeface=字体("product-Bold");
                    textColor=secondaryc;
                    textSize="11sp";
                    id="协议";
                    onClick=function()
                      activity.newActivity("mods/agreement",{1})
                    end,
                  };
                  {
                    TextView;
                    text=" | ";
                    Typeface=字体("product-Bold");
                    textColor=secondaryc;
                    textSize="11sp";
                  };
                  {
                    TextView;
                    text="隐私政策";
                    Typeface=字体("product-Bold");
                    textColor=secondaryc;
                    textSize="11sp";
                    id="隐私政策";
                    onClick=function()
                      activity.newActivity("mods/agreement",{2})
                    end,
                  };
                };
              },
            };
          },
        };
      };
    };
    {--顶栏布局（背景)
      LinearLayout;
      layout_height="-2";
      layout_width="-1";
      background=primaryc;
      elevation="4dp";
      orientation="vertical";
      id="_topbar";
      {--状态栏占位布局
        TextView;
        layout_height=状态栏高度;
        layout_width="-1";
      };
      {--标题栏布局（背景)
        LinearLayout;
        layout_height="56dp";
        layout_width="-1";
        id="_topbar_top";
      };
    };
    {--顶栏布局（标题）
      LinearLayout;
      layout_height="-2";
      layout_width="-1";
      elevation="4dp";
      orientation="vertical";
      id="_topbar2";
      {--状态栏占位布局
        TextView;
        layout_height=状态栏高度;
        layout_width="-1";
      };
      {
        LinearLayout;
        layout_height="-1";
        layout_width="-1";
        gravity="left|top";
        layout_weight="1";
        {
          ImageView;
          layout_width="56dp";
          layout_height="56dp";
          padding="16dp";
          ColorFilter=write;
          src="res/twotone_arrow_back_black_24dp.png";
          onClick=function()关闭页面()end;
          id="_back";
        };
      };
      {--标题栏布局
        LinearLayout;
        layout_height="150dp";
        layout_width="-1";
        gravity="left|center";
        id="_title2";
        {
          TextView;
          Text="关于图萌";
          textColor=0xffffffff;
          textSize="19sp";
          PivotX=0;
          paddingLeft="16dp";
          id="_title";
        };
      };
    };
  };
};

设置视图(layout)

波纹({_back},"圆白")

_topbar.alpha=0

_title2.setX(0)
_title2.setY(dp2px(-36+1+2+1))
_title2.ScaleX=1-0*0.03;
_title2.ScaleY=1-0*0.03;

obs_1.setScrollViewCallbacks(ObservableScrollViewCallbacks{
  --滚动时
  onScrollChanged=function(scrollY,firstScroll,dragging)

    obs1_lst_lst=obs1_lst
    obs1_lst=scrollY
    if obs1_lst_lst==nil then
      obs1_lst_lst=obs1_lst
    end
    apa=1-(obs1_lst/(dp2px(150-56)-状态栏高度))
    apb=(obs1_lst/(dp2px(56)-状态栏高度))
    if obs1_lst==0 then--原位
      _title2.setX(0)
      _title2.setY(dp2px(48-2))
      _title2.ScaleX=1-apb*0.03;
      _title2.ScaleY=1-apb*0.03;
     elseif apa>=0 and obs1_lst<(dp2px(150-56)-状态栏高度) then--在滑动但是没到顶
      _title2.setY(-obs1_lst+dp2px(24+24))
      _title2.setX(apb*dp2px(56-24-18+3))
      _title2.ScaleX=1-apb*0.03;
      _title2.ScaleY=1-apb*0.03;
     elseif obs1_lst>=(dp2px(150-56)-状态栏高度) then--到顶以后

      _title2.setY(-(dp2px(150-56)-状态栏高度)+dp2px(24+6+8+9+2))
      _title2.setX(2*dp2px(56-24-18+12))
      _title2.ScaleX=1-2*0.03;
      _title2.ScaleY=1-2*0.03;
    end
    if apa<=0 then
      _topbar.alpha=1
     else
      _topbar.alpha=0
    end
    pho_top.alpha=apa
  end,

})

波纹({coolapk,gayhub,bili},"圆黑白自适应")
波纹({隐私政策,协议,opensource,open_source,check_update_layout},"方黑白自适应")





