# 获取英伟达显卡内存信息
nvidia-smi -q | grep -A 3  "FB Memory Usage" | grep Total | awk '{print $3}'

#redis 安装启动
sed -i 's/# requirepass foobared/requirepass 123456/' /etc/redis.conf
sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/' /etc/redis.conf


sed -i "s/SELINUX=enforcing/SELINUX=disabled/"  /etc/selinux/config
