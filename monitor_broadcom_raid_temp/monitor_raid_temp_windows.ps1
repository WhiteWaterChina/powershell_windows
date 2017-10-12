<#
Monitor Broadcom RAID card chip & bbu temperature while doing stress!
only need one parameter,the total times(seconds)!
output is an image named "Image_temperature.png"
Author:yanshuo@inspur.com
#>

[CmdletBinding()]
param
(
[int]$total_time,
$log_dir
)
$total_time=Read-Host "Please input total last times(seconds)"
$current_date=Get-Date -Format yyyyMMdd_HHmmss
$null=New-Item -Name $current_date -ItemType Directory
$log_dir=Resolve-Path $current_date|Select-Object -ExpandProperty path

$start_time=Get-Date
while (0 -ne 1)
{
$current_time=Get-Date
[int]$lasttime_temp=(New-TimeSpan -Start $start_time -end $current_time).TotalSeconds

if ($lasttime_temp -gt $total_time)
{
break
}
else
{
$chip_temp_temp=((.\storcli64.exe /c0 show all)|Out-String) -match "ROC\s+.*?(\d+)"
$chip_temp=$Matches[1]
$bbu_temp_temp=((.\storcli64.exe /c0/cv show all)|Out-String) -match "Temperature\s+(\d+\d*)\s*C"
$bbu_temp=$Matches[1]
echo "$lasttime_temp,$bbu_temp"|Out-File -Append -Force -Encoding ascii "$log_dir\bbu_temp"
echo "$lasttime_temp,$chip_temp"|Out-File -Append -Force -Encoding ascii "$log_dir\chip_temp"
sleep 5
}
}

#filter data of chip
$data_chip_temp=Get-Content "$log_dir\chip_temp"
$length_chip=$data_chip_temp.Length
for ($item=0;$item -lt $length_chip;$item++)
{
$data_chip_temp[$item].split(",")[1]|Out-File -Force -Append "$log_dir\chip_temp_temp"
}
$data_chip=Get-Content "$log_dir\chip_temp_temp"
$result_data_chip=$data_chip|Measure-Object -Minimum -Maximum
$max_chip_temp=$result_data_chip.Maximum
$min_chip_temp=$result_data_chip.Minimum

#filter data for bbu
$data_bbu_temp=Get-Content "$log_dir\bbu_temp"
$length_bbu=$data_bbu_temp.Length
for ($item=0;$item -lt $length_bbu;$item++)
{
$data_bbu_temp[$item].split(",")[1]|Out-File -Force -Append "$log_dir\bbu_temp_temp"
}
$data_bbu=Get-Content "$log_dir\bbu_temp_temp"
$result_data_bbu=$data_bbu|Measure-Object -Minimum -Maximum
$max_bbu_temp=$result_data_bbu.Maximum
$min_bbu_temp=$result_data_bbu.Minimum

#filter data to plot in one picture
if ($max_chip_temp -gt $max_bbu_temp)
{
$max_temp=$max_chip_temp
}
else
{
$max_temp=$max_bbu_temp
}

if ($min_chip_temp -lt $min_bbu_temp)
{
$min_temp=$min_chip_temp
}
else
{
$min_temp=$min_bbu_temp
}

$max_temperature=[int]$max_temp + 2
$min_temperature=[int]$min_temp - 2

#plot image
$scripts=@"
set terminal png
set title 'Temperature'
set datafile separator ','
set xrange [0:${lasttime_temp}]
set yrange [${min_temperature}:${max_temperature}]
set ylabel 'Temperature(Celsius)'
set xlabel 'Time(s)'
set output "Image_temperature.png"
set border 3 lt 3 lw 2
set key box
plot '${log_dir}\bbu_temp' title 'BBU Temp' w lp pt 5, '${log_dir}\chip_temp'  title 'Chip Temp' w lp pt 7 
set output
"@
[System.IO.File]::WriteAllLines("${log_dir}\gnuplot.txt",$scripts, (New-Object System.Text.UTF8Encoding $False))
.\bin\gnuplot.exe $log_dir\gnuplot.txt
Move-Item Image_temperature.png -Destination $log_dir