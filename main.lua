--兼容原版AndroLua+要做的修改太多，故不再支持；请使用OpenLua+。
--欢迎三连(˘•ω•˘)
require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.Chimame_Core"
import "mods.getPicThemeColor"
import "com.michael.NoScrollListView"
import "android.support.design.widget.FloatingActionButton"
--import "android.support.v4.widget.SlidingPaneLayout"
--import "android.support.v4.widget.SlidingPaneLayout$PanelSlideListener"
import "com.daimajia.androidanimations.library.Techniques"
import "com.daimajia.androidanimations.library.YoYo"
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
--import "com.squareup.picasso.*"
import "com.coolapk.market.widget.photoview.PhotoView"
--import "com.open.lua.widget.PhotoView"
--import "uk.co.senab.photoview.PhotoView"
import "github.daisukiKaffuChino.LuaLunarCalender"
import "android.support.v7.widget.*"
import "com.opensource.dialog.BottomDialog"
import "com.LuaRecyclerAdapter"
import "com.LuaRecyclerHolder"
import "com.AdapterCreator"
import "mods.xposedDetector"
import "android.support.v8.renderscript.Allocation"
import "android.support.v8.renderscript.Element"
import "android.support.v8.renderscript.RenderScript"
import "android.support.v8.renderscript.ScriptIntrinsicBlur"
import "com.fivehundredpx.android.blur.BlurringView"
import "me.everything.android.ui.overscroll.*"
import "bmob"
import "layout.home"

沉浸状态栏()
activity.setContentView(loadlayout("layout/home"))

function 错误处理(n,fun)
  xpcall(fun,
  function(e)
    双按钮对话框("程序在"..n.."遇到未知错误",
    "您可以截屏并私信给开发者。\n错误信息:"..tostring(e),
    "我知道了",
    "忽略",
    function()提示("感谢！")关闭对话框()end,
    function()关闭对话框()end)
  end)
end

pcall(function()反制xposed()end)
isTumengBeenhooked=false
if isHookByJar() then
  isTumengBeenhooked=true
 elseif ishookObject() then
  isTumengBeenhooked=true
 elseif ishookclass() then
  isTumengBeenhooked=true
end
if isTumengBeenhooked then
  双按钮对话框("Xposed正在被滥用",
  "图萌检测但并不反对Xposed。\n这可能会给无关应用带来意外和安全问题，你应该将图萌移出Xposed的作用域。",
  "我知道了",
  "",function()
    关闭对话框(an)
  end)
end
--[[
function changeSlidingBarVis()
  if _slidingBar.isOpen() then
    _slidingBar.closePane()
   else
    _slidingBar.openPane()
  end
end

_slidingBar.setPanelSlideListener(SlidingPaneLayout.PanelSlideListener{
  onPanelClosed=function()    
  end,
  onPanelOpened=function()   
  end,
  onPanelSlide=function(v,z)    
  end
})
--]]

pastTableLoadNum=1
easterEggClickNum=0
local application=activity.getApplication()
local glideget = Glide.get(application)
local todaySign=tostring(os.date("%y%j"))

if activity.getSharedData("isFirst")==nil then
  activity.newActivity("sub/welcome")
  activity.finish()
 else

  function initFavTable()
    data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
  end
  if pcall(initFavTable) then
    switch #data
     case 0
      _favEmpty.Visibility=0
    end
   else
    data={}
    提示("收藏数据读取失败")
  end

  if openActivity.getData("Setting_Theme_Color")==0 then
    checkTheme2.Visibility=8
   else
    checkTheme1.Visibility=8
  end

  function getCurrentAppearance()
    color="蓝粉"
    theme="浅色"
    if Boolean.valueOf(openActivity.getData("Setting_Auto_Night_Mode"))==true then
      theme="跟随系统"
     elseif Boolean.valueOf(openActivity.getData("Setting_Night_Mode"))==true then
      theme="深色"
    end
    local colorSet=openActivity.getData("Setting_Theme_Color")
    if colorSet==2 then
      color="蓝粉"
     elseif colorSet==0 then
      color="粉蓝"
    end
    darkmodeText.setText(theme)
  end
  getCurrentAppearance()

  if activity.getSharedData("isHomeCardBlur")==nil then
    activity.setSharedData("isHomeCardBlur",true)
  end

  if activity.getSharedData("isHomeCardBlur") then
    BlurView.setBlurredView(mPhotoView)--设置要被模糊的布局头部
    BlurView.setBlurRadius(10)--0~25模糊半径
    BlurView.setDownsampleFactor(10)--采样点间隔，越少越卡越细腻
    if Boolean.valueOf(openActivity.getData("Setting_Night_Mode"))==true then
      BlurView.setOverlayColor(转0x(backgroundc)-0x1FFFFFFF)
     else
      BlurView.setOverlayColor(0xDFFFFFFF)
    end
  end

  function setViewLayoutParams(id, nHeight)
    lp = id.getLayoutParams()
    --lp.width = nWidth
    lp.height = nHeight
    id.setLayoutParams(lp)
  end

  function initBlurView(b)
    if activity.getSharedData("isHomeCardBlur") then
      if b then
        BlurViewx.Visibility=0
        local infoCardHeight=getViewHeight(info_card_main)
        setViewLayoutParams(BlurViewx,infoCardHeight)
      end
      BlurView.invalidate()
    end
  end

  --[[ BlurView不支持自适应高度，只能等待卡片加载完毕后再动态设置高度了
    这太蠢了...]]

  lastclick = os.time() - 2
  function onKeyDown(code,event)
    local now = os.time()
    if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
      --监听返回键
      if cpop.isShowing() then
        cpop.dismiss()
        return true
       elseif morepop.isShowing() then
        morepop.dismiss()
        return true
       elseif _drawer.isDrawerOpen(Gravity.LEFT) then
        _drawer.closeDrawer(Gravity.LEFT)
        return true
      end
      if now - lastclick > 2 then
        提示("再按一次退出")
        lastclick = now
        return true
      end
    end
  end

  _drawer.setDrawerListener(DrawerLayout.DrawerListener{
    onDrawerSlide=function(v,z)
      --侧滑滑动事件
      _root.setTranslationX(z*3.8*activity.getWidth()*0.2)
      __drawer_root.setTranslationX((z-1)*activity.getWidth()*0.2)
    end})
  _drawer.setScrimColor(转0x(灰色遮罩颜色))

  ch_item_checked_background = GradientDrawable()
  .setShape(GradientDrawable.RECTANGLE)
  .setColor(转0x(primaryc)-0xde000000)
  .setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});
  import "layout.home_layout.home_drawer_item"
  --侧滑列表适配器
  adp=LuaMultiAdapter(activity,home_drawer_item)
  drawer_lv.setAdapter(adp)
  ch_table={
    {"主页","home",},
    {"喜欢","heart",},
    {"往期","wq",},
    {"投稿","unarchive",},
    "分割线",
    {"设置","settings",},
    {"捐赠","card_giftcard",},
    {"关于","info",},
    "分割线",
    {"退出","exit_to_app",},
  };

  --侧滑列表高亮项目函数
  function ch_light(n)
    adp.clear()
    for i,v in ipairs(ch_table) do
      if v=="分割线"then
        adp.add{__type=4}
       elseif n==v[1] then
        adp.add{__type=3,iv={src=图标(v[2])},tv=v[1]}
       else
        adp.add{__type=2,iv={src=图标(v[2])},tv=v[1]}
      end
    end
    adp.notifyDataSetChanged()
  end

  ch_light("主页")--设置高亮项目为“主页”

  hasClickPast=0
  drawer_lv.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      local function showHomePage(id)
        控件隐藏(page_home)
        控件隐藏(page_donate)
        控件隐藏(page_setting)
        控件隐藏(page_collect)
        控件隐藏(page_past)
        控件隐藏(page_upload)
        控件可见(id)
      end
      local s=v.Tag.tv.Text
      _drawer.closeDrawer(Gravity.LEFT)--关闭侧滑
      if s=="退出" then
        activity.finishAndRemoveTask()
       elseif s=="主页" then
        ch_light("主页")
        showHomePicInfoCard()
        showHomePage(page_home)
        切换页面(0)
        _title.Text=string_zh_CN.title_home1
        _more.setVisibility(View.VISIBLE)
       elseif s=="往期" then
        ch_light("往期")
        --hideHomePicInfoCard()
        showHomePage(page_past)
        if hasClickPast==0 then
          getPastData(1)
          hasClickPast=1
        end
        _title.Text="往期"
        _more.setVisibility(View.INVISIBLE)
       elseif s=="捐赠" then
        ch_light("捐赠")
        --hideHomePicInfoCard()
        showHomePage(page_donate)
        _title.Text="捐赠"
        _more.setVisibility(View.INVISIBLE)
       elseif s=="关于" then
        跳转页面("sub/about")
       elseif s=="投稿" then
        ch_light("投稿")
        showHomePage(page_upload)
        _title.Text="投稿"
        _more.setVisibility(View.INVISIBLE)
       elseif s=="喜欢" then
        ch_light("喜欢")
        --hideHomePicInfoCard()
        showHomePage(page_collect)
        _title.Text="喜欢"
        _more.setVisibility(View.INVISIBLE)
       elseif s=="设置" then
        ch_light("设置")
        --hideHomePicInfoCard()
        showHomePage(page_setting)
        _title.Text="设置"
        _more.setVisibility(View.INVISIBLE)
       else
        提示(s)
      end
    end})

  listalpha=AlphaAnimation(0,1)
  listalpha.setDuration(196)
  controller=LayoutAnimationController(listalpha)
  controller.setDelay(0.4)
  controller.setOrder(LayoutAnimationController.ORDER_NORMAL)
  drawer_lv.setLayoutAnimation(controller)

  function showD(id)--主页底栏项目高亮动画
    local kidt=id.getChildAt(0)
    animatorSet = AnimatorSet()
    local tscaleX = ObjectAnimator.ofFloat(kidt, "scaleX", {kidt.scaleX, 1.0})
    local tscaleY = ObjectAnimator.ofFloat(kidt, "scaleY", {kidt.scaleY, 1.0})
    animatorSet.setDuration(256)
    animatorSet.setInterpolator(DecelerateInterpolator());
    animatorSet.play(tscaleX).with(tscaleY)
    animatorSet.start();
  end

  function closeD(id)--主页底栏项目灰色动画
    local gkidt=id.getChildAt(0)
    ganimatorSet = AnimatorSet()
    local gtscaleX = ObjectAnimator.ofFloat(gkidt, "scaleX", {gkidt.scaleX, 0.9})
    local gtscaleY = ObjectAnimator.ofFloat(gkidt, "scaleY", {gkidt.scaleY, 0.9})
    ganimatorSet.setDuration(256)
    ganimatorSet.setInterpolator(DecelerateInterpolator());
    ganimatorSet.play(gtscaleX).with(gtscaleY)
    ganimatorSet.start();
  end

  function showHomePicInfoCard()
    YoYo.with(Techniques.SlideInUp)
    .duration(500)
    .playOn(_info_card_root)
  end

  function hideHomePicInfoCard()
    YoYo.with(Techniques.SlideOutDown)
    .duration(500)
    .playOn(_info_card_root)
  end

  function 图萌分享(链接)
    if 链接==nil then
      提示("链接为空")
     else
      intent=Intent(Intent.ACTION_SEND);
      intent.setType("text/plain");
      intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
      intent.putExtra(Intent.EXTRA_TEXT, "我在使用「图萌」App，给你分享一张刚发现的萌图呀ヾ(❀╹◡╹)ﾉ~\n链接："..链接);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      activity.startActivity(Intent.createChooser(intent,"分享到:"));
    end
  end

  page_home_p.setOnPageChangeListener(PageView.OnPageChangeListener{
    onPageScrolled=function(a,b,c)
      --主页pageview滑动事件
    end,
    onPageSelected=function(v)
      --主页pageview选择事件
      local x=primaryc
      local c=stextc
      local c1=c
      local c2=c
      if v==0 then
        showHomePicInfoCard()
        c1=x
        _title.setText(string_zh_CN.title_home1)
        showD(page1)
        closeD(page2)
      end
      if v==1 then
        hideHomePicInfoCard()
        c2=x
        _title.setText(string_zh_CN.title_home2)
        showD(page2)
        closeD(page1)
      end
      --选中page时设置图片及文本颜色
      page1.getChildAt(0).setColorFilter(转0x(c1))
      page2.getChildAt(0).setColorFilter(转0x(c2))
    end
  })

  function 切换页面(z)--切换主页Page函数
    page_home_p.showPage(z)
  end

  波纹({_menu,_more,page1,page2,hitokotoSetting},"圆自适应")
  波纹({saveSquarePicOne,shareSquarePicOne,addSquarePicOneToFav,fullscreenSquarePicOne},"圆黑白自适应")
  波纹({saveSquarePicTwo,shareSquarePicTwo,addSquarePicTwoToFav,fullscreenSquarePicTwo},"圆黑白自适应")
  波纹({login_layout,dailyPicRetryText,pastRetryText,square1info,square2info},"方黑白自适应")
  波纹({refresh_hitokoto},"方自适应")

  function getViewBitmap(view)
    if view then
      view.destroyDrawingCache()
      view.setDrawingCacheEnabled(true)
      view.buildDrawingCache()
      return view.getDrawingCache()
     else
      return false
    end
  end

  function getDayLunar(year, month, day)
    lunarCalender = LuaLunarCalender()
    lunarString = lunarCalender.getLunarString(year, month, day)
    return lunarString
  end
  --print(getDayLunar())

  function fltbtn_anime(a,b)--a0 b225
    rotate=RotateAnimation(a, b,
    Animation.RELATIVE_TO_SELF, 0.5,
    Animation.RELATIVE_TO_SELF, 0.5)
    rotate.setDuration(400);
    rotate.setRepeatCount(0.5);
    rotate.setFillAfter(true);
    fltbtn.startAnimation(rotate);
  end

  function translate_anime(id,a,b,c,d,e,f,g)
    rotate=TranslateAnimation(a,b,c,d)
    rotate.setDuration(e);
    rotate.setRepeatCount(f);
    rotate.setFillAfter(g);
    id.startAnimation(rotate);
  end

  mPhotoView.enable()
  --[[
  mPhotoView.setOnTouchListener{
    onTouchEvent=function(v,e)
      print(e)
      BlurView.invalidate()
    end}]]

  --[[ 当photoview开启缩放以后，不能直接设置onTouchListener
解决办法是继承photoview重写自带方法，但我没有那么做
动态刷新高斯模糊单独放进线程循环，在Glide加载结束事件中。
不推荐我这样的做法...
]]

  function savePicToAlbum(bitmap,picName)
    if SDK版本 <=28 then
      oldSavePicture(内部存储路径.."Pictures/"..picName,bitmap)
     else
      addBitmapToAlbum(bitmap, picName)
    end
    提示("已保存到\nPictures/"..picName)
  end

  cpop_isShowing=true
  cPopup_layout={
    LinearLayout;
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=卡片边框灰色;
      Radius="8dp";
      layout_width="-1";
      layout_height="-2";
      layout_margin="8dp";
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
          ListView;
          layout_height="-1";
          layout_width="-1";
          DividerHeight=0;
          fastScrollEnabled=false;
          id="cPopup_list";
        };
      };
    };
  };

  cpop=PopupWindow(activity)
  cpop.setContentView(loadlayout(cPopup_layout))
  cpop.setWidth(dp2px(128))
  cpop.setHeight(-2)
  cpop.setOutsideTouchable(true)
  cpop.setBackgroundDrawable(ColorDrawable(0x00000000))
  cpop.onDismiss=function()
    fltbtn_anime(225,0)
    task(200,function()cpop_isShowing=true end)
  end
  --PopupWindow列表项布局
  cPopup_list_item={
    LinearLayout;
    layout_width="-1";
    layout_height="48dp";
    {
      TextView;
      id="popadp_text";
      textColor=textc;
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
      Typeface=字体("product");
    };
  };

  --PopupWindow列表适配器
  cpopadp=LuaAdapter(activity,cPopup_list_item)
  cPopup_list.setAdapter(cpopadp)
  cpopadp.add{popadp_text="下载"}--添加项目(菜单项)
  cpopadp.add{popadp_text="喜欢"}
  cpopadp.add{popadp_text="分享"}
  --菜单点击事件
  cPopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(parent, v, pos,id)
      cpop.dismiss()
      if v.Tag.popadp_text.Text=="下载" then
        --图片保存，直接取缓存的bitmap对象
        local dailyBitmap=mPhotoView.getDrawable().getBitmap()
        local dailyPicName="图萌精选"..os.date("%Y-%m-%d-%H-%M-%S")..".png"
        function saveDailyPic()savePicToAlbum(dailyBitmap,dailyPicName)end
        if pcall(saveDailyPic) then
         else
          if SDK版本 <=28 then getStorePermission() else 提示("保存失败")end
        end
       elseif v.Tag.popadp_text.Text=="喜欢" then
        local function addToFav()
          data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
          if table.find(data,精选图片链接)~=nil then
            提示("已经收藏过啦")
           else
            table.insert(data,精选图片链接)
            io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
            favadapter.notifyItemInserted(#data)
            _favEmpty.Visibility=8
            提示("添加成功")
          end
        end
        if pcall(addToFav) then else 提示("添加错误") end
       elseif v.Tag.popadp_text.Text=="分享" then
        图萌分享(精选图片链接)
      end
    end})

  dailyPicProgress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc), PorterDuff.Mode.SRC_ATOP))
  squarePicProgress1.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))
  squarePicProgress2.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))
  pastProgress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc), PorterDuff.Mode.SRC_ATOP))
  pastProgress_.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))
  isKeepAwakeSwitch.ThumbDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP))
  isKeepAwakeSwitch.TrackDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc)-0xbaffffff,PorterDuff.Mode.SRC_ATOP))
  isKeepAwakeSwitch.checked=activity.getSharedData("isKeepAwake")
  isHomeCardBlurSwitch.ThumbDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP))
  isHomeCardBlurSwitch.TrackDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc)-0xbaffffff,PorterDuff.Mode.SRC_ATOP))
  isHomeCardBlurSwitch.checked=activity.getSharedData("isHomeCardBlur")


  function checkUpdate(新版本名,新版本号,最后允许版本号)
    当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
    local function 强制更新()单按钮对话框("呐，这次不得不更新了呢","版本名："..新版本名.."\n可能是由于后端改动，或是客户端的严重bug，旧版将结束支持。",function()浏览器打开("https://chino.lanzous.com/b0ddp10mf")activity.finish()end,"退出并下载更新",0)end
    local function 非强制更新()
      提示("发现新版本，版本名："..新版本名.."\n打开侧滑栏，选择「关于」项，即可看到更新方式了。")
    end
    if 当前版本<新版本号 then
      if 当前版本<最后允许版本号 then 强制更新() else 非强制更新() end
    end
  end

  function setHomePicInfoText(精选图片年,精选图片月,精选图片日,精选图片标题,精选图片副标题,精选图片来源,精选图片出处,精选图片作者,精选图片上传者,精选图片分类)
    picChineseDate.setText("农历"..getDayLunar(精选图片年,tonumber(精选图片月),tonumber(精选图片日)))
    picDate.setText(精选图片月.."月"..精选图片日.."日")
    picTitle.setText(精选图片标题)
    picSubTitle.setText(精选图片副标题)
    pixiv.setText(精选图片来源)
    fromWhatAnime.setText("归属："..精选图片出处)
    picAuthor.setText("画师："..精选图片作者)
    uploader.setText("投稿："..精选图片上传者)
    picType.setText(精选图片分类)
  end

  function readSavedPicInfoTable()
    精选图片年=TodayPicInfoTable.todayYear
    精选图片月=TodayPicInfoTable.todayMonth
    精选图片日=TodayPicInfoTable.todayDay
    精选图片链接=TodayPicInfoTable.todayPic
    精选图片来源=TodayPicInfoTable.website
    精选图片标题=TodayPicInfoTable.todayTitle
    精选图片副标题=TodayPicInfoTable.todaySubTitle
    精选图片作者=TodayPicInfoTable.author
    精选图片上传者=TodayPicInfoTable.uploader
    精选图片出处=TodayPicInfoTable.fromWhere--什么作品
    精选图片分类=TodayPicInfoTable.types
    if 精选图片来源==nil then 精选图片来源="Pixiv" end
    if 精选图片上传者==nil then 精选图片上传者="图萌官方" end
    if 精选图片出处==nil then 精选图片出处="未知" end
    if 精选图片分类==nil then 精选图片分类="插画" end
  end

  function getDailyPicData()
    --当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
    local b=bmob(bmobID,bmobKey)
    b:query("tumengPic",function(code,json)
      if code~=-1 and code>=200 and code<400 then
        activity.setSharedData(todaySign,true)
        _dailyPicProgress.Visibility=8
        今天要加载的表=tonumber(json.results[1].todayNumber)
        TodayPicInfoTable=json.results[今天要加载的表]
        readSavedPicInfoTable()

        -----检查更新开始
        新版本名=json.results[1].newVerName
        新版本号=tonumber(json.results[1].newVerCode)
        最后允许版本号=tonumber(json.results[1].lastAllowVerCode)
        activity.setSharedData("lastAllowVerCode",最后允许版本号)

        --checkUpdate(新版本名,新版本号,最后允许版本号)
        -----检查更新结束

        ---保存开始
        TodayPicInfoTable.新版本名=新版本名
        TodayPicInfoTable.新版本号=新版本号
        TodayPicInfoTable.最后允许版本号=最后允许版本号
        io.open(内部存储路径2.."tempPicData.lua","w"):write(dump(TodayPicInfoTable)):close()
        ---结束保存

        Glide.with(this)
        .load(精选图片链接)
        .skipMemoryCache(true)
        .diskCacheStrategy(DiskCacheStrategy.NONE)
        .listener({
          onResourceReady=function()
            task(300,function()
              picThemeColor(getViewBitmap(mPhotoView))--太坑了
              initBlurView(true)
              if activity.getSharedData("isHomeCardBlur") then
                thread(function()
                  require("import")
                  while true do
                    call("initBlurView")
                    Thread.sleep(10)
                  end
                end)
              end
            end)
            return false
          end,
        })
        .into(mPhotoView)

        setHomePicInfoText(精选图片年,精选图片月,精选图片日,精选图片标题,精选图片副标题,精选图片来源,精选图片出处,精选图片作者,精选图片上传者,精选图片分类)

        -------主要逻辑结束
       else
        --连接服务器失败
        _dailyPicProgress.Visibility=8
        _dailyPicRetry.Visibility = 0
        picTitle.setText("加载出错 ("..tostring(code)..")")

      end
    end)
  end

  function readDailyPicData()
    local function readTempData()
      TodayPicInfoTable=stringToTable(io.open(内部存储路径2.."tempPicData.lua"):read("*a"))
    end
    if pcall(readTempData) then
      ---
      readSavedPicInfoTable()
      新版本名=TodayPicInfoTable.newVerName
      新版本号=tonumber(TodayPicInfoTable.newVerCode)
      最后允许版本号=tonumber(TodayPicInfoTable.lastAllowVerCode)
      _dailyPicProgress.Visibility=8

      Glide.with(this)
      .load(精选图片链接)
      .skipMemoryCache(true)
      .diskCacheStrategy(DiskCacheStrategy.NONE)
      .listener({
        onResourceReady=function()
          picTitle.setText(精选图片标题)
          task(300,function()
            picThemeColor(getViewBitmap(mPhotoView))--太坑了
            initBlurView(true)
            if activity.getSharedData("isHomeCardBlur") then
              thread(function()
                require("import")
                while true do
                  call("initBlurView")
                  Thread.sleep(10)
                end
              end)
            end
          end)
          return false
        end,
      })
      .into(mPhotoView)

      --checkUpdate(新版本名,新版本号,最后允许版本号)
      setHomePicInfoText(精选图片年,精选图片月,精选图片日,"加载中...",精选图片副标题,精选图片来源,精选图片出处,精选图片作者,精选图片上传者,精选图片分类)
      ---
     else
      提示("读取本地缓存错误，请尝试联网重载")
      _dailyPicProgress.Visibility=8
      _dailyPicRetry.Visibility = 0
    end
  end

  --取"年份"+"今年的第几天"，如果今天加载过了就不用再请求了
  if activity.getSharedData(todaySign)==nil then
    --是新的一天
    getDailyPicData()
   else
    readDailyPicData()
  end


  function onDestroy()
    glideget.clearMemory()
    collectgarbage("collect")
    System.gc()
    activity.finishAndRemoveTask()
  end

  favitem={
    LinearLayout,
    layout_width="50%w",
    padding="36",
    id="it",
    {
      CardView,
      radius="15",
      {
        LinearLayout,
        orientation="vertical",
        Gravity="center",
        {
          ImageView;
          adjustViewBounds="true";--早知道有那么方便的属性
          id="img",
        },
        {
          TextView,
          Visibility=8;
          id="tv",
        },
      },
    },
  }

  favadapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return 0
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      holder=LuaRecyclerHolder(loadlayout(favitem,views))
      holder.view.setTag(views)
      return holder
    end,

    onBindViewHolder=function(holder,position)
      view=holder.view.getTag()
      url=data[position+1]
      Glide.with(this)
      .load(url)
      .fitCenter()
      --.dontTransform()
      --.override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
      .into(view.img);
      view.tv.Text=data[position+1]
      view.it.onClick=function(v,a)
        local lj=v.Tag.tv.text
        activity.newActivity("sub/photoView",{lj})
        return true
      end

      view.it.onLongClick=function(v)
        local lj=v.Tag.tv.text

        local function DeleteFav()
          local value=lj
          data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
          local where=table.find(data,value)
          table.remove(data,where)
          io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
          favadapter.notifyItemRemoved(where-1)
          data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
          switch #data
           case 0
            _favEmpty.Visibility=0
          end
          import "android.support.design.widget.Snackbar"
          deleteFavSkbar=Snackbar.make(v,"项目删除完毕",2500)
          deleteFavSkbar.setAction("撤销",function()
            data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
            table.insert(data,value)
            io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
            favadapter.notifyItemInserted(#data)
            _favEmpty.Visibility=8
          end)
          deleteFavSkbar.setActionTextColor(转0x(primaryc))
          deleteFavSkbar.show()
        end

        pop=PopupMenu(activity,v.Tag.it)
        menu=pop.Menu
        menu.add("删除...").onMenuItemClick=function(a)
          DeleteFav()
        end
        menu.add("保存到相册").onMenuItemClick=function(a)
          local favbitmap=v.Tag.img.getDrawable().getBitmap()
          local favPicName="图萌收藏"..os.date("%Y-%m-%d-%H-%M-%S")..".png"
          function saveFavPic()savePicToAlbum(favbitmap,favPicName)end
          if pcall(saveFavPic) then
           else
            if SDK版本 <=28 then getStorePermission() else 提示("保存失败")end
          end
        end
        pop.show()--显示
        return true
      end
    end,
  }))
  --瀑布流管理器(第一个参数:几行,第二个参数:方向)
  favRecycler.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
  --data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
  favRecycler.setAdapter(favadapter)
  OverScrollDecoratorHelper.setUpOverScroll(favRecycler, OverScrollDecoratorHelper.ORIENTATION_VERTICAL)


  isSquare1LoadFinish=false
  isSquare1LoadError=false
  function getSquarePicOne()
    squarePicOne.Visibility=8
    _squarePicProgress1.Visibility=0
    isSquare1LoadFinish=false
    Http.get("http://www.dmoe.cc/random.php?return=json",nil,nil,nil,function(s1code,s1content)
      if s1code==200 then
        squarePicOneUrl=s1content:match([["imgurl":"(.-)"]]):gsub("\\","")
        isSquare1LoadError=false
        Glide.with(this)
        .load(squarePicOneUrl)
        .listener({
          onResourceReady=function()
            isSquare1LoadFinish=true
            squarePicOne.Visibility=0
            _squarePicProgress1.Visibility=8
            return false
          end,
        })
        .into(squarePicOne)
       else
        -- _squarePicProgress1.Visibility=8
        isSquare1LoadError=true
        提示("加载失败:squarePic1 ("..tostring(s1code)..")")
      end
    end)
  end

  isSquare2LoadFinish=false
  isSquare2LoadError=false
  function getSquarePicTwo()
    squarePicTwo.Visibility=8
    _squarePicProgress2.Visibility=0
    isSquare2LoadFinish=false
    Http.get("http://api.ssr0.cn:8000/IMG",nil,nil,nil,function(s2code,s2content)
      if s2code==200 then
        squarePicTwoUrl=s2content:match([['img':'(.-)']]):gsub("\\","")
        squarePicTwoUrlLarge=s2content:match([['file':'(.-)']]):gsub("\\","")
        isSquare2LoadError=false
        Glide.with(this)
        .load(squarePicTwoUrl)
        .listener({
          onResourceReady=function()
            isSquare2LoadFinish=true
            squarePicTwo.Visibility=0
            _squarePicProgress2.Visibility=8
            return false
          end,
        })
        .into(squarePicTwo)
       else
        --_squarePicProgress2.Visibility=8
        isSquare2LoadError=true
        提示("加载失败:squarePic2 ("..tostring(s2code)..")")
      end
    end)
  end

  isHitikotoLoadFinish=false
  function getHitokoto()
    Http.get("https://v1.hitokoto.cn/","utf8",function(mcode,mcontent)
      if mcode==200 then
        local content = JSON.decode(mcontent)
        hitokotoWord=content.hitokoto
        hitokotoFrom=content.from
        hitokotoFromWho=content.from_who
        if hitokotoFromWho==nil or hitokotoFromWho=="null" then
          hitokotoFromWhoTextParent.Visibility=8
         else
          hitokotoFromWhoTextParent.Visibility=0
        end
        hitokotoText.setText(hitokotoWord)
        hitokotoFromText.setText(hitokotoFrom)
        hitokotoFromWhoText.setText(hitokotoFromWho)
        isHitikotoLoadFinish=true
       else
        hitokotoFromWhoTextParent.Visibility=8
        hitokotoText.setText("Hitokoto加载失败 ("..tostring(mcode)..")")
        hitokotoFromText.setText(" 出处 ")
        hitokotoFromWhoText.setText(" 作者 ")
        isHitikotoLoadFinish=true
      end
    end)
  end

  Thread(Runnable{--ui线程子线程
    run = function()
      this.runOnUiThread(Runnable{
        run = function()
          getSquarePicOne()
          getSquarePicTwo()
          getHitokoto()
        end
      })
    end
  }).start()

  function hitokotoSettingShow()
    hitokotoSetDialog=BottomDialog(activity)
    hitokotoSetDialog.setView(loadlayout({
      LinearLayout,
      layout_height="fill",
      layout_width="fill",
      orientation="vertical",
      {
        LinearLayout,
        layout_height="fill",
        layout_width="fill",
        orientation="vertical",
        BackgroundDrawable = GradientDrawable()
        .setColor(转0x(backgroundc))
        .setCornerRadii({dp2px(16),dp2px(16),dp2px(16),dp2px(16),0,0,0,0})
        .setShape(0),
        {
          CardView;
          layout_gravity="center",
          background=grayc,
          radius="3dp",
          elevation="0dp";
          layout_height = "5dp",
          layout_width = "52dp",
          layout_marginTop = "12dp",
          layout_marginBottom = "12dp"
        };
        {
          LinearLayout,
          layout_height="fill",
          layout_width="fill",
          orientation="vertical",
          padding="16dp",
          paddingTop="0dp";
          {
            TextView;
            text="设置拾穗";
            textSize="18sp";
            layout_marginTop="12dp",
            Typeface=字体("product-Bold");
            textColor=textc;
          };
          {
            TextView;
            text="施工中";
            textSize="14sp";
            layout_marginTop="12dp",
            Typeface=字体("product");
            textColor=stextc;
          };
        };

      },
    }))

    hitokotoSetDialog.setGravity(Gravity.BOTTOM)
    hitokotoSetDialog.setHeight(activity.getHeight()*0.4)
    hitokotoSetDialog.setWidth(activity.getWidth())
    hitokotoSetDialog.setRadius(dp2px(10),0x000000)
    hitokotoSetDialog.setCanceledOnTouchOutside(true);
    hitokotoSetDialog.show()
  end

  function CircleButton(view,InsideColor,radiu)
    import "android.graphics.drawable.GradientDrawable"
    drawable =GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(InsideColor)
    drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
    view.setBackgroundDrawable(drawable)
  end

  CircleButton(buttonWechat,转0x(primaryc),90)
  CircleButton(buttonAlipay,转0x(primaryc),90)

  morePopup_layout={
    LinearLayout;
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=卡片边框灰色;
      Radius="8dp";
      layout_width="-1";
      layout_height="-2";
      layout_margin="8dp";
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
          ListView;
          layout_height="-1";
          layout_width="-1";
          DividerHeight=0;
          fastScrollEnabled=false;
          id="morePopup_list";
        };
      };
    };
  };
  --PopupWindow
  morepop=PopupWindow(activity)
  --PopupWindow加载布局
  morepop.setContentView(loadlayout(morePopup_layout))
  morepop.setWidth(dp2px(168))
  morepop.setHeight(-2)
  morepop.setOutsideTouchable(true)
  morepop.setBackgroundDrawable(ColorDrawable(0x00000000))
  morepop.onDismiss=function()
  end
  --PopupWindow列表项布局
  morePopup_list_item={
    LinearLayout;
    layout_width="-1";
    layout_height="48dp";
    {
      TextView;
      id="popadp_text";
      textColor=textc;
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
      Typeface=字体("product");
    };
  };
  --PopupWindow列表适配器
  morepopadp=LuaAdapter(activity,morePopup_list_item)
  morePopup_list.setAdapter(morepopadp)
  morepopadp.add{popadp_text="常见问题Q&A"}--添加项目(菜单项)
  morepopadp.add{popadp_text="日志"}
  --菜单点击事件
  morePopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(parent, v, pos,id)
      morepop.dismiss()
      if v.Tag.popadp_text.Text=="常见问题Q&A" then
        commonQuestionDialog=BottomDialog(activity)
        commonQuestionDialog.setView(loadlayout({
          LinearLayout,
          layout_height="fill",
          layout_width="fill",
          orientation="vertical",
          {
            LinearLayout,
            layout_height="fill",
            layout_width="fill",
            orientation="vertical",
            BackgroundDrawable = GradientDrawable()
            .setColor(转0x(backgroundc))
            .setCornerRadii({dp2px(16),dp2px(16),dp2px(16),dp2px(16),0,0,0,0})
            .setShape(0),
            {
              CardView;
              layout_gravity="center",
              background=grayc,
              radius="3dp",
              elevation="0dp";
              layout_height = "5dp",
              layout_width = "52dp",
              layout_marginTop = "12dp",
              layout_marginBottom = "12dp"
            };
            {
              LinearLayout,
              layout_height="fill",
              layout_width="fill",
              orientation="vertical",
              padding="16dp",
              paddingTop="0dp";
              {
                LuaWebView;
                id="WebView";
              };
            };
          },
        }))
        md=require "mods.LuaMarkDown"
        commonQuestionMD=md[[## 图片加载失败?
    如果是主页「精选」发生加载失败的情况，可以尝试点击重试按钮继续等待。~~一般情况下只要重试一次就可以打开了~~
    
    有时会遇到广场页的图片源出现加载缓慢或无法加载的情况，可能是图源出现了问题。图萌只负责将它们收录进App中进行调用。对于长时间失效的图源，会在App后续的更新中删除。
    
    ## 图萌内图片资源版权?
    我们尊重原画的版权，只负责将画师们的作品分享给大家，并且所有服务器支出都自行承担。**若用户需要商用这些图片资源，请自行联系版权方。**这部分内容可以参照《软件许可使用协议》。
    
    ## 拾穗是什么?
    首先致谢开放接口hitokoto一言。
    
    *「我们把这些句子汇聚起来，形成一言网络，以传递更多的感动...」*
    
    这是一言存在的意义。图萌的初衷是补充一些仅靠图片传达不了的内容，于是使用一言API的「拾穗」诞生了...
    
    ## 为什么往期的图片那么少?
    ~~因为经常连续几个月不更新啊~~
    ]]
        WebView.loadDataWithBaseURL("",commonQuestionMD,"text/html","utf-8",nil)
        WebView.onLongClick=function()return true end
        WebView.setWebViewClient{
          onPageFinished=function(view,url)
            if theme=="深色" then
              WebView.evaluateJavascript([[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#212121 !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]],nil)
            end
          end}
        commonQuestionDialog.setGravity(Gravity.BOTTOM)
        commonQuestionDialog.setHeight(activity.getHeight()*0.45)
        commonQuestionDialog.setWidth(activity.getWidth())
        commonQuestionDialog.setRadius(dp2px(10),0x000000)
        commonQuestionDialog.setCanceledOnTouchOutside(true);
        commonQuestionDialog.show()
       else
        activity.newActivity("mods/logcat")
      end
    end})

  numPicker.setMaxValue(30)
  numPicker.setMinValue(1)
  numPicker.setDescendantFocusability(DatePicker.FOCUS_BLOCK_DESCENDANTS)
  local numPickerField = NumberPicker.getDeclaredField("mSelectionDivider")
  if numPickerField~=nil then
    numPickerField.setAccessible(true);
    numPickerField.set(numPicker, ColorDrawable(转0x(primaryc)))
  end
  numPicker.setOnValueChangedListener{
    OnValueChangeListener=function(numPicker, oldnum, newnum)
      -- print(numPicker.getValue())
      -- print(newnum)
    end}


  autoRefreshChr.setCountDown(true)
  --ch.stop()--用于指定停止计时
  autoRefreshChr.setOnChronometerTickListener{
    onChronometerTick=function()
      if autoRefreshChrNum~=nil then
        if SystemClock.elapsedRealtime()-autoRefreshChr.getBase() >=0 then
          Thread(Runnable{--ui线程子线程
            run = function()
              this.runOnUiThread(Runnable{
                run = function()
                  getSquarePicOne()
                  getSquarePicTwo()
                  getHitokoto()
                end
              })
            end
          }).start()
          autoRefreshChr.setBase(SystemClock.elapsedRealtime()+autoRefreshChrNum)
        end
      end
    end}

  function login()
    提示("不允许登录")
  end

  pyear="2021"
  pastSpinData={"2021","2020"}
  spinadp=ArrayAdapter(activity,android.R.layout.simple_list_item_1,String(pastSpinData))
  pastSpin.setAdapter(spinadp)
  pastSpin.onItemSelected=function(l,v,p,i)
    if p==0 then --2021
      pastTableLoadNum=1
      pyear="2021"
      getPastData(1)
     elseif p==1 then
      pastTableLoadNum=2
      pyear="2020"
      getPastData(2)
     else
      提示("遇到未知错误：Spinner error")
    end
  end

  pastItem={
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    id="pcontent";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=cardbackc;
      Radius="8dp";
      layout_width="-1";
      layout_height="100dp";
      layout_margin="16dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      {
        LinearLayout;
        layout_width="-1";
        layout_height="-1";
        {
          LinearLayout;
          layout_width="-1";
          layout_height="-1";
          layout_weight="1";
          {
            ImageView;
            id="pic";
            --src="res/not_include.png",
            scaleType="centerCrop";
            layout_width=dp2px(100)/280*440;
            layout_height="-1";
            colorFilter=viewshaderc;
          };
        };
        {
          LinearLayout;
          layout_width="-1";
          layout_height="-1";
          layout_margin="16dp";
          layout_weight="1";
          orientation="vertical",
          gravity="center|left";
          {
            TextView;
            id="month";
            textColor=primaryc;
            textSize="16sp";
            gravity="center|left";
            Typeface=字体("product-Bold");
            layout_height="-2";
            layout_width="-1";
          };
          {
            TextView;
            id="pastNum";
            textColor=textc;
            textSize="14sp";
            gravity="center|left";
            Typeface=字体("product-Medium");
            layout_marginTop="4dp";
            layout_height="-2";
            layout_width="-1";
          };
        };
      };
    };
  }

  pastadapter=LuaRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return #pastdata
    end,
    getItemViewType=function(position)
      return 0
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      holder=LuaRecyclerHolder(loadlayout(pastItem,views))
      holder.view.setTag(views)
      return holder
    end,

    onBindViewHolder=function(holder,position)
      view=holder.view.getTag()
      view.month.text=pastdata[position+1].title
      view.pastNum.text=pastdata[position+1].subtitle
      local url=pastdata[position+1].pic
      --if url==nil then url="https://wx1.sinaimg.cn/mw690/005WsnUygy1gn4vdc9p34j314b0sb0wz.jpg"end
      if openActivity.getData("Setting_Theme_Color")==0 then
        pastnilurl="file:///android_asset/res/not_include1.png"
       else
        pastnilurl="file:///android_asset/res/not_include2.png"
      end
      if url==nil then url=pastnilurl end
      Glide.with(this)
      .load(url)
      .into(view.pic)

      view.pcontent.onClick=function(v,a)
        local pmonth=v.Tag.month.text
        local pnum=v.Tag.pastNum.text
        if pnum=="收录统计:0张" then
          提示("此分类下暂时没有图片哦")
         else
          activity.newActivity("sub/pastView",{pyear,pmonth})
        end
        return true
      end
      return true
    end,
  }))

  pastRecycler.setLayoutManager(LinearLayoutManager(this))
  OverScrollDecoratorHelper.setUpOverScroll(pastRecycler, OverScrollDecoratorHelper.ORIENTATION_VERTICAL)

  function getPastData(年往期要加载的表)
    _pastProgress_.Visibility=0
    pastSpin.Visibility=8
    _pastRetry.Visibility = 8
    local b=bmob(bmobID,bmobKey)
    b:query("tumengOthers",function(code,json)
      if code~=-1 and code>=200 and code<400 then
        --年往期要加载的表=1
        往期年表=json.results[年往期要加载的表].pastAllTable
        pastdata=stringToTable(往期年表)
        pastRecycler.setAdapter(pastadapter)
        _pastProgress.Visibility=8
        _pastProgress_.Visibility=8
        pastSpin.Visibility=0
       else
        _pastProgress.Visibility=8
        _pastRetry.Visibility = 0
        _pastProgress_.Visibility=8
        pastSpin.Visibility=0
        提示("连接服务器失败 ("..code..")")
      end
    end)
  end

  function onResume()
    initFavTable()

    local function glideLoadDrawerNameCard(isSet,pic1,pic2,id)
      if activity.getSharedData(isSet) then
        Glide.with(this)
        .load(内部存储路径2..pic1)
        .skipMemoryCache(true)
        .diskCacheStrategy(DiskCacheStrategy.NONE)
        .into(id)
       else
        avatar.setImageBitmap(loadbitmap("res/"..pic2))
      end
    end

    favadapter.notifyItemInserted(#data)
    if #data>0 then
      _favEmpty.Visibility=8
     else
      _favEmpty.Visibility=0
    end

    glideLoadDrawerNameCard("isSetNamecardBg","nameCardBg.png","drawer_login_bg.png",name_card_bg)
    glideLoadDrawerNameCard("isSetAvatar","userAvatar.png","noavatar_akari.png",avatar)

    if activity.getSharedData("account")==nil then nameText.setText("点我登录")else nameText.setText(activity.getSharedData("account"))end
  end


  function jcpage(z)
    jc.showPage(z)
  end

  jc.setOnPageChangeListener(PageView.OnPageChangeListener{
    onPageScrolled=function(a,b,c)
      local w=(activity.getWidth()-dp2px(2*24))/2
      local wd=c*((activity.getWidth()-dp2px(2*24))/activity.getWidth())/2
      if a==0 then
        page_scroll.setX(wd+dp2px(28))
      end
      if a==1 then
        page_scroll.setX(wd+w+dp2px(28))
      end
    end,
    onPageSelected=function(v)
      local x=primaryc
      local c=stextc
      local c1=c
      local c2=c
      if v==0 then
        c1=x
      end
      if v==1 then
        c2=x
      end
      jc1.getChildAt(0).setTextColor(转0x(c1))
      jc2.getChildAt(0).setTextColor(转0x(c2))
    end
  })

  upload_checkbox1.ButtonDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))

end
