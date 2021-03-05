require "import"
import "mods.Chimame_Core"

--涉及到校验，故简化
activity.setSharedData("isFirst",true)
io.open(内部存储路径2.."favTable.lua","w"):write("{}"):close()
openActivity.setData("Setting_Theme_Color",0)
activity.setSharedData("isKeepAwake",false)
渐变跳转页面("main")
activity.finish()