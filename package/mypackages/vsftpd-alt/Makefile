#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vsftpd-alt
PKG_VERSION:=3.0.3
PKG_RELEASE:=2

PKG_SOURCE:=vsftpd-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://security.appspot.com/downloads/
PKG_HASH:=9d4d2bf6e6e2884852ba4e69e157a2cecd68c5a7635d66a3a8cf8d898c955ef7
PKG_LICENSE:=GPLv2

BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/vsftpd-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/vsftpd-alt/Default
  SUBMENU:=File Transfer
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Fast and secure FTP server
  URL:=https://security.appspot.com/vsftpd.html
  MAINTAINER:=Cezary Jackiewicz <cezary@eko.one.pl>
  DEPENDS:=+libuci
endef


define Package/vsftpd-alt
$(call Package/vsftpd-alt/Default)
  VARIANT:=notls
  TITLE+= (no TLS)
endef

define Package/vsftpd-alt-tls
$(call Package/vsftpd-alt/Default)
  VARIANT:=tls
  TITLE+= (TLS)
  DEPENDS+=+libopenssl
endef

define Package/vsftpd-alt/config
config VSFTPD_USE_UCI_SCRIPTS
	bool "Uses UCI scripts"
	depends on PACKAGE_vsftpd-alt || PACKAGE_vsftpd-alt-tls
	default n
endef

define Package/vsftpd-alt/conffiles
/etc/vsftpd.conf
endef

Package/vsftpd-alt-tls/conffiles=$(Package/vsftpd-alt/conffiles)

ifneq ($(CONFIG_USE_MUSL),)
  NLSSTRING:=-lcrypt
else
  NLSSTRING:=-lcrypt -lnsl
endif

ifeq ($(BUILD_VARIANT),notls)
 define Build/Compile
	$(SED) 's/-lcrypt -lnsl/$(NLSSTRING)/' $(PKG_BUILD_DIR)/Makefile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		vsftpd
 endef
endif

ifeq ($(BUILD_VARIANT),tls)
 define Build/Compile
	$(SED) 's/#undef VSF_BUILD_SSL/#define VSF_BUILD_SSL/' $(PKG_BUILD_DIR)/builddefs.h
	$(SED) 's/-lcrypt -lnsl/-lcrypt -lnsl -lssl -lcrypto/' $(PKG_BUILD_DIR)/Makefile
	$(SED) 's/-lcrypt -lnsl/$(NLSSTRING)/' $(PKG_BUILD_DIR)/Makefile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		vsftpd
 endef
endif

define Package/vsftpd-alt/install/default
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vsftpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
endef

ifeq ($(CONFIG_VSFTPD_USE_UCI_SCRIPTS),y)
define Package/vsftpd-alt/install
$(call Package/vsftpd-alt/install/default, $(1))
	$(INSTALL_BIN) ./files/vsftpd-uci.init $(1)/etc/init.d/vsftpd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/vsftpd.uci $(1)/etc/config/vsftpd
	$(INSTALL_BIN) ./files/vsftpd_wrapper $(1)/usr/sbin
	$(INSTALL_BIN) ./files/vsftpd_prepare $(1)/usr/sbin
endef
else
define Package/vsftpd-alt/install
$(call Package/vsftpd-alt/install/default, $(1))
	$(INSTALL_CONF) ./files/vsftpd.conf $(1)/etc/vsftpd.conf
	$(INSTALL_BIN) ./files/vsftpd.init $(1)/etc/init.d/vsftpd
endef
endif

Package/vsftpd-alt-tls/install=$(Package/vsftpd-alt/install)

$(eval $(call BuildPackage,vsftpd-alt))
$(eval $(call BuildPackage,vsftpd-alt-tls))
