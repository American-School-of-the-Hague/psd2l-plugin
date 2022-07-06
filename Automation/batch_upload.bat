@echo off
REM this script automates SFTP of CSV files to 
REM Brightspace IPSIS 
REM Dependencies: 7-zip, Win-SCP

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

"C:\Program Files\7-Zip\7z.exe" a -tzip D:\BS_Script\%SUBFILENAME%.zip C:\BrightSpace\Exports\*

REM Update the URL and Password in this portion of the script to match the password found
REM in the IPSIS configuration screen: https://lms.ash.nl/d2l/im/ipsis/admin/console/integration/3/configuration
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="D:\BS_Script\WinSCP.log" /ini=nul ^
  /command ^
    "open sftp://sftp-ash-e8fd:_5SReq%%2F4Ln7%%21j7%%5BK@eu01pipsissftp.brightspace.com/ -hostkey=""ssh-ed25519 255 ENTER_KEY_HERE""" ^
    "put -resumesupport=off D:\BS_Script\%SUBFILENAME%.zip /" ^
    "exit"

set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
  echo Success
  del /Q C:\BrightSpace\Exports\*
  del /Q D:\BS_Script\*.zip
) else (
  echo Error
)

exit /b %WINSCP_RESULT%