1. ����������windowsϵͳ�µ�����/DC/AC���Թ��ߣ������������л���Ӳ���豸�Ƿ��baseһ�¡���������ĿΪCPU��number��name��core number ��threads number�����ڴ棨����λ������size��speed��manufacturer��partnumber��serial number����disk(����deviceid����interface��size��caption��firmwarerevision��model��serial number)��network(����deviceid����name��macaddress��speed��guid��manufacturer��service name)
2. ʹ�÷���Ϊ�Թ���ԱȨ�޿���powershell��Ȼ����뵽start-reboot-windows.ps1����Ŀ¼��ִ�д��ļ���������ʾ���룺
��1���������Ƿ���Ҫ�����Զ���¼�������Ҫ������y����Y��Ȼ��ֱ������û��������룻����Ѿ��ֶ����ù��Զ���¼�ˣ�control userpasswords2��,�Ͳ���Ҫ�����������ˣ��������y/Y֮������ⰴ����
��2��Ȼ���ֱ����base��Ϣ��������Ա�鿴��Ȼ������Ƿ�������ԡ��������Ծ�����y����Y��������������n����N��
��3���ֱ����ʾ������������reboot����dc&ac)����ϵͳ���������ӳ�ʱ�䣨��λ�룩����������.
3. ���ɵ���־�ᱣ����c:\rebootlog�ļ����£��Կ�ʼ���Ե�ʱ���������ļ����У���2017��9��20�� 8��10��11�뿪ʼ���ԣ����ļ���Ϊ20170920_081011����������������е�base��Ϣ����base_��ͷ�ģ���������е���־������reboot.log�У�����������ܵ�base��Ϣ��ÿһ�������Ļ��ܵ�Ӳ����Ϣ��ÿһ������֮��ļ��Ľ����PASS����FAIL�������������֮��ֻҪ���reboot.log�ļ�����FAIL�ַ����ɡ�
4. �����Ҫ��;ֹͣ���ԣ��ڽ�ȥϵͳ������һ��cmd���ں�һ��powershell���ڣ���ctrl+c�������������ڣ�Ȼ�������ֲ�����
��1���Ҽ�stop-reboot-windows.ps1ѡ��run with powershell���������ԡ�
��2���ֶ����뵽 C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup ���������reboot.cmdɾ������
5. ֻ����administrator�˺������в��ԡ�
6. Ŀǰ��֪���⣺ͨ��PXE��auto-windows��װ��ϵͳ���������¼���ܵ�һ�����ò��ɹ�����Ҫ����֮���ٴ��ֶ�����һ���������¼��control userpasswords2)������Ե�ʱ���ȹ۲켸�Σ����ǰ���ζ��ܹ��������¼�Ǿ�û������
