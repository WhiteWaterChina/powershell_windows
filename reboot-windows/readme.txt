1. ����������windowsϵͳ�µ�����/DC/AC���Թ��ߣ������������л���Ӳ���豸�Ƿ��baseһ�¡���������ĿΪCPU��number��name��core number ��threads number�����ڴ棨size��speed��manufacturer��partnumber��serial number����disk(interface��size��caption��firmwarerevision��model��serial number)��network(name��macaddress��speed��guid��manufacturer��service name)
2. ʹ�÷���Ϊ������Ŀ¼���Ҽ�start-reboot-windows.ps1ѡ��run with powershell��������ʾ���룺
��1���������Ƿ���Ҫ�����Զ���¼�������Ҫ������y����Y��Ȼ��ֱ������û��������룻����Ѿ��ֶ����ù��Զ���¼�ˣ�control userpasswords2��,�Ͳ���Ҫ�����������ˣ��������y/Y֮������ⰴ����
��2��Ȼ���ֱ����base��Ϣ��������Ա�鿴��Ȼ������Ƿ�������ԡ��������Ծ�����y����Y���������ͳ���n����N��
��3���ֱ����ʾ������������reboot����dc&ac)����ϵͳ���������ӳ�ʱ�䣨��λ�룩����������
3. ���ɵ���־�ᱣ����c:\rebootlog�ļ����£��Կ�ʼ���Ե�ʱ���������ļ����У���2017��9��20�� 8��10��11�룬���ļ���Ϊ20170920_081011����������������е�base��Ϣ����base_��ͷ�ģ���������е���־������reboot.log�У�����������ܵ�base��Ϣ��ÿһ�������Ļ��ܵ�Ӳ����Ϣ��ÿһ������֮��ļ��Ľ����PASS����FAIL����
4. �����Ҫֹͣ���ԣ��ڽ�ȥϵͳ������һ��cmd���ڣ���ctrl+c������ǰ���ԣ�Ȼ�������ֲ�����
��1���Ҽ�stop-reboot-windows.ps1ѡ��run with powershell���������ԡ�
��2���ֶ����뵽 C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup ���������reboot.cmdɾ������
5. ֻ����administrator�˺������в��ԡ�
