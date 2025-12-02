#!/bin/bash

echo "========================================"
echo " 🔍 네트워크 상태 진단 도구"
echo "========================================"
echo

### 1) 현재 LISTEN 중인 포트 출력 ###
echo "[1] 현재 LISTEN 중인 포트 목록"
echo "----------------------------------------"

# LISTEN 상태인 포트 + 프로그램 이름 출력
sudo netstat -tulnp | grep LISTEN

echo
echo "----------------------------------------"
echo

### 2) ESTABLISHED (현재 연결된 외부 IP) 출력 ###
echo "[2] 현재 ESTABLISHED 연결 상태 (외부 접속 감시)"
echo "----------------------------------------"

# 외부와 연결된 ESTABLISHED 연결만 추출
# netstat 결과 구조: Proto | Recv-Q | Send-Q | Local Address | Foreign Address | State | PID/Program
sudo netstat -tnp | grep ESTABLISHED | awk '{print "외부 IP: "$5"  |  상태: "$6"  |  프로세스: "$7}'

echo
echo "----------------------------------------"
echo " 진단 완료!"
echo "========================================"
