require "import"
import "mods.Chimame_Core"
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
import "android.support.v7.widget.*"
import "com.LuaRecyclerAdapter"
import "com.LuaRecyclerHolder"
import "com.AdapterCreator"
import "bmob"

pyear,pmonth=...

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
          text=pyear.."年"..pmonth;
          paddingLeft="16dp";
          textSize="20sp";
          layout_height="-2";
          layout_width="-2";
          Typeface=字体("product-Bold");
        };
      };
    };
    {
      FrameLayout,
      layout_width = "fill",
      layout_height = "fill",
      {
        RecyclerView,
        layout_height="fill",
        layout_width="fill",
        id="recy",
      },
      {
        LinearLayout,
        layout_height = "fill",
        layout_width = "fill",
        gravity = "center",
        id = "_Progress",
        {
          ProgressBar,
          id = "Progress",
          layout_gravity = "center"
        },
      },
    },
  };
}

activity.setContentView(loadlayout(layout))

波纹({fh},"圆自适应")
--print(pyear..pmonth)

item={
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
        adjustViewBounds="true";
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

adp=LuaRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #data
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    holder=LuaRecyclerHolder(loadlayout(item,views))
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
      pop=PopupMenu(activity,v.Tag.it)
      menu=pop.Menu

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
recy.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
--data=stringToTable(io.open(内部存储路径2.."favTable.lua"):read("*a"))
--print(dump(data))
--recy.setAdapter(adp)

Progress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))

function getData()
  当前版本=tonumber((this.getPackageManager().getPackageInfo(this.getPackageName(),64).versionCode))
  local b=bmob(bmobID,bmobKey)
  b:query("tumengOthers",function(code,json)
    if code~=-1 and code>=200 and code<400 then
      最后允许版本号=tonumber(json.results[1].lastAllowVer)
      if 最后允许版本号==nil then 最后允许版本号=1 end
      表=json.results[1].tables
      if 当前版本<最后允许版本号 then
        提示("客户端版本过低")
        activity.finish()
       else
       _Progress.Visibility=8
        data=stringToTable(表)
        recy.setAdapter(adp)
      end
     else
     _Progress.Visibility=8
      提示("连接服务器失败 ("..code..")")
    end
  end)
end
getData()


