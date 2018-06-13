#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Luci support for BT tracker operation (Aria2/Transmission)
LUCI_DEPENDS:=@(aria2||((PACKAGE_transmission-daemon-openssl||PACKAGE_transmission-daemon-mbedtls)&&(PACKAGE_transmission-remote-openssl||PACKAGE_transmission-remote-mbedtls)))

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

