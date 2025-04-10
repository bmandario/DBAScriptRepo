@echo off
rem
rem Install .NET 3.5 on Windows 8, 8.1, 10, Server 2012, Server 2012 R2, Server 2016, and Server 2019
rem
rem Based on batch file from:
rem https://www.majorgeeks.com/files/details/install_the_microsoft_net_framework_3_5_offline_in_windows_10.html
rem 
rem Updated and explanded by Matthew Borcherding
rem matt@borchtech.com
rem 03-29-2019

   Title .NET Framework 3.5 Installer
   
   setlocal
   
   rem
   rem Check all drives (B through Z) for \sources\install.wim.
   rem If found, use this as the source to install .NET 3.5
   rem 
   
   for %%I in (B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist "%%I:\\sources\install.wim" set setupdrv=%%I
   
   if defined setupdrv goto setupdrv-found
   
   :no-setupdrv
      echo No installation media found!
	  echo Attempting to download and install from Microsoft instead...
	  echo.
		 
	  reg add "HKLM\software\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v RepairContentServerSource /t REG_DWORD /d 00000002 /f
		 
      echo Restarting Windows Update...
		 
	  net stop "Windows Update"
	  net start "Windows Update"
	  
	  echo Installing .NET Framework 3.5.  This can take a while...
	  echo.
		 
	  DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
	  echo.
	  goto end
	
   
    :setupdrv-found
	   echo Found Windows installation source on drive %setupdrv%...
	   echo.
	   echo Installing .NET Framework 3.5.  This can take a while...
	   echo.
	   
	   Dism /online /enable-feature /featurename:NetFX3 /All /Source:%setupdrv%:\sources\sxs /LimitAccess
	   
	
	  
	  
:end	  
   echo.
   echo .NET Framework 3.5 should now be installed.
   echo.
   
   pause