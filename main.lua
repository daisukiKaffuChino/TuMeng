--用OpenLua+写的，其它IDE自测，如果有些方法是IDE独有的，那我也没办法
--引用了muk的MDesign的一些代码
--欢迎fork，star，或提交pr
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
--没能解决滑动冲突问题，故弃用
--似乎不适合当侧滑，拿它做多层页面也许会更好
--import "android.support.v4.widget.SlidingPaneLayout$PanelSlideListener"
import "com.daimajia.androidanimations.library.Techniques"
import "com.daimajia.androidanimations.library.YoYo"
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
import "com.coolapk.market.widget.photoview.PhotoView"
import "github.daisukiKaffuChino.LuaLunarCalender"--我编译的农历类
import "android.support.v7.widget.*"
import "com.LuaRecyclerAdapter"
import "com.LuaRecyclerHolder"
import "com.AdapterCreator"
import "layout.home"

沉浸状态栏()
activity.setContentView(loadlayout("layout/home"))

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

local application=activity.getApplication()
local glideget = Glide.get(application)

if activity.getSharedData("isFirst")==nil then
  activity.setSharedData("isFirst","1")
  io.open(内部存储路径2.."favTable.lua","w"):write("{}"):close()
end



_drawer.setDrawerListener(DrawerLayout.DrawerListener{
  onDrawerSlide=function(v,z)
    --侧滑滑动事件
    _root.setTranslationX(z*3.8*activity.getWidth()*0.2)
    __drawer_root.setTranslationX((z-1)*activity.getWidth()*0.2)
  end})

_drawer.setScrimColor(0x93ffffff)



--侧滑高亮背景
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
    _drawer.closeDrawer(Gravity.LEFT)--关闭侧滑
    if s=="退出" then
      关闭页面()
     elseif s=="主页" then
      ch_light("主页")
      showHomePicInfoCard()
      控件可见(page_home)
      控件隐藏(page_setting)
      控件隐藏(page_collect)
      切换页面(0)
      _title.Text="精选"
      _more.setVisibility(View.VISIBLE)
     elseif s=="往期" then

     elseif s=="关于" then
      跳转页面("about")
     elseif s=="喜欢" then
      --跳转页面("fav")
      --[
      ch_light("喜欢")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_setting)
      控件可见(page_collect)
      _title.Text="喜欢"
      --_more.setVisibility(View.INVISIBLE)
      --]]
     elseif s=="设置" then
      ch_light("设置")
      hideHomePicInfoCard()
      控件隐藏(page_home)
      控件隐藏(page_collect)
      控件可见(page_setting)
      _title.Text="设置"
      _more.setVisibility(View.INVISIBLE)
     else
      提示(s)
    end
  end})

--]]

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

波纹({_menu,_more,page1,page2},"圆自适应")
波纹({login_layout},"方黑白自适应")

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


mPhotoView.enable()
mPhotoView.enableRotate()

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

cpop_isShowing=true
cPopup_layout={
  LinearLayout;

  {
    CardView;
    CardElevation="0dp";
    CardBackgroundColor="#FFE0E0E0";
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
        GridView;
        layout_height="-1";
        layout_width="-1";
        NumColumns=1;
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
cpopadp.add{popadp_text="下载"}--添加项目(菜单项)
cpopadp.add{popadp_text="喜欢"}
cpopadp.add{popadp_text="分享"}

--菜单点击事件
cPopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent, v, pos,id)
    cpop.dismiss()
    if v.Tag.popadp_text.Text=="下载" then

     elseif v.Tag.popadp_text.Text=="喜欢" then
      function addToFav()
        data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
       print(isTableExist(data,精选图片链接))
        if isTableExist(data,精选图片链接)==false then
          提示("这张图片已经收藏过啦")
         else
          table.insert(data,精选图片链接)
          io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
          favadapter.notifyItemInserted(#data)
          提示("添加成功")
        end
     
      end
      if pcall(addToFav) then else 提示("添加错误") end
     elseif v.Tag.popadp_text.Text=="分享" then
      intent=Intent(Intent.ACTION_SEND);
      intent.setType("text/plain");
      intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
      intent.putExtra(Intent.EXTRA_TEXT, "我在使用「图萌」App，给你分享一张刚发现的萌图呀ヾ(❀╹◡╹)ﾉ~\n链接："..精选图片链接);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      activity.startActivity(Intent.createChooser(intent,"分享到:"));
    end
  end
})

dailyPicProgress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(secondaryc), PorterDuff.Mode.SRC_ATOP))

import "bmob"
function getDailyPicData()
  --当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob("","")
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
      .diskCacheStrategy(DiskCacheStrategy.NONE)--不要缓存
      .listener({
        onResourceReady=function()
          task(300,function()
            picThemeColor(getViewBitmap(mPhotoView))--太坑了
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
      picTitle.setText("加载出错 ("..tostring(code)..")")

    end
  end)
end

getDailyPicData()

_more.onClick=function()

  local datas="https://tva4.sinaimg.cn/large/0072Vf1pgy1foxk6hzndqj31kw0w0b0q.jpg"
  table.insert(data,datas)
  io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
  favadapter.notifyItemInserted(#data)
end

function isNeedUpadte()
  当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob("","")
  b:query("tumengUpadte",function(code,json)--草，update拼错了可是不能改了
    if code~=-1 and code>=200 and code<400 then
      新版本名=json.results[1].newVerName
      新版本号=json.results[1].newVerCode
      最后允许版本号=tonumber(json.results[1].lastAllowVerCode)
      function 强制更新()单按钮对话框("呐，这次不得不更新了呢","版本名："..新版本名.."\n可能是由于后端改动，或是客户端有影响较大的bug，旧版将结束支持。\n唯一发布平台：酷安网",function()浏览器打开("https://chino.lanzous.com/b0ddp10mf")activity.finish()end,"退出并下载更新",0)end
      function 非强制更新()
        提示("发现新版本，版本名："..新版本名.."\n打开侧滑栏，选择「关于」项，即可看到更新方式了。")
      end
      if 当前版本<新版本号 then
        if 当前版本<最后允许版本号 then 强制更新() else 非强制更新() end
      end
     else
      提示("检查更新失败 ("..code..")")
    end
  end)
end

Thread(Runnable({
  run=function()
    isNeedUpadte()
  end
})).start()



function onDestroy()
  glideget.clearMemory()
  collectgarbage("collect")
  System.gc()
  activity.finishAndRemoveTask()
end

setting_item={
  LinearLayout,
  layout_width="50%w",
  padding="36",
  id="it",
  {
    TextView,
    id="tv",
  },
}

sAdapter=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data
  end,
  getItemViewType=function(position)
    --[[    
    做设置页面当然不能只有一种布局，这个方法
    可以用来解决这个问题。    我懒，不做了
    item需要当做table处理
    --]]
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    holder=LuaRecyclerHolder(loadlayout(setting_item,views))
    holder.view.setTag(views)
    return holder
  end,

  onBindViewHolder=function(holder,position)
    view=holder.view.getTag()
    view.tv.Text=data[position+1]
  end,
}))
settingRecycler.setLayoutManager(LinearLayoutManager(this))
--RecyclerView用法一样，不写了
--data={"1","2","3"}
settingRecycler.setAdapter(sAdapter)



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
      };
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
    --data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
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
      print(xposition)
      function delete()
        双按钮对话框("确认要删除吗?",
        "该项目将不可恢复,确认要继续吗?",
        "确认",
        "手滑了",function()
          关闭对话框(an)
          table.remove(data,xposition)
          io.open(内部存储路径2.."favTable.lua","w"):write(dump(data)):close()
          favadapter.notifyItemRemoved(position)
        end,
        function()
          关闭对话框(an)
        end)
      end

      function save()

      end
      pop=PopupMenu(activity,v.Tag.it)
      menu=pop.Menu
      menu.add("删除...").onMenuItemClick=function(a)
        delete()
      end
      menu.add("保存到相册").onMenuItemClick=function(a)
        save()
      end
      pop.show()--显示

      return true
    end
  end,
}))
--瀑布流管理器(第一个参数:几行,第二个参数:方向)
favRecycler.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
--print(dump(data))
favRecycler.setAdapter(favadapter)












