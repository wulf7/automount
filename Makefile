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

OPTIONS_DEFINE=		NTFS3G EXT4 EXFAT MTP
OPTIONS_DEFAULT=	NTFS3G EXT4
NTFS3G_DESC=		Enable NTFS write support with ntfs-3g over FUSE
NTFS3G_RUN_DEPENDS=	fusefs-ntfs>=0:${PORTSDIR}/sysutils/fusefs-ntfs
EXT4_DESC=		Support EXT4 filesystem
EXT4_RUN_DEPENDS=	fusefs-ext4fuse>=0:${PORTSDIR}/sysutils/fusefs-ext4fuse
EXFAT_DESC=		Support Microsoft exFAT filesystem
EXFAT_RUN_DEPENDS=	fusefs-exfat>=0:${PORTSDIR}/sysutils/fusefs-exfat
MTP_LIB_DEPENDS=	libmtp.so:${PORTSDIR}/multimedia/libmtp
MTP_RUN_DEPENDS=	simple-mtpfs:${PORTSDIR}/sysutils/fusefs-simple-mtpfs
MTP_CFLAGS=		-I${LOCALBASE}/include
MTP_LDFLAGS=		-L${LOCALBASE}/lib -Wl,-rpath=${LOCALBASE}/lib -lmtp

.include <bsd.port.pre.mk>

.if ${PORT_OPTIONS:MMTP}
PLIST_FILES+=	bin/simple-mtpfs-probe
.else
NO_BUILD=	yes
NO_ARCH=	yes
.endif

do-build:
.if ${PORT_OPTIONS:MMTP}
	cd ${WRKSRC} && ${CC} ${CFLAGS} ${LDFLAGS} -o simple-mtpfs-probe \
		simple-mtpfs-probe.c
.endif

do-install:
	${INSTALL_SCRIPT} ${WRKSRC}/automount             ${STAGEDIR}${PREFIX}/sbin
	${INSTALL_DATA}   ${WRKSRC}/automount_devd.conf   ${STAGEDIR}${PREFIX}/etc/devd/automount_devd.conf
	${INSTALL_DATA}   ${WRKSRC}/automount.conf.sample ${STAGEDIR}${PREFIX}/etc/automount.conf.sample
.if ${PORT_OPTIONS:MMTP}
	${INSTALL_PROGRAM} ${WRKSRC}/simple-mtpfs-probe   ${STAGEDIR}${PREFIX}/bin
.endif

.include <bsd.port.post.mk>
