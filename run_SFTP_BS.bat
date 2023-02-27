@echo off

del /Q C:\BS_Script\*.zip

set dayname=%date:~0,3%

set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 (set CUR_HH=0%time:~1,1%)

set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set CUR_MS=%time:~9,2%

set SUBFILENAME=%CUR_YYYY%%CUR_MM%%CUR_DD%-%CUR_HH%%CUR_NN%%CUR_SS%

echo { "version":"2.0" } > C:\BrightSpace\Exports\manifest.json

"C:\Program Files\7-Zip\7z.exe" a -tzip C:\BS_Script\%SUBFILENAME%.zip C:\BrightSpace\Exports\*
"C:\Program Files\7-Zip\7z.exe" a -tzip C:\BS_Script\%dayname%.zip     C:\BrightSpace\Exports\*

echo "backup a set on pkgash.nl, 7 day cycle"

"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\BS_Script\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://brightspace:ch3ckz1p@pkg.ash.nl/ -hostkey=""ssh-ed25519 255 Mg7gN3bhClLCMXeCv/kOf+2F4Mw3xZ4FMpxEIc0nZCQ="" -rawsettings FSProtocol=2" ^
    "put -resumesupport=off C:\BS_Script\%dayname%.zip /home/brightspace/" ^
    "exit"

echo "upload into brightspace"

"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\BS_Script\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://sftp-ash-0xffffff:it%%pASSword%%goES%%herE%%1234@eu01pipsissftp.brightspace.com/ -hostkey=""ssh-ed25519 255 uF/boFruBBag8nZeKtOBTZQO4xWUFyAmEpuZaxeyMvc="" -rawsettings FSProtocol=2" ^
    "put -resumesupport=off C:\BS_Script\%SUBFILENAME%.zip /" ^
    "exit"


set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
  echo Success
  del /Q C:\BrightSpace\Exports\*
 
) else (
  echo Error
)

exit /b %WINSCP_RESULT%
