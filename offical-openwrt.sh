#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Add project-openwrt Lean's packages to ./package/lean.
pushd package/
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean
#svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lienol
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lienol/redsocks2
rm -fr package/lean/luci-app-docker
rm -fr package/lean/luci-app-ssr-plus
popd

pushd package/lean
# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld
rm -rf helloworld/luci-app-ssr-plus/po/zh_Hans
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add OpenClash.
git clone -b master --depth=1 https://github.com/vernesong/OpenClash

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

# Add luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config

# Add tmate
git clone --depth=1 https://github.com/project-openwrt/openwrt-tmate

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
popd

# Max connections
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# Remove orig kcptun
rm -rf ./feeds/packages/net/kcptun

# Change dnsmasq to dnsmasq-full
sed -i 's/dnsmasq/dnsmasq-full/g' include/target.mk

# Change golang version
sed -i 's/^GO_VERSION_MAJOR_MINOR.*/GO_VERSION_MAJOR_MINOR:=1.15/g' feeds/packages/lang/golang/golang-version.mk
sed -i 's/^GO_VERSION_PATCH.*/GO_VERSION_PATCH:=6/g' feeds/packages/lang/golang/golang-version.mk
sed -i 's/^PKG_HASH.*/PKG_HASH:=890bba73c5e2b19ffb1180e385ea225059eb008eb91b694875dd86ea48675817/g' feeds/packages/lang/golang/golang/Makefile

# Add po2lmo
git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Convert Translation
cp ../convert-translation.sh .
chmod +x ./convert-translation.sh
./convert-translation.sh || true
