require "import"
import "android.widget.*"
import "android.view.*"
import "mods.Chimame_Core"

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
导航栏颜色(0xffffffff)

layout = {
  LinearLayout,
  orientation = "vertical",
  layout_width = "fill",
  layout_height = "fill",
  gravity = "center",
  {
    ImageView,
    layout_width = "fill",
    layout_height = "fill",
    background = "#000000",
    id = "mPhotoView",
  },
}

activity.setContentView(loadlayout(layout))

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)

import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
Glide.with(this).load("file:///android_asset/res/easterEgg.gif").fitCenter().skipMemoryCache(true).diskCacheStrategy(DiskCacheStrategy.NONE).into(mPhotoView)


