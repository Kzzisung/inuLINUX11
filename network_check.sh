#!/bin/bash

echo "========================================"
echo " 🔍 네트워크 상태 진단 도구 (macOS)"
echo "========================================"
echo

### 1) 현재 LISTEN 중인 포트 출력 ###
echo "[1] 현재 LISTEN 중인 포트 목록"
echo "----------------------------------------"

# LISTEN 상태인 TCP 포트 + 프로세스 출력 (macOS: lsof 사용)
sudo lsof -iTCP -sTCP:LISTEN -n -P

echo
echo "----------------------------------------"
echo

### 2) ESTABLISHED (현재 연결된 외부 IP) 출력 ###
echo "[2] 현재 ESTABLISHED 연결 상태 (외부 접속 감시)"
echo "----------------------------------------"

# ESTABLISHED 상태인 TCP 연결만 필터링
# netstat -p 옵션은 macOS에 없으므로 사용 X
netstat -an | grep ESTABLISHED | awk '{print "외부 주소: "$5" | 상태: ESTABLISHED"}'

echo
echo "----------------------------------------"
echo " 진단 완료!"
echo "========================================"
