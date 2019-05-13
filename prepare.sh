#!/usr/bin/env sh

VERSION="3.2.5"
PACKAGE="shadowsocks-libev"

# get absolute path to this script
ROOT=$(cd `dirname $0` && pwd)

echo "start prepare at ${ROOT}"

# Target path, where the files should live
TARGET="$ROOT/ShadowSocks-libev-iOS/shadowsocks-libev"

if [ ! -e $TARGET ]; then
    # Target name of the downloaded TAR file
    TARNAME="$ROOT/shadowsocks-libev.tar.gz"

    if [ ! -e $TARNAME ]; then
    curl -L -o $TARNAME https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$VERSION/shadowsocks-libev-$VERSION.tar.gz
    fi
    tar xf $TARNAME -C $ROOT
    rm $TARNAME
    mv $ROOT/shadowsocks-libev-$VERSION $TARGET

    #config.h 
    cd $TARGET
    echo "start config.h"
    libpath="\.libs\/"
    touch ./config.h
    cat ./config.h.in | sed -e "s/#undef CONNECT_IN_PROGRESS/#define CONNECT_IN_PROGRESS EINPROGRESS/"\
    -e "s/^#undef HAVE_ARPA_INET_H/#define HAVE_ARPA_INET_H 1/"\
    -e "s/^#undef HAVE_DECL_INET_NTOP/#define HAVE_DECL_INET_NTOP 1/"\
    -e "s/^#undef HAVE_DLFCN_H/#define HAVE_DLFCN_H 1/"\
    -e "s/^#undef HAVE_FCNTL_H/#define HAVE_FCNTL_H 1/"\
    -e "s/^#undef HAVE_FORK/#define HAVE_FORK 1/"\
    -e "s/^#undef HAVE_GETPWNAM_R/#define HAVE_GETPWNAM_R 1/"\
    -e "s/^#undef HAVE_EV_H/#define HAVE_EV_H 1/"\
    -e "s/^#undef HAVE_INTTYPES_H/#define HAVE_INTTYPES_H 1/"\
    -e "s/^#undef HAVE_LANGINFO_H/#define HAVE_LANGINFO_H 1/"\
    -e "s/^#undef HAVE_LIMITS_H/#define HAVE_LIMITS_H 1/"\
    -e "s/^#undef HAVE_LOCALE_H/#define HAVE_LOCALE_H 1/"\
    -e "s/^#undef HAVE_MALLOC/#define HAVE_MALLOC 1/"\
    -e "s/^#undef HAVE_MEMORY_H/#define HAVE_MEMORY_H 1/"\
    -e "s/^#undef HAVE_MEMSET/#define HAVE_MEMSET 1/"\
    -e "s/^#undef HAVE_NETDB_H/#define HAVE_NETDB_H 1/"\
    -e "s/^#undef HAVE_NETINET_IN_H/#define HAVE_NETINET_IN_H 1/"\
    -e "s/^#undef HAVE_NET_IF_H/#define HAVE_NET_IF_H 1/"\
    -e "s/^#undef HAVE_PCRE_H/#define HAVE_PCRE_H 1/"\
    -e "s/^#undef HAVE_PTHREAD_PRIO_INHERIT/#define HAVE_PTHREAD_PRIO_INHERIT 1/"\
    -e "s/^#undef HAVE_SELECT/#define HAVE_SELECT 1/"\
    -e "s/^#undef HAVE_SETRESUID/#define HAVE_SETRESUID 1/"\
    -e "s/^#undef HAVE_SETRLIMIT/#define HAVE_SETRLIMIT 1/"\
    -e "s/^#undef HAVE_SOCKET/#define HAVE_SOCKET 1/"\
    -e "s/^#undef HAVE_STRINGS_H/#define HAVE_STRINGS_H 1/"\
    -e "s/^#undef HAVE_SYS_IOCTL_H/#define HAVE_SYS_IOCTL_H 1/"\
    -e "s/^#undef HAVE_SYS_SELECT_H/#define HAVE_SYS_SELECT_H 1/"\
    -e "s/^#undef HAVE_SYS_SOCKET_H/#define HAVE_SYS_SOCKET_H 1/"\
    -e "s/^#undef HAVE_SYS_STAT_H/#define HAVE_SYS_STAT_H 1/"\
    -e "s/^#undef HAVE_SYS_TYPES_H/#define HAVE_SYS_TYPES_H 1/"\
    -e "s/^#undef HAVE_SYS_WAIT_H/#define HAVE_SYS_WAIT_H 1/"\
    -e "s/^#undef HAVE_UNISTD_H/#define HAVE_UNISTD_H 1/"\
    -e "s/^#undef HAVE_VFORK_H/#define HAVE_VFORK_H 1/"\
    -e "s/^#undef HAVE_WORKING_FORK/#define HAVE_WORKING_FORK 1/"\
    -e "s/^#undef HAVE_WORKING_VFORK/#define HAVE_WORKING_VFORK 1/"\
    -e "s/^#undef PACKAGE_NAME/#define PACKAGE_NAME \"$PACKAGE\"/"\
    -e "s/^#undef PACKAGE_VERSION/#define PACKAGE_VERSION \"$VERSION\"/"\
    -e "s/^#undef PACKAGE_BUGREPORT/#define PACKAGE_BUGREPORT \"$PACKAGE\"/"\
    -e "s/^#undef PACKAGE_STRING/#define PACKAGE_STRING \"$PACKAGE\"/"\
    -e "s/^#undef PACKAGE_TARNAME/#define PACKAGE_TARNAME \"$PACKAGE\"/"\
    -e "s/^#undef PACKAGE_URL/#define PACKAGE_URL \"$PACKAGE\"/"\
    -e "s/^#undef PACKAGE/#define PACKAGE \"$PACKAGE\"/"\
    -e "s/^#undef VERSION/#define VERSION \"$VERSION\"/"\
    -e "s/^#undef LT_OBJDIR/#define LT_OBJDIR \"$libpath\"/"\
    -e "s/^#undef RETSIGTYPE/#define RETSIGTYPE void/"\
    -e "s/^#undef SELECT_TYPE_ARG1/#define SELECT_TYPE_ARG1 int/"\
    -e "s/^#undef SELECT_TYPE_ARG234/#define SELECT_TYPE_ARG234 (fd_set *)/"\
    -e "s/^#undef SELECT_TYPE_ARG5/#define SELECT_TYPE_ARG5 (struct timeval *)/"\
    -e "s/^#undef TIME_WITH_SYS_TIME/#define TIME_WITH_SYS_TIME q/"\
    -e "s/^#undef TLs/^#define TLS __thread/"\
    -e "s/^#undef _ALL_SOURCE/#define _ALL_SOURCE 1/"\
    -e "s/^#undef _GNU_SOURCE/#define _GNU_SOURCE 1/"\
    -e "s/^#undef _POSIX_PTHREAD_SEMANTICs/^#define  _POSIX_PTHREAD_SEMANTICS 1/"\
    -e "s/^#undef _TANDEM_SOURCE/#define _TANDEM_SOURCE 1/"\
    -e "s/^#undef __EXTENSIONS__/#define __EXTENSIONS__ 1/"\
    -e "s/^#undef restrict/#define restrict __restrict/"\
    -e "$a #define TCP_NODELAY 0x01" > ./config.h

    echo "start http.h"
    cat ./http.h | sed -e "s/const protocol_t *const http_protocol;/extern const protocol_t *const http_protocol;/" > ./http.h
    echo "start tls.h"
    cat ./tls.h | sed -e "s/const protocol_t *const tls_protocol;/extern const protocol_t *const tls_protocol;/" > ./tls.h


    echo "success "
    cd $TARGET
    cat "./libcork/src/libcork/posix/env.c" | \
    sed -e "/#include <crt_externs.h>/{i\ 
    #include <TargetConditionals.h>
    ; i\ 
    #if TARGET_OS_IPHONE
    ; i\ 
    #define NO_ENVIRON 1
    ; i\ 
    #else
    }" -e "/#define environ/a \ 
    #endif
    " -e "/cork_env_clone_current(void)/,/return env;/{ /cork_env_clone_current(void)/{N;a\ 
    #ifdef NO_ENVIRON
    ; a\ 
    return NULL;
    ; a\ 
    #else
    };/return env;/a\ 
    #endif
    }" -e "/clearenv(void)/,/}/{/*environ = NULL;/a\ 
    #endif
    ; /*environ = NULL;/i\ 
    #ifndef NO_ENVIRON
    ;
    }" | tee ./libcork/src/libcork/posix/env.c > /dev/null
fi



CARESROOT="$ROOT/ShadowSocks-libev-iOS/c-ares"
LIBCARES="$CARESROOT/lib/libcares.a"

if [ ! -e $LIBCARES ]; then
    cd $CARESROOT
    sh build-cares.sh
fi

MBEDTLSROOT="$ROOT/ShadowSocks-libev-iOS/mbedtls-for-ios"
LIBMBEDTLS="$MBEDTLSROOT/lib/libmbedtls.a"

if [ ! -e $LIBMBEDTLS ]; then
    cd $MBEDTLSROOT
    sh build_ios.sh
fi

SODIUMROOT="$ROOT/ShadowSocks-libev-iOS/sodium-ios"
LIBSODIUM="$SODIUMROOT/lib/libsodium.a"

if [ ! -e $LIBSODIUM ]; then
    cd $SODIUMROOT
    sh build-sodium.sh
fi

EVROOT="$ROOT/ShadowSocks-libev-iOS/libev-ios"
LIBEV="$EVROOT/lib/libev.a"

if [ ! -e $LIBEV ]; then
    cd $EVROOT
    sh build-libev-ios.sh
fi
