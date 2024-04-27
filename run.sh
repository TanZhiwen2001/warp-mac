#!/bin/bash
export LANG=en_US.UTF-8

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

# 选择客户端 CPU 架构
archAffix(){
    case "$(uname -m)" in
        x86_64 | amd64 ) echo 'amd64' ;;
        armv8 | arm64 | aarch64 ) echo 'arm64' ;;
        * ) red "不支持的CPU架构!" && exit 1 ;;
    esac
}

endpointyx(){    
    # 删除之前的优选结果文件，以避免出错
    rm -f result.csv

    # 下载优选工具软件，感谢 GitHub 项目：https://github.com/peanut996/CloudflareWarpSpeedTest
    #wget https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-darwin-$(archAffix) -O warp
    #wget在新版macOS中已不再提供，替换为curl
    curl https://gitlab.com/Misaka-blog/warp-script/-/raw/main/files/warp-yxip/warp-darwin-$(archAffix) -o warp

    # 取消 Linux 自带的线程限制，以便生成优选 Endpoint IP
    ulimit -n 102400
    
    # 启动 WARP Endpoint IP 优选工具
    chmod +x warp
    if [[ $1 == 6 ]]; then
        ./warp -ipv6
	python3 WireguardConfig6.py
    else
        ./warp
        python3 WireguardConfig.py
    fi
    
    # 删除 WARP Endpoint IP 优选工具及其附属文件
    rm -f warp
}

menu(){
    clear
    echo -e " ${GREEN}1.${PLAIN} WARP IPv4 Endpoint IP 优选 ${YELLOW}(默认)${PLAIN}"
    echo -e " ${GREEN}2.${PLAIN} WARP IPv6 Endpoint IP 优选"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} 退出脚本"
    echo ""
    read -rp "请输入选项 [0-2]: " menuInput
    case $menuInput in
        2 ) endpointyx 6 ;;
        0 ) exit 1 ;;
        * ) endpointyx ;;
    esac
}

menu
