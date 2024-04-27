# warp-mac
优选Cloudflare Warp节点并生成用于Clash的WireGuard配置，为Mac修改并增加IPv6支持

源自https://github.com/plsy1/warp

# Usage
1. 拉取仓库代码
2. 替换WireguardConfig.py或WireguardConfig6.py中的privateKey、publicKey字段，根据需要优选的IP类型选择
3. 用自己的yaml配置文件替换warp.yaml
4. 运行[run.sh](run.sh) 
