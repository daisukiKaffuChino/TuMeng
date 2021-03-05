require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.ColorDrawable"
import "androidx.palette.graphics.*"
import "android.content.Context"

function picThemeColor(bit)
  --bit =BitmapFactory.decodeFile(bits)
  palette = Palette.generate(bit)
  vibrant = palette.getVibrantColor(0x000000)--充满活力的色调
  vibrantLight = palette.getLightVibrantColor(0x000000)--充满活力的亮
  vibrantDark = palette.getDarkVibrantColor(0x000000)--活力的黑
  muted = palette.getMutedColor(0x000000)--柔和的色调
  mutedLight = palette.getLightMutedColor(0x000000)--柔和的亮
  mutedDark = palette.getDarkMutedColor(0x000000)--柔和的黑
  --返回从调色板中占主导地位的样本的颜色，为RGB包装INT。
  Dominant = palette.getDominantColor(0x000000)
  --颜色存储
  color_table = {vibrant,vibrantLight,vibrantDark,muted,mutedLight,vibrant,mutedDark,Dominant,vibrantLight,muted}
  color_text = {}
  for k,v in pairs(color_table) do
    a = string.format("%#x",v)
    a = string.gsub(a,"ffffffff","")
    color_text[k] = a
  end

  itemx={
    LinearLayout;
    id="color_show";
    layout_width="fill";
    layout_height="7dp";
    Gravity="center";
  };

  pTdata={}
  xadp=LuaAdapter(activity,pTdata,itemx)
  for n=1,#color_table do
    table.insert(pTdata,{
      color_show={
        BackgroundDrawable=ColorDrawable(color_table[n])
      },
    })
  end
  colorTypeGrid.Adapter=xadp
end
