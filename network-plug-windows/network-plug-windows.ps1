<#
network plug out and in, and collect information at the same time !
Author:Ward Yan
Email:yanshuo@inspur.com;yanshuo1990@163.com
#>
[CmdletBinding()]
#$ErrorActionPreference="SilentlyContinue"
param (
#[parameter(Mandatory=$true)]
#[string]$Global:driver_name,
#[parameter(Mandatory=$true)]
#[string]$Global:ip_to_check,
$DEV_name_out,
$DEV_name_in,
$DEV_name_out_temp_1,
$DEV_name_out_temp_2,
$DEV_name_in_temp_1,
$DEV_name_in_temp_2,
[int]$number_true,
$flag_plug=1,
[int]$i=0
)

function plug_out()
{
#get device name that being pluged out
$temp_name_for_out=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|where{$_.netenabled -eq "True"}|Select-Object -ExpandProperty name
foreach ($name_for_out in $base_name_for_out)
{
if ($temp_name_for_out -notcontains $name_for_out)
{
$DEV_name_out=$name_for_out
}
}
Start-Sleep -Seconds 1
#show out
Write-Host $DEV_name_out -NoNewline -ForegroundColor Green
Write-Host " is plugged out! "
Write-Host "Please plug it in!"
#$flag_plug=0
Set-Variable -Name flag_plug -Value 0 -Scope 1
}

function plug_in()
{
$temp_name_for_in=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|where{$_.netenabled -ne "True"}|Select-Object -ExpandProperty name
foreach ($name_for_in in $base_name_for_in)
{
if ($temp_name_for_in -notcontains $name_for_in)
{
$DEV_name_in=$name_for_in
}
}
Start-Sleep -Seconds 1
#$flag_plug=1
Set-Variable -Name flag_plug -Value 1 -Scope 1
#get ipaddress for the device that pluged in
#first find out the interfaceindex according to the device name
$interfaceindex=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|where {$_.name -eq "$DEV_name_in"}|
Select-Object -ExpandProperty interfaceindex
#second find the ipaddress
$ipaddress_in=Get-NetIPAddress|where {$_.interfaceindex -eq "$interfaceindex"}|where {$_.AddressFamily -eq "IPv4"}| Select-Object -ExpandProperty ipaddress
#find the deviceid index
$deviceid_index=Get-WmiObject win32_networkadapter|where {$_.name -eq "$DEV_name_in"}|
Select-Object -ExpandProperty deviceid
#find the speed for this port!
$speed_this_port=Get-WmiObject win32_networkadapter|where {$_.name -eq "$DEV_name_in"}|
Select-Object -ExpandProperty speed
Write-Host $DEV_name_in -NoNewline -ForegroundColor Green
Write-Host " is plugged in! Current IPAddress is " -NoNewline
Write-Host $ipaddress_in  -ForegroundColor Green
Write-Host "Index of this port is " -NoNewline
Write-Host $deviceid_index -NoNewline -ForegroundColor Green
Write-Host " ! Current Speed is " -NoNewline
Write-Host $speed_this_port -NoNewline -ForegroundColor Green
Write-Host " bit/s!"
#get device status for current time!
$device_numbers=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|
Select-Object -ExpandProperty deviceid|Sort-Object
foreach ($count in $device_numbers)
{
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty name |Out-File -Append -Force "$log_dir_name\temp-devicename.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty macaddress |Out-File -Append -Force "$log_dir_name\temp-macaddress.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty speed |Out-File -Append -Force "$log_dir_name\temp-speed.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty netenabled |Out-File -Append -Force "$log_dir_name\temp-deviceenabled.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty guid |Out-File -Append -Force "$log_dir_name\temp-guid.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty Manufacturer |Out-File -Append -Force "$log_dir_name\temp-manufacturer.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty ServiceName |Out-File -Append -Force "$log_dir_name\temp-drivername.txt"
#Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
#Select-Object -ExpandProperty interfaceindex |Out-File "$log_dir_name\temp-interfaceindex.txt"
}

#export information for one cycle to log file "plug.log"
echo "Below are the infomation for the networks on this machinefor one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the device name for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-devicename.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the macadderss for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-macaddress.txt"|Out-File -Append -Force "$log_dir_nameplug.log"
echo "Below are the speed for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-speed.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the device enabled for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-deviceenabled.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the guid for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-guid.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the manufacturer for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-manufacturer.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the drivername for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-drivername.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
#echo "Below are the interfaceindex for the networks on this machine for one cycle!"|Out-File -Append -Force "$log_dir_name\plug.log"
#Get-Content ".\base-interfaceindex.txt"|Out-File -Append -Force ".\$log_dir_name\plug.log"

#get the filehash for files of base!
$hash_base_devicename=Get-FileHash -Path .\$log_dir_name\base-devicename.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_macaddress=Get-FileHash -Path .\$log_dir_name\base-macaddress.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_speed=Get-FileHash -Path .\$log_dir_name\base-speed.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_deviceenabled=Get-FileHash -Path .\$log_dir_name\base-deviceenabled.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_guid=Get-FileHash -Path .\$log_dir_name\base-guid.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_manufacturer=Get-FileHash -Path .\$log_dir_name\base-manufacturer.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_drivername=Get-FileHash -Path .\$log_dir_name\base-drivername.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
#$hash_base_interfaceindex=Get-FileHash .\$log_dir_name\base-interfaceindex.txt|Select-Object -ExpandProperty hash
#get the filehash for files of temp!
$hash_temp_devicename=Get-FileHash -Path .\$log_dir_name\temp-devicename.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_macaddress=Get-FileHash -Path .\$log_dir_name\temp-macaddress.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_speed=Get-FileHash -Path .\$log_dir_name\temp-speed.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_deviceenabled=Get-FileHash -Path .\$log_dir_name\temp-deviceenabled.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_guid=Get-FileHash -Path .\$log_dir_name\temp-guid.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_manufacturer=Get-FileHash -Path .\$log_dir_name\temp-manufacturer.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_drivername=Get-FileHash -Path .\$log_dir_name\temp-drivername.txt -Algorithm SHA256|Select-Object -ExpandProperty hash
#$hash_temp_interfaceindex=Get-FileHash .\$log_dir_name\temp-interfaceindex.txt|Select-Object -ExpandProperty hash
#compare baseline and current status!
#compare devicename
if ($hash_base_devicename -eq $hash_temp_devicename)
{
echo "devicename check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "devicename check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare macaddress
if ($hash_base_macaddress -eq $hash_temp_macaddress)
{
echo "macaddress check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "macaddress check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare speed
if ($hash_base_speed -eq $hash_temp_speed)
{
echo "speed check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "speed check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare deviceenabled
if ($hash_base_deviceenabled -eq $hash_temp_deviceenabled)
{
echo "deviceenabled check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "deviceenabled check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare guid
if ($hash_base_guid -eq $hash_temp_guid)
{
echo "guid check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "guid check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare manufacturer
if ($hash_base_manufacturer -eq $hash_temp_manufacturer)
{
echo "manufacturer check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "manufacturer check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#compare drivername
if ($hash_base_drivername -eq $hash_temp_drivername)
{
echo "drivername check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "drivername check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

#use ping to check link!
$result_ping_temp=(ping -S $ipaddress_in $ip_to_check).trim()|Select-String -Pattern "TTL="
$result_ping=$result_ping_temp.length
if ($result_ping -ne 0)
{
echo "ping check OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "OK" |Out-File -Append -Force "$log_dir_name\status.log"
}
else
{
echo "ping check FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "FAIL" |Out-File -Append -Force "$log_dir_name\status.log"
}

$faillog=Get-Content ".\$log_dir_name\status.log"|Select-String -Pattern "FAIL"
if ($faillog.length -eq 0)
{
Write-Host "PASS!"  -ForegroundColor Green
echo "OK!"|Out-File -Append -Force "$log_dir_name\plug.log"
}
else
{
Write-Host "FAIL!"  -ForegroundColor Red
echo "FAIL!"|Out-File -Append -Force "$log_dir_name\plug.log"
}
Remove-Item ".\$log_dir_name\temp*" -Force -Recurse
Remove-Item ".\$log_dir_name\status.log" -Force -Recurse
}

function generate_base()
{
#show base infomation
Write-Host "Please check base network information of this machine!" -ForegroundColor Green
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Format-Table -Property name,
@{name='MacAddress';expression={$_.macaddress}},
@{name='Speed(bit/s)';expression={if($_.netenabled -eq "True"){$_.speed}else{"None"}}},
@{name='GUID';expression={$_.guid}},
@{name='Manufacturer';expression={$_.manufacturer}},
#@{name='Driver Name';expression={$_.servicename}},
@{name='Enabled';expression={$_.netenabled}}

$flag_base=Read-Host "If all OK,please input y/Y to continue; if not OK,please input n/N to end this test"

if (($flag_base -eq "y") -or ($flag_base -eq "Y"))
{
Write-Host "you chose to continue!" -ForegroundColor Green
}
elseif (($flag_base -eq "n") -or ($flag_base -eq "N"))
{
Write-Host "you chose to end this test!" -ForegroundColor Red
exit
}
else
{
Write-Host "Invalid input! End the test!" -ForegroundColor Red
exit
}

#get phycical network devices infomation to write!
$device_numbers=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|
Select-Object -ExpandProperty deviceid|Sort-Object

foreach ($count in $device_numbers)
{
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty name |Out-File -Append -Force "$log_dir_name\base-devicename.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty macaddress |Out-File -Append -Force "$log_dir_name\base-macaddress.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty speed |Out-File -Append -Force "$log_dir_name\base-speed.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty netenabled |Out-File -Append -Force "$log_dir_name\base-deviceenabled.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty guid |Out-File -Append -Force "$log_dir_name\base-guid.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty Manufacturer |Out-File -Append -Force "$log_dir_name\base-manufacturer.txt"
Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
Select-Object -ExpandProperty ServiceName |Out-File -Append -Force "$log_dir_name\base-drivername.txt"
#Get-WmiObject win32_networkadapter|where {$_.deviceid -eq "$count"}|
#Select-Object -ExpandProperty interfaceindex |Out-File -Append -Force "$log_dir_name\base-interfaceindex.txt"
}
#export baseline info to log file "plug.log"
echo "Below are the baseline infomation for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline device name for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-devicename.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline macaddress for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-macaddress.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline speed for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-speed.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline device enabled for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-deviceenabled.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline guid for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-guid.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baselinemanufacturer for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-manufacturer.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
echo "Below are the baseline driver name for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
Get-Content ".\$log_dir_name\base-drivername.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
#echo "Below are the baseline interfaceindex for the networks on this machine!"|Out-File -Append -Force "$log_dir_name\plug.log"
#Get-Content ".\$log_dir_name\base-interfaceindex.txt"|Out-File -Append -Force "$log_dir_name\plug.log"
}

#main
#Write-Host "Please input number to identify network type!"
#Write-Host "1: Intel I350 & 82576 & X540" -BackgroundColor Yellow
#Write-Host "2: Intel Phy & 82599" -BackgroundColor Yellow
#Write-Host "3: Mellanox 25G" -BackgroundColor Yellow
#Write-Host "4: Intel X710" -BackgroundColor Yellow
#$flag_instanceid=Read-Host "Please input your chose"
#if ($flag_instanceid -eq "1")
#{
#$instanceid_out=2684616731
#$instanceid_in=1610874912
#Write-Host "you chose " -NoNewline
#Write-Host "1" -ForegroundColor Green
#}
#elseif ($flag_instanceid -eq "2")
#{
#$instanceid_out=2684616731
#$instanceid_in=1610874911
#Write-Host "you chose " -NoNewline
#Write-Host "2" -ForegroundColor Green
#}
#elseif ($flag_instanceid -eq "3")
#{
#$instanceid_out=2147942482
#$instanceid_in=1074200589
#Write-Host "you chose " -NoNewline
#Write-Host "3" -ForegroundColor Green
#}
#elseif ($flag_instanceid -eq "4")
#{
#$instanceid_out=2684616731
#$instanceid_in=1610874939
#Write-Host "you chose " -NoNewline
#Write-Host "3" -ForegroundColor Green
#}
#else
#{
#exit
#}

$ip_to_check=Read-Host "Please input an IPaddress to check link status"
$flag_plug=1
$DEV_name_out_temp_1=1
$DEV_name_out_temp_2=1
$DEV_name_in_temp_1=1
$DEV_name_in_temp_2=1
[string]$log_dir_name=Get-Date -Format yyyymmdd_hhmmss
$null=New-Item -Name $log_dir_name -ItemType Directory -Force
#clear eventlog
Clear-EventLog -LogName System 
#generate baseline
generate_base
Write-Host "Baseline generated succefully! Please plug out the network cable!"

$base_name_for_out=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|
where{$_.netenabled -eq "True"}|Select-Object -ExpandProperty name

#get device number for enabled & disabled.
$base_info=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Select-Object -ExpandProperty netenabled
$number_true=($base_info|Select-String -Pattern "True").length

while (0 -ne 1)
{
#plug out test
Start-Sleep -Seconds 1
$temp_info=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Select-Object -ExpandProperty netenabled
Start-Sleep -Seconds 1
$temp_number_true = ($temp_info| Select-String -Pattern "True").length
if ($temp_number_true -lt $number_true)
{
if ($flag_plug -eq 1)
{
#genegate base_name_for_out to check which one is pluged_out.use netenabled=True
Start-Sleep -Seconds 1
plug_out
$DEV_name_out_temp_2=$DEV_name_out_temp_1;
$DEV_name_out_temp_1=$DEV_name_out;
Clear-EventLog -LogName System
Start-Sleep -Seconds 1
$base_name_for_in=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|
where{$_.netenabled -ne "True"}|Select-Object -ExpandProperty name
}
}

#plug in test!
Start-Sleep -Seconds 1
if ($temp_number_true -eq $number_true)
{
if ($flag_plug -eq 0)
{
plug_in;
$DEV_name_in_temp_2=$DEV_name_in_temp_1;
$DEV_name_in_temp_1=$DEV_name_in;
Clear-EventLog -LogName System
Start-Sleep -Seconds 1
$base_name_for_out=Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|
where{$_.netenabled -eq "True"}|Select-Object -ExpandProperty name

if ($DEV_name_in -eq $DEV_name_in_temp_2)
{
$i=$i+1
Write-Host "This is "-NoNewline
Write-Host "$i" -NoNewline -ForegroundColor Green
Write-Host " times!" 
Write-Host "Please plug it out!"
}
else
{
[int]$i=1
Write-Host "This is " -NoNewline
Write-Host "$i" -NoNewline -ForegroundColor Green
Write-Host " times!" 
Write-Host "Please plug it out!"
}
}
}
continue
}
