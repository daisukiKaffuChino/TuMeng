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
        a = string.format('%#x',v)
        a = string.gsub(a,'ffffffff','')
        color_text[k] = a
      end

      --name={"充满活力的色调","充满活力的亮","活力的黑","柔和的色调","柔和的亮","柔和的黑","主色"}
      --适配器
      itemx={
        LinearLayout;--线性布局
        id='color_show';
        layout_width='fill';--布局宽度
        layout_height='7dp';--布局高度
        Gravity='center';--对齐方式
        
      };
      --创建项目数组
      pTdata={}
      --创建适配器
      xadp=LuaAdapter(activity,pTdata,itemx)
      --添加数据
      for n=1,#color_table do
        table.insert(pTdata,{          
          color_show={
            BackgroundDrawable=ColorDrawable(color_table[n])
          },
        })
      end
      --设置适配器
      colorTypeGrid.Adapter=xadp
      end
