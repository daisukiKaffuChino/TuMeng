require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.support.design.widget.CoordinatorLayout"
import "android.support.design.widget.CollapsingToolbarLayout"
import "android.support.v7.widget.Toolbar"
import "android.support.design.widget.AppBarLayout"
import "android.support.v4.widget.NestedScrollView"
import "android.support.v7.widget.RecyclerView"
import "mods.Chimame_Core"

--沉浸状态栏()
状态栏颜色(0xffff9db6)
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

layout={
  CoordinatorLayout,
  layout_width="fill",
  layout_height="fill",
  fitsSystemWindows="true",

  {
    AppBarLayout,
    layout_width="fill",
    layout_height="256dp",
    id="mAppBarLayout",
    background=backgroundc,
    {
      CollapsingToolbarLayout,
      layout_width="fill",
      layout_height="fill",
      fitsSystemWindows="true",
      contentScrimColor=backgroundc,
      layout_scrollFlags="scroll|exitUtilCollapsed",
      title="关于图萌",
      expandedTitleColor="#FFFFFF",
      collapsedTitleTextColor=primaryc,
      {
        ImageView,
        layout_width="fill",
        layout_height="fill",
        scaleType="centerCrop",
        src="res/about_appbar_bg.png",
        layout_collapseMode="parallax",
        layout_collapseParallaxMultiplier="0.6",
      },
      {
        Toolbar,
        layout_width="fill",
        layout_height="56dp",
        layout_collapseMode="pin",
      },
    },
  },

  {
    NestedScrollView,
    layout_width="fill",
    layout_height="fill",
    layout_behavior="@string/appbar_scrolling_view_behavior",
    {
      LinearLayout;
      layout_width="fill";
      layout_height="fill";
      Orientation="vertical";
      {
        CardView;
        CardElevation="0dp";
        CardBackgroundColor="#FFE0E0E0";
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
        CardBackgroundColor="#FFE0E0E0";
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
              layout_marginBottom="-10dp";
              layout_marginTop="6dp";
              orientation="horizontal";
              {
                ImageView;
                layout_width="30dp";
                layout_margin="10dp";
                layout_marginLeft="0dp";
                layout_height="30dp";
                src="res/update.png";
                ColorFilter=primaryc,
              };

              {
                LinearLayout;
                layout_width="fill";
                layout_marginLeft="10dp";
                layout_marginRight="10dp";
                orientation="vertical";
                {
                  TextView;
                  text="正在检查更新...";
                  Typeface=字体("product-Bold");
                  layout_marginTop="15dp";
                  textColor=textc;
                  textSize="15sp";
                  id="up_title";
                };
                {
                  TextView;
                  text="";
                  layout_marginTop="5dp";
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
                  paddingRight="12dp";
                  paddingLeft="12dp";
                  paddingTop="8dp";
                  paddingBottom="8dp";
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
                      textColor="#ffffffff";
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
        CardBackgroundColor="#FFE0E0E0";
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
              onClick=function()浏览器打开("https://github.com/daisukiKaffuChino/Chimame-Browser")end;
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
        orientation="vertical";
        layout_height="fill";
        layout_width="fill";
        orientation="horizontal";
        {
          LinearLayout;
          layout_height="fill";
          layout_width="50%w";
          {
            CardView;
            CardElevation="0dp";
            CardBackgroundColor="#FFE0E0E0";
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
          layout_width="50%w";
          {
            CardView;
            CardElevation="0dp";
            CardBackgroundColor="#FFE0E0E0";
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



      {
        LinearLayout;--占位
        layout_height="150dp";
      },
    },


    -------------
  },
}


activity.setContentView(loadlayout(layout))

波纹({coolapk,gayhub,bili},"圆黑白自适应")
波纹({隐私政策,协议,opensource,open_source,check_update_layout},"方黑白自适应")


mAppBarLayout.addOnOffsetChangedListener( AppBarLayout.OnOffsetChangedListener {
  onOffsetChanged = function(appBarLayout,verticalOffset)
    if verticalOffset <= -500 then
      状态栏颜色(转0x(backgroundc))
     else
      状态栏颜色(0xffff9db6)
    end
  end
})


import "bmob"
function update()
  up_title.setText("正在检查更新...")
  当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob("","")
  b:query("tumengUpadte",function(code,json)--草，update拼错了可是不能改了
    if code~=-1 and code>=200 and code<400 then
      -------主要逻辑开始
      if (json.results[1].newVerCode>当前版本)then
        --判断远程的版本是否大于软件内部的版本，大于则进行更新
        up_title.setText("发现新版本:"..json.results[1].newVerName)
        up_subtitle.setText(json.results[1].updateMessage)
        gotoUpdate.Visibility=0
       else
        up_title.setText("已经是最新了")
        up_subtitle.setText(nil)
        gotoUpdate.Visibility=8
      end
      -------主要逻辑结束
     else
      up_title.setText("连接服务器失败")
      up_subtitle.setText("code:"..tostring(code))
      gotoUpdate.Visibility=8
    end
  end)
end

Thread(Runnable({--java线程处理耗时的网络请求，继承runnable
  run=function()
    update()
  end
})).start()



