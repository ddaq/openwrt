# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for VSFTPD
LUCI_DEPENDS:=@((PACKAGE_vsftpd-alt||PACKAGE_vsftpd-alt-tls)&&VSFTPD_USE_UCI_SCRIPTS)
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
