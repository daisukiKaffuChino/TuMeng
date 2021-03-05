require "import"
import "mods.imports"
import "mods.sharedDataMod"
JSON=import "json"
loadlayout=import "mods.loadlayout"
_languages=import "mods.language"
string_zh_CN=_languages.zh_CN

状态栏高度=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)
SDK版本 = tonumber(Build.VERSION.SDK)
内部存储路径=Environment.getExternalStorageDirectory().toString().."/"
内部存储路径2="data/data/"..activity.getPackageName().."/"

function 状态栏颜色(n)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setStatusBarColor(n)
    statusbarcolor=n
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setStatusBarColor(0xffffffff)
       else
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        window.setStatusBarColor(n)
      end
    end
  end)
end

function 导航栏颜色(n,n1)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
    window.setNavigationBarColor(n)
    if SDK版本>=23 then
      if n==0x3f000000 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        window.setNavigationBarColor(0xffffffff)
       else
        if n1 then
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
         else
          window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
        end
        window.setNavigationBarColor(n)
      end
    end
  end)
end

function 沉浸状态栏(n1,n2,n3)
  pcall(function()
    local window=activity.getWindow()
    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
    pcall(function()
      window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
      window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
      window.setStatusBarColor(Color.TRANSPARENT)
      window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE)
    end)
    if SDK版本>=23 then
      if n1 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n2 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
       elseif n3 then
        window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR)
      end
    end

  end)
end

function isTableExist(tables,value)
  for index,content in pairs(tables) do
    if content:find(value) then
      return true
    end
  end
end

function getViewHeight(id)
local w = View.MeasureSpec.makeMeasureSpec(0,View.MeasureSpec.UNSPECIFIED)
id.measure(0,w)
return id.getMeasuredHeight()
end

function stringToTable(str)
  local ret = loadstring("return "..str)()
  return ret
end

function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end

function 写入文件(路径,内容)
  xpcall(function()
    f=File(tostring(File(tostring(路径)).getParentFile())).mkdirs()
    io.open(tostring(路径),"w"):write(tostring(内容)):close()
    end,function()
    提示("写入文件 "..路径.." 失败")
  end)
end

function 读取文件(路径)
  if 文件是否存在(路径) then
    rtn=io.open(路径):read("*a")
   else
    rtn=""
  end
  return rtn
end

function 文件是否存在(file)
  return File(file).exists()
end

function 内置存储(t)
  return Environment.getExternalStorageDirectory().toString().."/"..t
end


primaryc="#FFFA9FC1"
secondaryc="#ff64B5F6"
textc="#181818"
stextc="#454545"
sstextc="#909090"
backgroundc="#ffffffff"
barbackgroundc="#efffffff"
ebackgroundc="#ffffffff"
cardbackc="#0B282828"
viewshaderc="#00000000"
grayc="#ECEDF1"
bwz=0x30404040
pinkc="#FFFA9FC1"
卡片边框灰色 = "#ffe0e0e0"
灰色遮罩颜色 = "#9fffffff"
状态栏颜色(0x3f000000)
导航栏颜色(0x3f000000)
pcall(function()
  local _window = activity.getWindow();
  _window.setBackgroundDrawable(ColorDrawable(0xffffffff));
  local _wlp = _window.getAttributes();
  _wlp.gravity = Gravity.BOTTOM;
  _wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  _wlp.height = WindowManager.LayoutParams.MATCH_PARENT;--WRAP_CONTENT
  _window.setAttributes(_wlp);
  activity.setTheme(android.R.style.Theme_Material_Light_NoActionBar)
end)

function 转0x(j)
  if #j==7 then
    jj=j:match("#(.+)")
    jjj=tonumber("0xff"..jj)
   else
    jj=j:match("#(.+)")
    jjj=tonumber("0x"..jj)
  end
  return jjj
end

function 提示(t)
  local w=activity.width
  local tsbj={
    LinearLayout,
    Gravity="bottom",
    {
      CardView,
      layout_width="-1";
      layout_height="-2";
      CardElevation="0",
      CardBackgroundColor=转0x(textc)-0x3f000000,
      Radius="8dp",
      layout_margin="16dp";
      layout_marginBottom="64dp";
      {
        LinearLayout,
        layout_height=-2,
        layout_width="-2";
        gravity="left|center",
        padding="16dp";
        paddingTop="12dp";
        paddingBottom="12dp";
        {
          TextView,
          textColor=转0x(backgroundc),
          textSize="14sp";
          layout_height=-2,
          layout_width=-2,
          text=t;
          Typeface=字体("product")
        },
      }
    }
  }

  Toast.makeText(activity,t,Toast.LENGTH_SHORT).setGravity(Gravity.BOTTOM|Gravity.CENTER, 0, 0).setView(loadlayout(tsbj)).show()
end


function 随机数(最小值,最大值)
  return math.random(最小值,最大值)
end

function 设置视图(t)
  activity.setContentView(loadlayout(t))
end

function openApp(pm)
  local f,e=pcall(function ()
    this.startActivity(this.getPackageManager().getLaunchIntentForPackage(pm)
    .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))
  end)
  if e then
    提示("未安装该应用")
  end
end

ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)

function 波纹(id,lx)
  color=0
  xpcall(function()
    for index,content in pairs(id) do
      if lx=="圆白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="方白" then
        content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x3fffffff})))
      end
      if lx=="圆自适应" then
        if color==2 then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0xff64B5F6})))
        end
        if color==0 then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0xFFFA9FC1})))
        end
      end
      if lx=="方自适应" then
        if color==2 then
          content.backgroundDrawable=(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0xff64B5F6})))
        end
        if color==0 then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0xFFFA9FC1})))
        end

      end
      if lx=="圆黑白自适应" then
        if 全局主题值=="Night" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x2fffffff})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0x2f000000})))
        end
      end
      if lx=="方黑白自适应" then
        if 全局主题值=="Night" then
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x2fffffff})))
         else
          content.setBackgroundDrawable(activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{0x2f000000})))
        end
      end
    end
  end,function(e)end)
end

function 控件可见(a)
  a.setVisibility(View.VISIBLE)
end

function 控件不可见(a)
  a.setVisibility(View.INVISIBLE)
end

function 控件隐藏(a)
  a.setVisibility(View.GONE)
end

function 关闭对话框(en)
  if en then
    en.dismiss()
   else
    an.dismiss()
  end
end

function 控件圆角(view,radiu,InsideColor)
  drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(InsideColor)
  drawable.setCornerRadii({radiu,radiu,radiu,radiu,radiu,radiu,radiu,radiu});
  view.setBackgroundDrawable(drawable)
end

function 双按钮对话框(bt,nr,qd,qx,qdnr,qxnr,gb)
  if 全局主题值=="Day" then
    bwz=0x3f000000
   else
    bwz=0x3fffffff
  end

  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      id="ztbj";
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text=bt;
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ScrollView;
        layout_width="-1";
        layout_height="-1";
        {
          TextView;
          layout_width="-1";
          layout_height="-2";
          textSize="14sp";
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp";
          Typeface=字体("product");
          Text=nr;
          textColor=textc;
        };
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="2dp";
          background="#00000000";
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginBottom="24dp";
          Elevation="0";
          onClick=qxnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            Typeface=字体("product-Bold");
            paddingRight="16dp";
            paddingLeft="16dp";
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qx;
            textColor=stextc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
        {
          CardView;
          layout_width="-2";
          layout_height="-2";
          radius="4dp";
          background=primaryc;
          layout_marginTop="8dp";
          layout_marginLeft="8dp";
          layout_marginRight="24dp";
          layout_marginBottom="24dp";
          Elevation="1dp";
          onClick=qdnr;
          {
            TextView;
            layout_width="-1";
            layout_height="-2";
            textSize="16sp";
            paddingRight="16dp";
            paddingLeft="16dp";
            Typeface=字体("product-Bold");
            paddingTop="8dp";
            paddingBottom="8dp";
            Text=qd;
            textColor=backgroundc;
            BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
          };
        };
      };
    };
  };

  dl=AlertDialog.Builder(activity)
  dl.setView(loadlayout(dann))
  if gb==0 then
    dl.setCancelable(false)
  end
  an=dl.show()
  window = an.getWindow();
  window.setBackgroundDrawable(ColorDrawable(0x00ffffff));
  wlp = window.getAttributes();
  wlp.gravity = Gravity.BOTTOM;
  wlp.width = WindowManager.LayoutParams.MATCH_PARENT;
  wlp.height = WindowManager.LayoutParams.WRAP_CONTENT;
  window.setAttributes(wlp);
end

function 跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,cs)
   else
    activity.newActivity(ym)
  end
end

function 渐变跳转页面(ym,cs)
  if cs then
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out,cs)
   else
    activity.newActivity(ym,android.R.anim.fade_in,android.R.anim.fade_out)
  end
end


function 关闭页面()
  activity.finish()
end

function 复制文本(文本)
  activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(文本)
end

function 全屏()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
end

function 图标(n)
  return "res/twotone_"..n.."_black_24dp.png"
end

function 申请权限(权限)
  ActivityCompat.requestPermissions(this,权限,1)
end
--申请权限({Manifest.permission.WRITE_EXTERNAL_STORAGE})--不可用

function 浏览器打开(pageurl)
  import "android.content.Intent"
  import "android.net.Uri"
  viewIntent = Intent("android.intent.action.VIEW",Uri.parse(pageurl))
  activity.startActivity(viewIntent)
end

function 设置图片(preview,url)
  preview.setImageBitmap(loadbitmap(url))
end

function 字体(t)
  return Typeface.createFromFile(File(activity.getLuaDir().."/res/"..t..".ttf"))
end

function MEditText(v)
  local TransY=0
  if v.text~=nil then
    TransY=-dp2px(24/2)
  end
  return function()
    return loadlayout({
      LinearLayout;
      layout_width=v.layout_width;
      layout_height=v.layout_height;
      {
        CardView;
        CardElevation="0dp";
        CardBackgroundColor=cardbackc;
        Radius="8dp";
        layout_width="-1";
        layout_height="-2";
        {
          RelativeLayout;
          focusable=true;
          layout_width="-1";
          layout_height="-2";
          focusableInTouchMode=true;
          --paddingLeft="64dp";
          --paddingRight="64dp";
          {
            EditText;
            textColor=v.textColor;
            textSize="14sp";
            gravity="center|left";
            SingleLine=v.SingleLine;
            layout_width="-1";
            layout_height="-2";
            id=v.id;
            background="#00212121";
            padding="16dp";
            paddingTop="32dp";
            text=v.text;
            Typeface=字体("product");
            InputType=v.inputType;
            --[[
            addTextChangedListener={
              onTextChanged=function(_,_,_,_)
              end
            };
          --]]
            OnFocusChangeListener=({
              onFocusChange=function(vw,hasFocus)
                if hasFocus then
                  vw.getParent().getChildAt(1).setTextColor(转0x(secondaryc))
                  if vw.text=="" then
                    vw.getParent().getChildAt(1).startAnimation(TranslateAnimation(0,0,0,-dp2px(24/2)).setDuration(100).setFillAfter(true))
                  end
                 else
                  vw.getParent().getChildAt(1).setTextColor(转0x(v.HintTextColor))
                  if #vw.Text==0 then
                    vw.getParent().getChildAt(1).TranslationY=0
                    vw.getParent().getChildAt(1).startAnimation(TranslateAnimation(0,0,-dp2px(24/2),0).setDuration(100).setFillAfter(true))
                   else
                    vw.getParent().getChildAt(1).setTextColor(转0x(secondaryc))
                  end
                end
              end});
          };
          {
            TextView;
            textColor=v.HintTextColor;
            text=v.hint;
            textSize="14sp";
            layout_width="-1";
            layout_height="-2";
            gravity="center|left";
            padding="16dp";
            paddingTop="24dp";
            TranslationY=TransY;
            Typeface=字体("product-Bold");
          };
        };
      };
    })
  end
end

function checkStorePermission()
  io.open(内部存储路径.."Download/tumengTESTpermission","w"):write("nice"):close()
  os.remove(内部存储路径.."Download/tumengTESTpermission")
end


import "java.io.FileOutputStream"
import "android.content.ContentValues"
import "android.provider.MediaStore"
import "android.provider.DocumentsContract"
import "android.os.Environment"
import "android.content.Intent"
import "java.io.BufferedInputStream"
import "java.io.BufferedOutputStream"

function addBitmapToAlbum(bitmap, displayName)
  values = ContentValues()
  values.put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
  values.put(MediaStore.MediaColumns.MIME_TYPE, "image/png")
  if Build.VERSION.SDK_INT >= 29 then
    values.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
   else
    values.put(MediaStore.MediaColumns.DATA, "${Environment.getExternalStorageDirectory().path}/${Environment.DIRECTORY_PICTURES}/$displayName")
  end
  uri = activity.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
  if uri ~= nil then
    outputStream = activity.getContentResolver().openOutputStream(uri)
    if outputStream ~= nil then
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
      outputStream.close()
    end
  end
end

function oldSavePicture(name,bm)
  if bm then
    import "java.io.FileOutputStream"
    import "java.io.File"
    import "android.graphics.Bitmap"
    name=tostring(name)
    f = File(name)
    out = FileOutputStream(f)
    bm.compress(Bitmap.CompressFormat.PNG,100, out)
    out.flush()
    out.close()
    return true
   else
    return false
  end
end

function getStorePermission()
  双按钮对话框("需要存储读写权限",
  "虽然图萌已适配作用域存储，但这是 Android 10的新特性。在旧版本系统上，依旧需要授予读写权限才能进行下一步工作。",
  "允许读写权限",
  "取消",function()
    关闭对话框(an)
    申请权限({Manifest.permission.WRITE_EXTERNAL_STORAGE})
  end,
  function()
    关闭对话框(an)
  end)
end

function 通知图库更新图片(图片路径)
  import "android.media.MediaScannerConnection"
  MediaScannerConnection.scanFile(activity, {File(图片路径).getAbsolutePath()}, nil, nil)
end

function 转波纹(e)
  import 'android.content.res.ColorStateList'
  return (activity.Resources.getDrawable(activity.obtainStyledAttributes({android.R.attr.selectableItemBackground})
  .getResourceId(0,0)).setColor(ColorStateList(int[0].class{int{}},int{e}))
  .setColor(ColorStateList(int[0].class{int{}},int{e})))
end

function GetFileSize(path)
  import "java.io.File"
  import "android.text.format.Formatter"
  size=File(tostring(path)).length()
  Sizes=Formatter.formatFileSize(activity, size)
  return Sizes
end

