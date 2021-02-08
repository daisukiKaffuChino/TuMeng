--TuMeng 2.0.1 for AndroLua+
--欢迎star，fork，pr
--引用了muk的MDesign部分代码
require "import"
import "mods.Chimame_Core"
import "mods.getPicThemeColor"
import "com.michael.NoScrollListView"
import "com.daimajia.androidanimations.library.Techniques"
import "com.daimajia.androidanimations.library.YoYo"
--import "android.support.v4.widget.SlidingPaneLayout"
--import "android.support.v4.widget.SlidingPaneLayout$PanelSlideListener"
--没能解决滑动冲突问题，故弃用
--似乎不适合当侧滑，拿它做多层页面也许会更好
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
import "com.coolapk.market.widget.photoview.PhotoView"
import "github.daisukiKaffuChino.LuaLunarCalender"
import "com.opensource.dialog.BottomDialog"
import "android.support.v7.widget.*"
import "com.LuaRecyclerAdapter"
import "com.LuaRecyclerHolder"
import "com.AdapterCreator"
import "layout.home"

沉浸状态栏()
activity.setContentView(loadlayout("layout/home"))

pastTableLoadNum=1
local application=activity.getApplication()
local glideget = Glide.get(application)

if activity.getSharedData("isFirst")==nil then
  activity.setSharedData("isFirst","1")
  io.open(内部存储路径2.."favTable.lua","w"):write("{}"):close()
  openactivity.setData("Setting_Theme_Color",0)
  activity.setSharedData("isKeepAwake",false)
end

if openactivity.getData("Setting_Theme_Color")==0 then
  checkTheme2.Visibility=8
 else
  checkTheme1.Visibility=8
end

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

easterEggClickNum=0

--[
ch_item_checked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setColor(转0x(primaryc)-0xde000000)
.setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});
import "layout.drawer_item"
--侧滑列表适配器
adp=LuaMultiAdapter(activity,drawer_item)
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

drawer_lv.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    local s=v.Tag.tv.Text
    _drawer.closeDrawer(Gravity.LEFT)
    if s=="退出" then
      关闭页面()
     elseif s=="主页" then
      ch_light("主页")
      showHomePicInfoCard()
      控件可见(page_home)
      控件隐藏(page_donate)
      控件隐藏(page_setting)
      控件隐藏(page_collect)
      控件隐藏(page_past)
      切换页面(0)
      _title.Text="精选"
      _more.setVisibility(View.VISIBLE)
     elseif s=="往期" then
      ch_light("往期")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_collect)
      控件隐藏(page_donate)
      控件隐藏(page_setting)
      控件可见(page_past)
      _title.Text="往期"
      _more.setVisibility(View.INVISIBLE)
     elseif s=="捐赠" then
      ch_light("捐赠")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_collect)
      控件可见(page_donate)
      控件隐藏(page_setting)
      控件隐藏(page_past)
      _title.Text="捐赠"
      _more.setVisibility(View.INVISIBLE)
     elseif s=="关于" then
      跳转页面("mods/about")
     elseif s=="投稿" then
      提示("在做了")
     elseif s=="喜欢" then
      ch_light("喜欢")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_setting)
      控件隐藏(page_donate)
      控件隐藏(page_past)
      控件可见(page_collect)
      _title.Text="喜欢"
      _more.setVisibility(View.INVISIBLE)
     elseif s=="设置" then
      ch_light("设置")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_collect)
      控件隐藏(page_donate)
      控件隐藏(page_past)
      控件可见(page_setting)
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
      _title.setText("精选")
      showD(page1)
      closeD(page2)
    end
    if v==1 then
      hideHomePicInfoCard()
      c2=x
      _title.setText("广场")
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
波纹({fltbtn,squareFltBtnOne,squareFltBtnTwo},"方白")

function getViewBitmap(view)--已弃用
  if view then
    view.destroyDrawingCache()
    view.setDrawingCacheEnabled(true)
    view.buildDrawingCache()
    return view.getDrawingCache()
   else
    return false
  end
end

mPhotoView.enable()
mPhotoView.enableRotate()
--pic="https://pic-1258664276.cos.ap-shanghai.myqcloud.com/d402ab44a8a38301bdb002200e1446e0.jpg"

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

--图片保存函数，图萌遵循资源复用原则，直接取bitmap对象，省去不必要的网络请求
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
--PopupWindow
cpop=PopupWindow(activity)
--PopupWindow加载布局
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
cpopadp.add{popadp_text="下载"}
cpopadp.add{popadp_text="喜欢"}
cpopadp.add{popadp_text="分享"}

cPopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent, v, pos,id)
    cpop.dismiss()
    if v.Tag.popadp_text.Text=="下载" then
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
        --print(isTableExist(data,精选图片链接))
        if isTableExist(data,精选图片链接) then
          提示("已经收藏过啦")
         else
          table.insert(data,精选图片链接)
          io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
          favadapter.notifyItemInserted(#data)
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
isKeepAwakeSwitch.TrackDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc)-0x99ffffff,PorterDuff.Mode.SRC_ATOP))
isKeepAwakeSwitch.checked=activity.getSharedData("isKeepAwake")

import "bmob"
function getDailyPicData()
  --当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob(bmobID,bmobKey)
  b:query("tumengPic",function(code,json)--草，update拼错了可是不能改了
    if code~=-1 and code>=200 and code<400 then
      _dailyPicProgress.Visibility=8
      今天要加载的表=tonumber(json.results[1].todayNumber)
      精选图片年=json.results[今天要加载的表].todayYear
      精选图片月=json.results[今天要加载的表].todayMonth
      精选图片日=json.results[今天要加载的表].todayDay
      精选图片链接=json.results[今天要加载的表].todayPic
      精选图片来源=json.results[今天要加载的表].website
      精选图片标题=json.results[今天要加载的表].todayTitle
      精选图片副标题=json.results[今天要加载的表].todaySubTitle
      精选图片作者=json.results[今天要加载的表].author
      精选图片上传者=json.results[今天要加载的表].uploader
      精选图片出处=json.results[今天要加载的表].fromWhere--什么作品
      精选图片分类=json.results[今天要加载的表].types
      --print(dump(json))
      Glide.with(this)
      .load(精选图片链接)
      .skipMemoryCache(true)
      .diskCacheStrategy(DiskCacheStrategy.NONE)
      .listener({
        onResourceReady=function()
          task(300,function()
            picThemeColor(mPhotoView.getDrawable().getBitmap())--太坑了
          end)
          return false
        end,
      })
      .into(mPhotoView)

      picChineseDate.setText("农历"..getDayLunar(精选图片年,tonumber(精选图片月),tonumber(精选图片日)))
      picDate.setText(精选图片月.."月"..精选图片日.."日")
      picTitle.setText(精选图片标题)
      picSubTitle.setText(精选图片副标题)
      pixiv.setText(精选图片来源)
      fromWhatAnime.setText("归属："..精选图片出处)
      picAuthor.setText("画师："..精选图片作者)
      uploader.setText("投稿："..精选图片上传者)
      picType.setText(精选图片分类)
      -------主要逻辑结束
     else
      --连接服务器失败
      _dailyPicProgress.Visibility=8
      _dailyPicRetry.Visibility = 0
      picTitle.setText("加载出错 ("..tostring(code)..")")

    end
  end)
end

getDailyPicData()

--内存回收
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
      activity.newActivity("photoView",{lj})

      return true
    end

    view.it.onLongClick=function(v)
      local xposition=position+1
      local lj=v.Tag.tv.text
      --print(xposition)
      local function favDelete()
        双按钮对话框("确认要删除吗?",
        "该项目将不可恢复,确认要继续吗?",
        "确认",
        "手滑了",function()
          关闭对话框(an)
          data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
          local where=table.find(data,lj)
          table.remove(data,where)
          io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
          favadapter.notifyItemRemoved(where-1)
        end,
        function()
          关闭对话框(an)
        end)
      end

      pop=PopupMenu(activity,v.Tag.it)
      menu=pop.Menu
      menu.add("删除...").onMenuItemClick=function(a)
        favDelete()
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
--瀑布流管理器
favRecycler.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
--print(dump(data))
favRecycler.setAdapter(favadapter)


isSquare1LoadFinish=false
function getSquarePicOne()
  squarePicOne.Visibility=8
  _squarePicProgress1.Visibility=0
  isSquare1LoadFinish=false
  Http.get("http://www.dmoe.cc/random.php?return=json",nil,nil,nil,function(s1code,s1content)
    if s1code==200 then
      ----////
      squarePicOneUrl=s1content:match([["imgurl":"(.-)"]]):gsub("\\","")      
      --[[开发者血泪史:20200125
此处布局是一个未指定高度的cardview嵌套一个imageview以期实现高度自适应，但这里的图片怎么也加载不出，
我以为是glide的问题甚至还换了picasso。最后忙了半天发现在imageview上面必须得套一层linerlayout...
--]]
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
      ----\\\\
     else
      提示("加载失败:squarePic1 ("..tostring(s1code)..")")
    end
  end)
end

isSquare2LoadFinish=false
function getSquarePicTwo()
  squarePicTwo.Visibility=8
  _squarePicProgress2.Visibility=0
  isSquare2LoadFinish=false
  Http.get("http://mr.ssr0.cn:8000/img",nil,nil,nil,function(s2code,s2content)
    if s2code==200 then
      ----////
      squarePicTwoUrl=s2content:match([['img':'(.-)']]):gsub("\\","")
      squarePicTwoUrlLarge=s2content:match([['file':'(.-)']]):gsub("\\","")
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
      ----\\\\
     else
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
morepopadp.add{popadp_text="常见问题Q&A"}
morepopadp.add{popadp_text="日志"}

morePopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent, v, pos,id)
    morepop.dismiss()
    if v.Tag.popadp_text.Text=="常见问题Q&A" then

     else
      activity.newActivity("mods/logcat")
    end
end})

numPicker.setMaxValue(60)
numPicker.setMinValue(0)
numPicker.setOnValueChangedListener{
  OnValueChangeListener=function(numPicker, oldnum, newnum)
    -- print(numPicker.getValue())
    -- print(newnum)
end}

function login()
  提示("暂不支持登录")
end

pyear="2021"
pastSpinData={"2021","2020"}
spinadp=ArrayAdapter(activity,android.R.layout.simple_list_item_1,String(pastSpinData))
pastSpin.setAdapter(spinadp)
pastSpin.onItemSelected=function(l,v,p,i)
  if p==0 then --2021

   elseif p==1 then

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
    if openactivity.getData("Setting_Theme_Color")==0 then
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
        activity.newActivity("mods/pastView",{pyear,pmonth})
      end
      return true
    end
    return true
  end,
}))

pastRecycler.setLayoutManager(LinearLayoutManager(this))

function getPastData(往期要加载的表)
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

