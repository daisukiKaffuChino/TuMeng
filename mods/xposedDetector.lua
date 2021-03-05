require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"

--[[ Mod by daisukiKaffuChino
原文件哪里找的，我也不知道
参考https://blog.csdn.net/earbao/article/details/82746138
]]

local function Table_exists(tables,value)
  for index,content in pairs(tables) do
    if content:find(value) then
      return true
    end
  end
end

local function endsWith(sss,str)
  if sss:match(".") then
    if str==tostring(sss):match("%.(.+)") then
      return true
     else
      return false
    end
  end
end

function isHookByJar()
  import"android.os.Process"
  isHook = false;
  libraries = {};
  mapsFilename = "/proc/" .. Process.myPid() .. "/maps";
  reader = BufferedReader(FileReader(mapsFilename));
  while reader.readLine() ~= nil do
    if endsWith(tostring(reader.readLine()),"jar") ||endsWith(tostring(reader.readLine()),"so")then
      line=tostring(reader.readLine())
      table.insert(libraries,tostring(line))
    end
  end

  library=0
  while library~=#libraries do
    library=library+1

    if libraries[library]:match("XposedBridge.jar") then
      --Log.wtf("HookDetection", "Xposed JAR found: " + library);
      isHook = true;
    end
    if libraries[library]:match("com.saurik.substrate") then
      -- Log.wtf("HookDetection", "Substrate shared object found: " + library);
      isHook = true;
    end
  end
  if libraries[library]:match("DexspyInstaller") then
    -- Log.wtf("HookDetection", "Substrate shared object found: " + library);
    isHook = true;
  end
  if libraries[library]:match("twframework") then
    -- Log.wtf("HookDetection", "Substrate shared object found: " + library);
    isHook = true;
  end
  if libraries[library]:match("core") then
    -- Log.wtf("HookDetection", "Substrate shared object found: " + library);
    isHook = true;
  end
  reader.close();
  return isHook;
end

function ishookObject()
  import "java.lang.Exception"
  import "android.util.Log"
  import "org.apache.commons.logging.Log"
  import "java.lang.ClassLoader"
  if pcall(function()
      localObject = ClassLoader.getSystemClassLoader().loadClass("de.robv.android.xposed.XposedHelpers").newInstance();
    end)
    --如果加载类失败 则表示当前环境没有xposed) then
    return true
   else
    return false
  end
end

function ishookclass()
  import "java.lang.Exception"
  e=Exception("Deteck hook")
  ishook=false
  zygoteInitCallCount = 0;
  for index, stackTraceElement in ipairs(luajava.astable(e.getStackTrace())) do
    --print(stackTraceElement)
    if(stackTraceElement.getClassName():match("com.android.internal.os.ZygoteInit")) then
      zygoteInitCallCount=zygoteInitCallCount+1;
      zygoteInitCallCount=zygoteInitCallCount+1
      if(zygoteInitCallCount == 2) then
        -- Log.wtf("HookDetection", "Substrate is active on the device.");
      end
    end
    if(stackTraceElement.getClassName():match("com.saurik.substrate.MS$2") &&
      stackTraceElement.getMethodName():match("invoked")) then
      ishook=true
      -- Log.wtf("HookDetection", "A method on the stack trace has been hooked using Substrate.");
    end
    if(stackTraceElement.getClassName():match("de.robv.android.xposed.XposedBridge") &&
      stackTraceElement.getMethodName():match("main")) then
      ishook=true
      -- Log.wtf("HookDetection", "Xposed is active on the device.");
    end
    if(stackTraceElement.getClassName():match("de.robv.android.xposed.XposedBridge") &&
      stackTraceElement.getMethodName():match("handleHookedMethod")) then
      ishook=true
    end
  end
  return ishook
end

function 反制xposed()
  local t = ClassLoader.getSystemClassLoader()
  .loadClass(tostring("de.robv.android.xposed.XposedBridge"))
  .getDeclaredField("disableHooks");
  t.setAccessible(true);
  t.set(nil, Boolean.valueOf(true));
end
