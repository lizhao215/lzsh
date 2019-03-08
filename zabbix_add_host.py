from pyzabbix import ZabbixAPI
zapi = ZabbixAPI("http://172.16.16.22/zabbix/")
zapi.session.verify = False
zapi.timeout = 15
zapi.login("Admin", "zabbix")
print "Connected to Zabbix API Version %s" % zapi.api_version()

##提前导入 template
# 查询 templates
templates=zapi.template.get(filter={"host": ["Template OS Linux","Template OS Windows" ]})
templateids = [{"templateid": i['templateid']}  for i in templates if "templateid" in i]

# 创建host
#查询 hostgroups
hostgroup = zapi.hostgroup.get()
hostgroupids = [{"groupid": i['groupid']} for i in hostgroup if 'groupid' in i and 'name' in i and i["name"] in ("Linux servers",'newTemplate')]

# 读取 /etc/hosts
f = open('/etc/hosts', 'r')
text=f.read()
f.close()
for line in text.split("\n"):
    if line and not line.startswith("127.0.0.1") and not line.startswith("::"):
        print line
        hostip=line.strip().split(" ")[0]
        hostname=line.strip().split(" ")[1]
        interfaces={
            "type": 1,
            "main": 1,
            "useip": 1,
            "ip": hostip,
            "dns": "",
            "port": "10050"
        }
        zapi.host.create(host=hostname,interfaces=interfaces,groups=hostgroupids,templates=templateids)
