#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Clone Lean's latest sources.
pushd package
git clone --depth=1 https://github.com/coolsnowwolf/lede
popd

# Copy Lean's packages to ./package/lean.
mkdir package/lean
pushd package/lede/package/lean
cp -r {adbyby,automount,baidupcs-web,coremark,ddns-scripts_aliyun,ddns-scripts_dnspod,dns2socks,ipt2socks,ipv6-helper,kcptun,luci-app-adbyby-plus,luci-app-arpbind,luci-app-autoreboot,luci-app-baidupcs-web,luci-app-cifs-mount,luci-app-cpufreq,luci-app-familycloud,luci-app-filetransfer,luci-app-frpc,luci-app-n2n_v2,luci-app-netdata,luci-app-nfs,luci-app-nft-qos,luci-app-nps,luci-app-ps3netsrv,luci-app-softethervpn,luci-app-usb-printer,luci-app-unblockmusic,luci-app-verysync,luci-app-vsftpd,luci-app-webadmin,luci-app-xlnetacc,luci-lib-fs,microsocks,n2n_v2,npc,pdnsd-alt,proxychains-ng,ps3netsrv,redsocks2,shadowsocksr-libev,simple-obfs,softethervpn5,srelay,tcpping,trojan,UnblockNeteaseMusic,UnblockNeteaseMusicGo,uugamebooster,v2ray,v2ray-plugin,verysync,vsftpd-alt,xray} "../../../lean"
popd

pushd package/lean
# Add Project OpenWrt's autocore
rm -rf autocore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld
rm -rf helloworld/luci-app-ssr-plus/po/zh_Hans

popd

# Clean Lean's code
pushd package
rm -rf lede
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add luci-app-onliner. (need luci-app-nlbwmon)
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-adguardhome
svn co https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw/luci-app-adguardhome
svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/AdGuardHome

# Add smartdns
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt ../smartdns
svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/luci-app-smartdns ../luci-app-smartdns

# Add luci-udptools
git clone --depth=1 https://github.com/zcy85611/openwrt-luci-kcp-udp

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-trojan-go
git clone --depth=1 https://github.com/frainzy1477/luci-app-trojan

popd

# Max connections
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# Change dnsmasq to dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# Add po2lmo
git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd
