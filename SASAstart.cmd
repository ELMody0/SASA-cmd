@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title SASAstart - تجهيز الجهاز للعب + تحديث أوتوماتيك
color 0b

echo   ____    _    ____    _
echo  / ___|  / \  / ___|  / \
echo  \___ \ / _ \ \___ \ / _ \
echo   ___) / ___ \ ___) / ___ \
echo  |____/_/   \_\____/_/   \_\
echo.
echo    discord : sasax9
echo.

:: ============ تحديث أوتوماتيك لـ SASAstart من GitHub ============
set SA_VER=1
set "SRCURL="
if exist "%~dp0SASAsource.txt" ( set /p SRCURL=<"%~dp0SASAsource.txt" )
if defined SRCURL (
  if not "%SRCURL%"=="__SET_ME__" (
    powershell -NoProfile -Command "$v=1; try{$r=[int]([regex]::Match((New-Object Net.WebClient).DownloadString('%SRCURL%/version.txt'),'\d+').Value)}catch{$r=$v}; [IO.File]::WriteAllText('%TEMP%\sasa_upd.tmp', $(if($r -gt $v){'1'}else{'0'}))" >nul 2>&1
    set /p NEED=<"%TEMP%\sasa_upd.tmp"
    if "!NEED!"=="1" (
      echo.
      echo [تحديث] فيه نسخة أحدث من SASAstart علي GitHub.
      set /p UP="تحب تنزّل التحديث وتشغّله؟ (اكتب y او n): "
      if /i "!UP!"=="y" (
        echo بنزّل التحديث...
        powershell -NoProfile -Command "try{$wc=New-Object Net.WebClient; $wc.DownloadFile('%SRCURL%/SASAstart.cmd','%TEMP%\sasa_sta.tmp'); $wc.DownloadFile('%SRCURL%/SASAsource.txt','%TEMP%\sasa_src.tmp'); $wc.DownloadFile('%SRCURL%/version.txt','%TEMP%\sasa_ver.tmp')}catch{}" >nul 2>&1
        if exist "%TEMP%\sasa_sta.tmp" (
          copy /y "%TEMP%\sasa_sta.tmp" "%~dp0SASAstart.cmd" >nul 2>&1
          copy /y "%TEMP%\sasa_src.tmp" "%~dp0SASAsource.txt" >nul 2>&1
          copy /y "%TEMP%\sasa_ver.tmp" "%~dp0version.txt" >nul 2>&1
          echo [تحديث] خلص - بنشغّل النسخة الجديدة...
          start "" "%~f0" %*
          exit /b
        ) else ( echo [!] فشل التحميل - هنشغّل النسخة الحالية )
      ) else ( echo تمام - هنشغّل النسخة الحالية من غير تحديث )
    )
  )
)
:: =============================================================

:: رفع صلاحيات المدير لو متشغلش كادمن
fltmc >nul 2>&1 || (
  echo.
  echo [!] بنرفع صلاحيات المدير
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo ============================================
echo       SASAstart - تجهيز الجهاز للعب
echo ============================================
echo.

echo [1/3] بنشغل وضع الأداء العالي (High Performance)...
powercfg /setactive SCHEME_MIN
echo     (للرجوع للوضع العادي بعدين: powercfg /setactive SCHEME_BALANCED)

echo.
echo [2/3] البرامج اللي ممكن تقفلها عشان الجهاز يسرع للعب:
set APPS=chrome.exe msedge.exe firefox.exe opera.exe brave.exe discord.exe spotify.exe Telegram.exe WhatsApp.exe slack.exe skype.exe onedrive.exe Dropbox.exe vlc.exe
set /p DOIT="عايز أقفل البرامج اللي شغالة في الخلفية؟ (اكتب y او n): "
if /i "%DOIT%"=="y" (
  for %%A in (%APPS%) do (
    tasklist /fi "imagename eq %%A" | find /i "%%A" >nul 2>&1 && (
      set /p KILL="تقفل %%A ؟ (y/n): "
      if /i "!KILL!"=="y" (
        taskkill /im %%A /f >nul 2>&1 && echo     -- قفلنا %%A
      ) else (
        echo     -- سايبنا %%A شغال
      )
    )
  )
) else (
  echo     -- تمام، منقفلش حاجة.
)

echo.
echo [3/3] بنعمل ريست لكرت الشاشة (الشاشة هتطفى وتولع لحظة - طبيعي)...
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; Start-Sleep -Milliseconds 500; [System.Windows.Forms.SendKeys]::SendWait('+^{LWIN}b')"

echo.
echo ============================================
echo       الجهاز جاهز للعب
echo ============================================
echo - وضع الأداء العالي شغال
echo - البرامج اللي اخترتها اتقفلت
echo - كرت الشاشة اتعمله ريست
echo - (SASAstart اتحدث أوتوماتيك لو فيه نسخة جديدة)
echo.
echo لو عايز ترجع الجهاز لوضعه العادي بعد ما تخلص:
echo   powercfg /setactive SCHEME_BALANCED
echo.
pause
