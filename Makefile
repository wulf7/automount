# Created by: Slawomir Wojciech Wojtczak <vermaden@interia.pl>
# $FreeBSD: head/sysutils/automount/Makefile 393425 2015-08-02 14:24:20Z junovitch $

PORTNAME=	automount
PORTVERSION=	1.5.7
CATEGORIES=	sysutils
MASTER_SITES=	https://raw.github.com/vermaden/automount/master/ \
		LOCAL/madpilot/${PORTNAME}/

MAINTAINER=	vermaden@interia.pl
COMMENT=	FreeBSD's devd(8) based automount solution

LICENSE=	BSD2CLAUSE

PLIST_FILES=	sbin/automount etc/devd/automount_devd.conf etc/automount.conf.sample

SUB_FILES=	pkg-install
NO_BUILD=	yes
NO_ARCH=	yes

OPTIONS_DEFINE=		NTFS3G EXT4 EXFAT MTP
OPTIONS_DEFAULT=	NTFS3G EXT4
NTFS3G_DESC=		Enable NTFS write support with ntfs-3g over FUSE
NTFS3G_RUN_DEPENDS=	fusefs-ntfs>=0:${PORTSDIR}/sysutils/fusefs-ntfs
EXT4_DESC=		Support EXT4 filesystem
EXT4_RUN_DEPENDS=	fusefs-ext4fuse>=0:${PORTSDIR}/sysutils/fusefs-ext4fuse
EXFAT_DESC=		Support Microsoft exFAT filesystem
EXFAT_RUN_DEPENDS=	fusefs-exfat>=0:${PORTSDIR}/sysutils/fusefs-exfat
MTP_RUN_DEPENDS=	fusefs-simple-mtpfs>=0.2.24:${PORTSDIR}/sysutils/fusefs-simple-mtpfs

.include <bsd.port.pre.mk>

.if ${PORT_OPTIONS:MMTP}
PLIST_FILES+=	etc/devd/automount_devd_mtp.conf
.endif

do-install:
	${INSTALL_SCRIPT} ${WRKSRC}/automount             ${STAGEDIR}${PREFIX}/sbin
	${INSTALL_DATA}   ${WRKSRC}/automount_devd.conf   ${STAGEDIR}${PREFIX}/etc/devd/automount_devd.conf
	${INSTALL_DATA}   ${WRKSRC}/automount.conf.sample ${STAGEDIR}${PREFIX}/etc/automount.conf.sample
.if ${PORT_OPTIONS:MMTP}
	${INSTALL_DATA} ${WRKSRC}/automount_devd_mtp.conf ${STAGEDIR}${PREFIX}/etc/devd/automount_devd_mtp.conf
.endif

.include <bsd.port.post.mk>
