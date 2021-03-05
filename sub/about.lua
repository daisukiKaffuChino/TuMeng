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
import "mods.Chimame_Core"

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

import "layout.about"

沉浸状态栏()
activity.overridePendingTransition(android.R.anim.slide_in_left,android.R.anim.fade_out)

if openActivity.getData("Setting_Theme_Color")==0 then
  bkg="res/about_appbar_bg1.png"
  colorx="#ffff9db6"
 else
  bkg="res/about_appbar_bg2.png"
  colorx="#ff6bdaf8"
end

activity.setContentView(loadlayout("layout/about"))

波纹({coolapk,gayhub,bili,_back},"圆黑白自适应")
波纹({隐私政策,协议,opensource,goToGithub,check_update_layout},"方黑白自适应")

mAppBarLayout.addOnOffsetChangedListener( AppBarLayout.OnOffsetChangedListener {
  onOffsetChanged = function(appBarLayout,verticalOffset)
    --print(-verticalOffset)
    if -verticalOffset<=310 then
      _back.setColorFilter(转0x("#ffffff"))
     else
      _back.setColorFilter(转0x(primaryc))
    end
  end
})

import "bmob"
function update()
  up_title.setText("正在检查更新...")
  当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob(bmobID,bmobKey)
  b:query("tumengUpadte",function(code,json)--草，update拼错了可是不能改了
    if code~=-1 and code>=200 and code<400 then
      -------主要逻辑开始
      if (json.results[1].newVerCode>当前版本)then        
        up_title.setText("发现新版本:"..json.results[1].newVerName)
        up_subtitle.setText(json.results[1].updateMessage)
        gotoUpdate.Visibility=0
        check_update.Visibility=8
       else
        up_title.setText("已经是最新了")
        up_subtitle.setText(nil)
        gotoUpdate.Visibility=8
        check_update.Visibility=8
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



