require "import"
import "android.widget.*"
import "android.view.*"
import "mods.Chimame_Core"
--import "com.coolapk.market.widget.photoview.PhotoView"
import "com.coolapk.market.widget.photoview.PhotoView"
import "layout.photoView"
--import "uk.co.senab.photoview.PhotoView"
--酷安的photoview太好用了

activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
导航栏颜色(0xff000000)

pic=...

activity.setContentView(loadlayout("layout/photoView"))
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
Progress.IndeterminateDrawable.setColorFilter(PorterDuffColorFilter(转0x(primaryc), PorterDuff.Mode.SRC_ATOP))

mPhotoView.enable()
mPhotoView.enableRotate()
mPhotoView.setAnimaDuring(500)
mPhotoView.setAdjustViewBounds(true)

import "com.bumptech.glide.*"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
Glide.with(this)
.load(pic)
.listener({
  onResourceReady=function()
    _PhotoView.Visibility=0
    _Progress.Visibility=8
    return false
  end,
})
.fitCenter()
.skipMemoryCache(true)
.diskCacheStrategy(DiskCacheStrategy.NONE)
.into(mPhotoView)


