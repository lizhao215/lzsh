# 获取英伟达显卡内存信息
nvidia-smi -q | grep -A 3  "FB Memory Usage" | grep Total | awk '{print $3}'
