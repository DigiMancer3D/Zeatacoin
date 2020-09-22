#!/usr/bin/env bash
#
# Copyright (c) 2018 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.
# copied from .travis

export LC_ALL=C.UTF-8

trails_retry docker pull "$DOCKER_NAME_TAG"

export DIR_FUZZ_IN=${TRAILS_BUILD_DIR}/qa-assets
git clone https://github.com/bitcoin-core/qa-assets ${DIR_FUZZ_IN}
export DIR_FUZZ_IN=${DIR_FUZZ_IN}/fuzz_seed_corpus/

mkdir -p "${TRAILS_BUILD_DIR}/sanitizer-output/"
export ASAN_OPTIONS=""
export LSAN_OPTIONS="suppressions=${TRAILS_BUILD_DIR}/test/sanitizer_suppressions/lsan"
export TSAN_OPTIONS="suppressions=${TRAILS_BUILD_DIR}/test/sanitizer_suppressions/tsan:log_path=${TRAILS_BUILD_DIR}/sanitizer-output/tsan"
export UBSAN_OPTIONS="suppressions=${TRAILS_BUILD_DIR}/test/sanitizer_suppressions/ubsan:print_stacktrace=1:halt_on_error=1"
env | grep -E '^(BITCOIN_CONFIG|CCACHE_|WINEDEBUG|LC_ALL|BOOST_TEST_RANDOM|CONFIG_SHELL|(ASAN|LSAN|TSAN|UBSAN)_OPTIONS)' | tee /tmp/env
if [[ $HOST = *-mingw32 ]]; then
  DOCKER_ADMIN="--cap-add SYS_ADMIN"
elif [[ $BITCOIN_CONFIG = *--with-sanitizers=*address* ]]; then # If ran with (ASan + LSan), Docker needs access to ptrace (https://github.com/google/sanitizers/issues/764)
  DOCKER_ADMIN="--cap-add SYS_PTRACE"
fi
DOCKER_ID=$(docker run $DOCKER_ADMIN -idt --mount type=bind,src=$TRAILS_BUILD_DIR,dst=$TRAILS_BUILD_DIR --mount type=bind,src=$CCACHE_DIR,dst=$CCACHE_DIR -w $TRAILS_BUILD_DIR --env-file /tmp/env $DOCKER_NAME_TAG)

DOCKER_EXEC () {
  docker exec $DOCKER_ID bash -c "cd $PWD && $*"
}

if [ -n "$DPKG_ADD_ARCH" ]; then
  DOCKER_EXEC dpkg --add-architecture "$DPKG_ADD_ARCH"
fi

trails_retry DOCKER_EXEC apt-get update
trails_retry DOCKER_EXEC apt-get install --no-install-recommends --no-upgrade -qq $PACKAGES $DOCKER_PACKAGES

if [ "$ZEATACOIN_SCRYPT" = 1 ]; then 
  trails_retry DOCKER_EXEC pip3 install zeatacoin_scrypt
fi
