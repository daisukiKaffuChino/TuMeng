require "import"
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
          onClick=function()
            activity.finish()
          end;
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
          text="LogCat";
          id="title";
          paddingLeft="4dp";
          textSize="18sp";
          layout_height="-2";
          layout_width="-2";
          Typeface=字体("product-Bold");
        };
        {
          LinearLayout;
          layout_weight="1";
        };
        {
          EditText;
          layout_height="-2";
          layout_marginRight="16dp";
          SingleLine="true";
          Hint="搜索关键字...";
          id="edit";
          textSize="16sp";
          textColor=stextc;
          Typeface=字体("product");
          layout_width=activity.getWidth()*0.25;
        };
        {
          ImageView;
          ColorFilter=primaryc;
          src=图标("more_vert");
          layout_height="32dp";
          layout_width="32dp";
          padding="4dp";
          id="more";
          onClick=function()
            cpop.showAsDropDown(more)
          end;
        };
      };
    };
    {
      ListView,
      layout_height="fill",
      layout_width="fill",
      DividerHeight=0;
      id="scroll",
    },
  };
};

activity.setContentView(loadlayout(layout))

波纹({fh,more},"圆自适应")

etBgStates={
  {android.R.attr.state_focused},
  {android.R.attr.state_enabled},
}
etBgColor={转0x(primaryc),转0x(primaryc)}
edit.setBackgroundTintList(ColorStateList(etBgStates,etBgColor))


item={
  LinearLayout;
  layout_width="-1";
  layout_height="-2";
  {
    CardView;
    CardElevation="0dp";
    CardBackgroundColor=卡片边框灰色;
    Radius="8dp";
    layout_width="-1";
    layout_height="-2";
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        TextView;
        id="text";
        textColor=textc;
        layout_width="fill";
        layout_height="-2";
        textSize="14sp";
        gravity="left|center";
        padding="16dp";
        Typeface=字体("product");
      };
    };
  };
};

local r="%[ *%d+%-%d+ *%d+:%d+:%d+%.%d+ *%d+: *%d+ *%a/[^ ]+ *%]"

function readlog(s)
  p=io.popen("logcat -d -v long "..s)
  local s=p:read("*a")
  p:close()
  s=s:gsub("%-+ beginning of[^\n]*\n","")
  if #s==0 then
    s="<run the app to see its log output>"
  end
  return s
end

function clearlog()
  p=io.popen("logcat -c")
  local s=p:read("*a")
  p:close()
  return s
end

function show(s)
  -- logview.setText(s)
  --print(s)
  local a=LuaAdapter(activity,item)
  local l=1
  for i in s:gfind(r) do
    if l~=1 then
      a.add{text=s:sub(l,i-1)}
    end
    l=i
  end

  a.add{text=s:sub(l)}
  adapter=a
  scroll.Adapter=a
end


edit.addTextChangedListener{
  onTextChanged=function(c)
    scroll.adapter.filter(tostring(c))
  end}

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
cpop.setWidth(dp2px(168))
cpop.setHeight(-2)
cpop.setOutsideTouchable(true)
cpop.setBackgroundDrawable(ColorDrawable(0x00000000))
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
cpopadp.add{popadp_text="All"}--添加项目(菜单项)
cpopadp.add{popadp_text="Lua"}
cpopadp.add{popadp_text="Tcc"}
cpopadp.add{popadp_text="Warning"}
cpopadp.add{popadp_text="Info"}
cpopadp.add{popadp_text="Debug"}
cpopadp.add{popadp_text="Verbose"}
cpopadp.add{popadp_text="Clear"}

cPopup_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent, v, pos,id)
    cpop.dismiss()
    if v.Tag.popadp_text.Text=="All" then
      title.setText("LogCat - All")
      task(readlog,"",show)
     elseif v.Tag.popadp_text.Text=="Lua" then
      title.setText("LogCat - Log")
      task(readlog,"lua:* *:S",show)
     elseif v.Tag.popadp_text.Text=="Tcc" then
      title.setText("LogCat - Tcc")
      task(readlog,"tcc:* *:S",show)
     elseif v.Tag.popadp_text.Text=="Warning" then
      title.setText("LogCat - Warning")
      task(readlog,"*:E",show)
     elseif v.Tag.popadp_text.Text=="Info" then
      title.setText("LogCat - Info")
      task(readlog,"*:I",show)
     elseif v.Tag.popadp_text.Text=="Debug" then
      title.setText("LogCat - Debug")
      task(readlog,"*:D",show)
     elseif v.Tag.popadp_text.Text=="Verbose" then
      title.setText("LogCat - Verbode")
      task(readlog,"*:V",show)
     elseif v.Tag.popadp_text.Text=="Clear" then
      task(clearlog,show)

    end
  end})

