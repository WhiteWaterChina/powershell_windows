<#
Reboot scripts!
Log information and check every cycle!
Author:yanshuo@inspur.com
#>
[CmdletBinding()]
param
(
[int]$loop_count,
[int]$time_sleep,
$log_dir
)


function generate_base()
{
#Remove-Item "$log_dir\base*" -Force -Recurse
Write-Host " "
Write-Host "Below are the base informatin of this machine!" -ForegroundColor Green
echo "Below are the base informatin of this machine!"|Out-File -Force -Append "$log_dir\reboot.log"
#cpu info
#cpu number
$cpu_num_list=Get-WmiObject win32_processor|where {$_.status -eq "OK"}|Select-Object -ExpandProperty status
$cpu_num=$cpu_num_list.length
Write-Host "There are " -NoNewline
Write-Host $cpu_num -NoNewline -ForegroundColor Green
Write-Host " CPU on this machine!" 
echo $cpu_num |Out-File -Force -Append "$log_dir\base_cpu_num.log"
echo "CPU number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $cpu_num |Out-File -Force -Append "$log_dir\reboot.log"

#cpu name
$cpu_name_list=Get-WmiObject win32_processor|where {$_.status -eq "OK"}|Select-Object -ExpandProperty name
Write-Host "Their names are "
foreach ($count in $cpu_name_list)
{
Write-Host $count.tostring() -ForegroundColor Green
}
echo "$cpu_name_list" |Out-File -Force -Append "$log_dir\base_cpu_name.log"
echo "CPU name:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $cpu_name_list |Out-File -Force -Append "$log_dir\reboot.log"

#core number
$core_list=Get-WmiObject win32_processor|Select-Object -ExpandProperty NumberOfCores 
[int]$core_num=0
foreach ($count in $core_list)
{
$core_num=$core_num + $count
}
Write-Host "There are " -NoNewline
Write-Host $core_num -NoNewline -ForegroundColor Green
Write-Host " Cores!"
echo "$core_num" |Out-File -Force -Append "$log_dir\base_cpu_corenum.log"
echo "CPU core number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $core_num |Out-File -Force -Append "$log_dir\reboot.log"

# cpu threads
$cpu_threads_list=Get-WmiObject win32_processor|Select-Object -ExpandProperty NumberOfLogicalProcessors
[int]$threads_num=0
foreach ($count in $cpu_threads_list)
{
$threads_num=$threads_num + $count
}
Write-Host "There are " -NoNewline
Write-Host $threads_num -NoNewline -ForegroundColor Green
Write-Host " Threads!"
echo $threads_num|Out-File -Force -Append "$log_dir\base_cpu_threadsnum.log"
echo "CPU Threads Number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $threads_num|Out-File -Force -Append "$log_dir\reboot.log"

#memoryinfo
#show meminfo
Write-Host " "
Write-Host "Below are the information about Physical Memory!" -ForegroundColor Green
Get-WmiObject win32_physicalmemory|Format-Table -Property devicelocator, 
@{name='Size(GB)';expression=({$_.capacity / 1GB -as [int]})},
@{name='Current Speed';expression=({$_.ConfiguredClockSpeed})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='PartNumber';expression=({$_.PartNumber})},
@{name='SerialNumber';expression=({$_.SerialNumber})} 

echo "Memory infomation!"|Out-File -Force -Append "$log_dir\reboot.log"
(Get-WmiObject win32_physicalmemory|Format-Table -Property devicelocator, 
@{name='Size(GB)';expression=({$_.capacity / 1GB -as [int]})},
@{name='Current Speed';expression=({$_.ConfiguredClockSpeed})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='PartNumber';expression=({$_.PartNumber})},
@{name='SerialNumber';expression=({$_.SerialNumber})} )|Out-File -Force -Append "$log_dir\reboot.log"

#generate base file for mem
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty capacity|
Out-File -Force -Append "$log_dir\base_mem_size.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty ConfiguredClockSpeed|
Out-File -Force -Append "$log_dir\base_mem_speed.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty Manufacturer|
Out-File -Force -Append "$log_dir\base_mem_manufacturer.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty PartNumber|
Out-File -Force -Append "$log_dir\base_mem_partnumber.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty SerialNumber|
Out-File -Force -Append "$log_dir\base_mem_serialnumber.log"

#show physical drive info
Write-Host "Below are the information about Physical Drive!" -ForegroundColor Green
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid |Format-Table -Property deviceid,
@{name='interfacetype';expression=({$_.interfacetype})},
@{name='Size(GB)';expression=({$_.size / 1GB -as [int]})},
@{name='caption';expression=({$_.caption})},
@{name='Firmversion';expression=({$_.firmwarerevision})},
@{name='Model';expression=({$_.model})},
@{name='SerialNumber';expression=({$_.serialnumber})}

echo "Disk drive information!"|Out-File -Force -Append "$log_dir\reboot.log"
(Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid |Format-Table -Property deviceid,
@{name='interfacetype';expression=({$_.interfacetype})},
@{name='Size(GB)';expression=({$_.size / 1GB -as [int]})},
@{name='caption';expression=({$_.caption})},
@{name='Firmversion';expression=({$_.firmwarerevision})},
@{name='Model';expression=({$_.model})},
@{name='SerialNumber';expression=({$_.serialnumber})})|Out-File -Force -Append "$log_dir\reboot.log"

#generate base file for disk drive
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty interfacetype|
Out-File -Force -Append "$log_dir\base_disk_interface.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty size|
Out-File -Force -Append "$log_dir\base_disk_size.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty caption|
Out-File -Force -Append "$log_dir\base_disk_caption.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty firmwarerevision|
Out-File -Force -Append "$log_dir\base_disk_firmwarerevision.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty model|
Out-File -Force -Append "$log_dir\base_disk_model.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty serialnumber|
Out-File -Force -Append "$log_dir\base_disk_serialnumber.log"

#show network info
Write-Host "Below are the information about Physical Network!" -ForegroundColor Green
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Format-Table -Property Deviceid,
@{name='name';expression=({$_.name})},
@{name='macaddress';expression=({$_.macaddress})},
@{name='speed(Gb)';expression=({$_.speed /1GB -as [int]})},
@{name='guid';expression=({$_.guid})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='Driver name';expression=({$_.ServiceName})},
@{name='enabled or not';expression=({$_.netenabled})}

echo "Netork Information"|Out-File -Force -Append "$log_dir\reboot.log"
(Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Format-Table -Property Deviceid,
@{name='name';expression=({$_.name})},
@{name='macaddress';expression=({$_.macaddress})},
@{name='speed(Gb)';expression=({$_.speed /1GB -as [int]})},
@{name='guid';expression=({$_.guid})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='Driver name';expression=({$_.ServiceName})},
@{name='enabled or not';expression=({$_.netenabled})})|Out-File -Force -Append "$log_dir\reboot.log"

#generate base file for network
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty name|
Out-File -Force -Append "$log_dir\base_net_name.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty macaddress|
Out-File -Force -Append "$log_dir\base_net_macaddress.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty speed|
Out-File -Force -Append "$log_dir\base_net_speed.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty guid|
Out-File -Force -Append "$log_dir\base_net_guid.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty Manufacturer|
Out-File -Force -Append "$log_dir\base_net_manufacturer.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty ServiceName|
Out-File -Force -Append "$log_dir\base_net_servicename.log"
#Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|where {$_.netenabled}|
#Out-File -Force -Append "$log_dir\base_net_netenabled.log"
}

function generate_script ()
{
echo "@echo off"|Out-File -Encoding ascii reboot.cmd
echo "PowerShell -Command Set-ExecutionPolicy Unrestricted"|Out-File -Encoding ascii -Append reboot.cmd
echo "PowerShell C:\reboot.ps1"|Out-File -Encoding ascii -Append reboot.cmd
{
#get log dir path
$log_dir=Get-Content "c:\logdir_path.log"
#get current reboot times!
[int]$current_loop = Get-Content "$log_dir\current_loop.log"
[int]$total_count=Get-Content "$log_dir\loop_count_expect.txt"
$time_sleep_sub=Get-Content "$log_dir\sleeptime.txt"
$reboot_type=Get-Content "c:\reboot-type.log"
if ($current_loop -lt $total_count)
{
Start-Sleep -Seconds $time_sleep_sub
echo "This is $current_loop loop!"|Out-File -Force -Append "$log_dir\reboot.log"
Get-Date -Format yyyyMMdd_hhmmss|Out-File -Force -Append "$log_dir\reboot.log"
#cpu
#cpu number
$cpu_num_list=Get-WmiObject win32_processor|where {$_.status -eq "OK"}|Select-Object -ExpandProperty status
$cpu_num=$cpu_num_list.length
echo $cpu_num |Out-File -Force -Append "$log_dir\temp_cpu_num.log"
echo "CPU number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $cpu_num |Out-File -Force -Append "$log_dir\reboot.log"

#cpu name
$cpu_name_list=Get-WmiObject win32_processor|where {$_.status -eq "OK"}|Select-Object -ExpandProperty name
echo "$cpu_name_list" |Out-File -Force -Append "$log_dir\temp_cpu_name.log"
echo "CPU name:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $cpu_name_list |Out-File -Force -Append "$log_dir\reboot.log"

#cpu core number
$core_list=Get-WmiObject win32_processor|Select-Object -ExpandProperty NumberOfCores 
[int]$core_num=0
foreach ($count in $core_list)
{
$core_num=$core_num + $count
}
echo "$core_num" |Out-File -Force -Append "$log_dir\temp_cpu_corenum.log"
echo "CPU core number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $core_num |Out-File -Force -Append "$log_dir\reboot.log"

#cpu threads number
$cpu_threads_list=Get-WmiObject win32_processor|Select-Object -ExpandProperty NumberOfLogicalProcessors
[int]$threads_num=0
foreach ($count in $cpu_threads_list)
{
$threads_num=$threads_num + $count
}
echo $threads_num|Out-File -Force -Append "$log_dir\temp_cpu_threadsnum.log"
echo "CPU Threads Number:"|Out-File -Force -Append "$log_dir\reboot.log"
echo $threads_num|Out-File -Force -Append "$log_dir\reboot.log"

#mem
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty capacity|
Out-File -Force -Append "$log_dir\temp_mem_size.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty ConfiguredClockSpeed|
Out-File -Force -Append "$log_dir\temp_mem_speed.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty Manufacturer|
Out-File -Force -Append "$log_dir\temp_mem_manufacturer.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty PartNumber|
Out-File -Force -Append "$log_dir\temp_mem_partnumber.log"
Get-WmiObject win32_physicalmemory|Sort-Object -Property devicelocator|Select-Object -ExpandProperty SerialNumber|
Out-File -Force -Append "$log_dir\temp_mem_serialnumber.log"

echo "Memory infomation!"|Out-File -Force -Append "$log_dir\reboot.log"
(Get-WmiObject win32_physicalmemory|Format-Table -Property devicelocator, 
@{name='Size(GB)';expression=({$_.capacity / 1GB -as [int]})},
@{name='Current Speed';expression=({$_.ConfiguredClockSpeed})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='PartNumber';expression=({$_.PartNumber})},
@{name='SerialNumber';expression=({$_.SerialNumber})} )|Out-File -Force -Append "$log_dir\reboot.log"


#disk
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty interfacetype|
Out-File -Force -Append "$log_dir\temp_disk_interface.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty size|
Out-File -Force -Append "$log_dir\temp_disk_size.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty caption|
Out-File -Force -Append "$log_dir\temp_disk_caption.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty firmwarerevision|
Out-File -Force -Append "$log_dir\temp_disk_firmwarerevision.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty model|
Out-File -Force -Append "$log_dir\temp_disk_model.log"
Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty serialnumber|
Out-File -Force -Append "$log_dir\temp_disk_serialnumber.log"
echo "Disk drive information!"|Out-File -Force -Append "$log_dir\reboot.log"

(Get-WmiObject win32_diskdrive|where {$_.status -eq "OK"}|Sort-Object -Property deviceid |Format-Table -Property deviceid,
@{name='interfacetype';expression=({$_.interfacetype})},
@{name='Size(GB)';expression=({$_.size / 1GB -as [int]})},
@{name='caption';expression=({$_.caption})},
@{name='Firmversion';expression=({$_.firmwarerevision})},
@{name='Model';expression=({$_.model})},
@{name='SerialNumber';expression=({$_.serialnumber})})|Out-File -Force -Append "$log_dir\reboot.log"

#network
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty name|
Out-File -Force -Append "$log_dir\temp_net_name.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty macaddress|
Out-File -Force -Append "$log_dir\temp_net_macaddress.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty speed|
Out-File -Force -Append "$log_dir\temp_net_speed.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty guid|
Out-File -Force -Append "$log_dir\temp_net_guid.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty Manufacturer|
Out-File -Force -Append "$log_dir\temp_net_manufacturer.log"
Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Select-Object -ExpandProperty ServiceName|
Out-File -Force -Append "$log_dir\temp_net_servicename.log"
#Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|where {$_.netenabled}|
#Out-File -Force -Append "$log_dir\temp_net_netenabled.log"
echo "Netork Information"|Out-File -Force -Append "$log_dir\reboot.log"
(Get-WmiObject win32_networkadapter|where {$_.physicaladapter -eq "True"}|Sort-Object -Property deviceid|Format-Table -Property deviceid,
@{name='name';expression=({$_.name})},
@{name='macaddress';expression=({$_.macaddress})},
@{name='speed(Gb)';expression=({$_.speed /1GB -as [int]})},
@{name='guid';expression=({$_.guid})},
@{name='Manufacturer';expression=({$_.Manufacturer})},
@{name='Driver name';expression=({$_.ServiceName})},
@{name='enabled or not';expression=({$_.netenabled})})|Out-File -Force -Append "$log_dir\reboot.log"

#get hash for base and temp files
#base cpu
$hash_base_cpu_num=Get-FileHash -Path $log_dir\base_cpu_num.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_cpu_name=Get-FileHash -Path $log_dir\base_cpu_name.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_cpu_corenum=Get-FileHash -Path $log_dir\base_cpu_corenum.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_cpu_threadsnum=Get-FileHash -Path $log_dir\base_cpu_threadsnum.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#base mem
$hash_base_mem_size=Get-FileHash -Path $log_dir\base_mem_size.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_mem_speed=Get-FileHash -Path $log_dir\base_mem_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_mem_manufacturer=Get-FileHash -Path $log_dir\base_mem_manufacturer.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_mem_partnumber=Get-FileHash -Path $log_dir\base_mem_partnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_mem_serialnumber=Get-FileHash -Path $log_dir\base_mem_serialnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#base disk drive
$hash_base_disk_interface=Get-FileHash -Path $log_dir\base_disk_interface.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_disk_size=Get-FileHash -Path $log_dir\base_disk_size.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_disk_caption=Get-FileHash -Path $log_dir\base_disk_caption.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_disk_firmwarerevision=Get-FileHash -Path $log_dir\base_disk_firmwarerevision.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_disk_model=Get-FileHash -Path $log_dir\base_disk_model.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_disk_serialnumber=Get-FileHash -Path $log_dir\base_disk_serialnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#base network
$hash_base_net_name=Get-FileHash -Path $log_dir\base_net_name.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_net_macaddress=Get-FileHash -Path $log_dir\base_net_macaddress.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_net_speed=Get-FileHash -Path $log_dir\base_net_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_net_guid=Get-FileHash -Path $log_dir\base_net_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_net_manufacturer=Get-FileHash -Path $log_dir\base_net_manufacturer.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_base_net_servicename=Get-FileHash -Path $log_dir\base_net_servicename.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#$hash_base_net_netenabled=Get-FileHash -Path $log_dir\base_net_enabled.log -Algorithm SHA256|Select-Object -ExpandProperty hash

#temp cpu
$hash_temp_cpu_num=Get-FileHash -Path $log_dir\temp_cpu_num.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_cpu_name=Get-FileHash -Path $log_dir\temp_cpu_name.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_cpu_corenum=Get-FileHash -Path $log_dir\temp_cpu_corenum.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_cpu_threadsnum=Get-FileHash -Path $log_dir\temp_cpu_threadsnum.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#temp mem
$hash_temp_mem_size=Get-FileHash -Path $log_dir\temp_mem_size.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_mem_speed=Get-FileHash -Path $log_dir\temp_mem_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_mem_manufacturer=Get-FileHash -Path $log_dir\temp_mem_manufacturer.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_mem_partnumber=Get-FileHash -Path $log_dir\temp_mem_partnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_mem_serialnumber=Get-FileHash -Path $log_dir\temp_mem_serialnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#temp disk drive
$hash_temp_disk_interface=Get-FileHash -Path $log_dir\temp_disk_interface.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_disk_size=Get-FileHash -Path $log_dir\temp_disk_size.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_disk_caption=Get-FileHash -Path $log_dir\temp_disk_caption.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_disk_firmwarerevision=Get-FileHash -Path $log_dir\temp_disk_firmwarerevision.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_disk_model=Get-FileHash -Path $log_dir\temp_disk_model.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_disk_serialnumber=Get-FileHash -Path $log_dir\temp_disk_serialnumber.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#temp network
$hash_temp_net_name=Get-FileHash -Path $log_dir\temp_net_name.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_net_macaddress=Get-FileHash -Path $log_dir\temp_net_macaddress.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_net_speed=Get-FileHash -Path $log_dir\temp_net_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_net_guid=Get-FileHash -Path $log_dir\temp_net_speed.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_net_manufacturer=Get-FileHash -Path $log_dir\temp_net_manufacturer.log -Algorithm SHA256|Select-Object -ExpandProperty hash
$hash_temp_net_servicename=Get-FileHash -Path $log_dir\temp_net_servicename.log -Algorithm SHA256|Select-Object -ExpandProperty hash
#$hash_base_net_netenabled=Get-FileHash -Path $log_dir\temp_net_enabled.log -Algorithm SHA256|Select-Object -ExpandProperty hash

#compare base and temp file!
#Remove-Item -Path $log_dir\status.log -Force -ErrorAction SilentlyContinue
#cpu number
if ($hash_base_cpu_num -eq $hash_temp_cpu_num)
{
echo "CPU Number check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "CPU Number check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#cpu name
if ($hash_base_cpu_name -eq $hash_temp_cpu_name)
{
echo "CPU Name check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "CPU Name check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#cpu core number
if ($hash_base_cpu_corenum -eq $hash_temp_cpu_corenum)
{
echo "CPU Core Number check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "CPU Core Number check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#cpu threads number
if ($hash_base_cpu_threadsnum -eq $hash_temp_cpu_threadsnum)
{
echo "CPU Threads Number check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "CPU Threads Number check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#mem size
if ($hash_base_mem_size -eq $hash_temp_mem_size)
{
echo "Memory Size check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Memory Size check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#mem speed
if ($hash_base_mem_speed -eq $hash_temp_mem_speed)
{
echo "Memory Speed check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Memory Speed check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#mem manufacturer
if ($hash_base_mem_manufacturer -eq $hash_temp_mem_manufacturer)
{
echo "Memory Manufacturer check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Memory Manufacturer check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#mem partnumber
if ($hash_base_mem_partnumber -eq $hash_temp_mem_partnumber)
{
echo "Memory Partnumber check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Memory Partnumber check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#mem serialnumber
if ($hash_base_mem_serialnumber -eq $hash_temp_mem_serialnumber)
{
echo "Memory SerialNumber check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Memory SerialNumber check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk interface
if ($hash_base_disk_interface -eq $hash_temp_disk_interface)
{
echo "Disk Interface check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk Interface check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk size
if ($hash_base_disk_size -eq $hash_temp_disk_size)
{
echo "Disk Size check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk Size check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk caption
if ($hash_base_disk_caption -eq $hash_temp_disk_caption)
{
echo "Disk Caption check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk Caption check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk firmwarerevision
if ($hash_base_disk_firmwarerevision -eq $hash_temp_disk_firmwarerevision)
{
echo "Disk firmwarerevision check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk firmwarerevision check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk model
if ($hash_base_disk_model -eq $hash_temp_disk_model)
{
echo "Disk Model check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk Model check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#disk serialnumber
if ($hash_base_disk_serialnumber -eq $hash_temp_disk_serialnumber)
{
echo "Disk Serialnumber check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Disk Serialnumber check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network name
if ($hash_base_net_name -eq $hash_temp_net_name)
{
echo "Network Name check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network Name check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network macaddress
if ($hash_base_net_macaddress -eq $hash_temp_net_macaddress)
{
echo "Network Macaddress check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network Macaddress check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network speed
if ($hash_base_net_speed -eq $hash_temp_net_speed)
{
echo "Network Speed check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network Speed check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network guid
if ($hash_base_net_guid -eq $hash_temp_net_guid)
{
echo "Network GUID check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network GUID check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network manufacturer
if ($hash_base_net_manufacturer -eq $hash_temp_net_manufacturer)
{
echo "Network Manufacturer check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network Manufacturer check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}

#network service name
if ($hash_base_net_servicename -eq $hash_temp_net_servicename)
{
echo "Network Service name check OK!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "OK" |Out-File -Append -Force "$log_dir\status.log"
}
else
{
echo "Network Service name check FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
echo "FAIL" |Out-File -Append -Force "$log_dir\status.log"
}
$faillog=Get-Content "$log_dir\status.log"|Select-String -Pattern "FAIL"
if ($faillog.length -eq 0)
{
#Write-Host "PASS!"  -ForegroundColor Green
echo "This time is OK!"|Out-File -Append -Force "$log_dir\reboot.log"
}
else
{
#Write-Host "FAIL!"  -ForegroundColor Red
echo "This time is FAIL!"|Out-File -Append -Force "$log_dir\reboot.log"
}
Remove-Item "$log_dir\temp*" -Force -Recurse
Remove-Item "$log_dir\status.log" -Force -Recurse
[int]$count_next=$current_loop + 1
echo "$count_next"|Out-File -Force "$log_dir\current_loop.log"
Start-Sleep -Seconds 1
if ($reboot_type -eq "dcac")
{
Stop-Computer -Force
}
else
{
Restart-Computer -Force
}
}
}|Out-File -Force -Encoding ascii reboot.ps1
}


#main
$host.UI.RawUI.BufferSize = new-object System.Management.Automation.Host.Size(175,20000)
#use autologon or not
$autologon_or_not=Read-Host "If you need to enable autologon! If need, please input y/Y; if not need, please input anything except y/Y!"
if (($autologon_or_not -eq "y") -or ($autologon_or_not -eq "Y"))
{
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"  
#setting registry values
$DefaultUsername=Read-Host "Please input the username"
$DefaultPassword=Read-Host "Please input the password"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String  
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String  
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
}
#generate log dir
if (-not (Test-Path c:\rebootlog -PathType Container))
{
$null=New-Item -Path "c:\" -Name rebootlog -ItemType Directory 
}
#generate directory for log using current date
$current_date=Get-Date -Format yyyyMMdd_hhmmss
$log_dir="c:\rebootlog\$current_date"
$null=New-Item -Path "c:\rebootlog" -Name $current_date -ItemType Directory
echo "$log_dir"|Out-File -Force "c:\logdir_path.log"

#generate baseline
generate_base
#check baseline and decide to start reboot or not!
$go_or_not=Read-Host "Please check the base information! If OK, please input y/Y; if not OK, please input n/N!"


if (($go_or_not -eq "y") -or ($go_or_not -eq "Y"))
{

Write-Host "your choise is " -NoNewline
Write-Host $go_or_not -ForegroundColor Green
$type_reboot=Read-Host "Please input reboot type: 1-warm reboot; 2-dc&ac"
$time_sleep=Read-Host "Please input your reboot sleep time(Seconds)"
$loop_count=Read-Host "Please input your expect loop count"
if ($type_reboot -eq "1")
{
echo "reboot"|Out-File -Encoding ascii -Force "c:\reboot_type.log"
}
elseif ($type_reboot -eq "2")
{
echo "dcac"|Out-File -Encoding ascii -Force "c:\reboot-type.log"
}
else
{
Write-Host "Invalid input!" -ForegroundColor Red
Start-Sleep -Seconds 1
exit
}
Remove-Item -Path "C:\reboot.ps1" -Force -ErrorAction SilentlyContinue
generate_script($time_sleep)
Move-Item -Path reboot.ps1 -Destination "C:\" -Force
Move-Item -Path reboot.cmd -Destination "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Force

echo $time_sleep|Out-File -Force "$log_dir\sleeptime.txt"
echo $loop_count|Out-File -Force "$log_dir\loop_count_expect.txt"
echo "1"|Out-File -Force "$log_dir\current_loop.log"
Start-Sleep -Seconds $time_sleep
if ($type_reboot -eq "1")
{
Restart-Computer -Force
}
elseif ($type_reboot -eq "2")
{
Stop-Computer -Force
}
}
elseif (($go_or_not -eq "n") -or ($go_or_not -eq "N"))
{
Write-Host "your choise is " -NoNewline
Write-Host $go_or_not -ForegroundColor Green
exit
}
else
{
Write-Host "Invalid input!End the test!" -ForegroundColor Red
}
