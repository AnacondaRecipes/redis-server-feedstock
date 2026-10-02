#!/bin/bash

# due to problematic linkage of test_modules target (linker is incorrectly invoked with the LD args prefixed
# by -Wl) we'll manually specify required targets (i.e. exclude problematic test_modules) rather than all. 
make BUILD_TLS=yes redis-server redis-sentinel redis-cli redis-benchmark redis-check-rdb redis-check-aof
# install target normally requires all (including test_modules, which we didn't build), we'll skip it manually.
make PREFIX="${PREFIX}" install TEST_MODULES=

mkdir -p "${PREFIX}/etc"
mkdir -p "${PREFIX}/var/run/redis"
mkdir -p "${PREFIX}/var/db/redis"

sed -i -e "s:/var/run/redis_6379.pid:${PREFIX}/var/run/redis.pid:g" redis.conf
sed -i -e "s:dir ./:dir ${PREFIX}/var/db/redis/:g" redis.conf

cp redis.conf "${PREFIX}/etc/redis.conf"
cp sentinel.conf "${PREFIX}/etc/redis-sentinel.conf"
