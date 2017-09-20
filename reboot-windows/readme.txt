1. 本工具是在windows系统下的重启/DC/AC测试工具，在重启过程中会检测硬件设备是否跟base一致。具体检测项目为CPU（number、name、core number 、threads number）、内存（size、speed、manufacturer、partnumber、serial number）、disk(interface、size、caption、firmwarerevision、model、serial number)、network(name、macaddress、speed、guid、manufacturer、service name)
2. 使用方法为在任意目录下右键start-reboot-windows.ps1选择run with powershell。按照提示输入：
（1）会先问是否需要启动自动登录。如果需要就输入y或者Y，然后分别输入用户名和密码；如果已经手动设置过自动登录了（control userpasswords2）,就不需要在这里设置了，输入除了y/Y之外的任意按键。
（2）然后会分别输出base信息供测试人员查看，然后会问是否继续测试。继续测试就输入y或者Y；不继续就出入n或者N。
（3）分别会提示你输入测试类别（reboot还是dc&ac)、进系统后重启的延迟时间（单位秒）、重启次数
3. 生成的日志会保存在c:\rebootlog文件夹下，以开始测试的时间命名的文件夹中（如2017年9月20日 8点10分11秒，则文件夹为20170920_081011）。里面包含了所有的base信息（以base_开头的）。最后所有的日志保存在reboot.log中，里面包含汇总的base信息、每一次启动的汇总的硬件信息、每一次重启之后的检测的结果（PASS或者FAIL）。
4. 如果想要停止测试，在进去系统后会出现一个cmd窗口，按ctrl+c结束当前测试，然后有两种操作。
（1）右键stop-reboot-windows.ps1选择run with powershell来结束测试。
（2）手动进入到 C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup ，将里面的reboot.cmd删除即可
5. 只能用administrator账号来进行测试。
