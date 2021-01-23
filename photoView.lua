require "import"
import "android.widget.*"
import "android.view.*"
import "mods.Chimame_Core"
import "com.coolapk.market.widget.photoview.PhotoView"
--import "uk.co.senab.photoview.PhotoView"
--酷安的photoview太好用了

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
导航栏颜色(0xffffffff)

pic=...

layout = {
  LinearLayout,
  orientation = "vertical",
  layout_width = "fill",
  layout_height = "fill",
  gravity = "center",
  {
    PhotoView,
    layout_width = "fill",
    layout_height = "fill",
    background = "#000000",
    id = "mPhotoView",
  },
}

activity.setContentView(loadlayout(layout))

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
--[
mPhotoView.enable()
mPhotoView.enableRotate()
mPhotoView.setAnimaDuring(500)
mPhotoView.setAdjustViewBounds(true)
--]]
import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
Glide.with(this).load(pic).fitCenter().skipMemoryCache(true).diskCacheStrategy(DiskCacheStrategy.NONE).into(mPhotoView)


