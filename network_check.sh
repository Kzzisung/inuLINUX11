#!/bin/bash

echo "========================================"
echo " 🔍 네트워크 상태 진단 도구 (macOS)"
echo "========================================"
echo

### 1) 현재 LISTEN 중인 포트 출력 ###
echo "[1] 현재 LISTEN 중인 포트 목록"
echo "----------------------------------------"

# lsof 를 사용해 LISTEN 포트 확인
sudo lsof -iTCP -sTCP:LISTEN -n -P

echo
echo "----------------------------------------"
echo

### 2) ESTABLISHED (현재 연결된 외부 IP) 출력 ###
echo "[2] 현재 ESTABLISHED 연결 상태 (외부 접속 감시)"
echo "----------------------------------------"

# netstat은 macOS에서 p 옵션이 없으므로, 대신 ESTABLISHED만 필터링
netstat -an | grep ESTABLISHED | awk '{print $5}'

echo
echo "----------------------------------------"
echo " 진단 완료!"
echo "========================================"
