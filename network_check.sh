#!/bin/bash

echo "========================================"
echo " 🔍 네트워크 상태 진단 도구 (통합 버전)"
echo "========================================"
echo

# ---------------------------------------------------
# OS 감지 로직 (보고서에 쓰기 좋은 포인트!)
# ---------------------------------------------------
OS_NAME=$(uname -s)
echo ">> 현재 감지된 운영체제: $OS_NAME"
echo

### 1) 현재 LISTEN 중인 포트 출력 ###
echo "[1] 현재 LISTEN 중인 포트 목록"
echo "----------------------------------------"

if [[ "$OS_NAME" == "Darwin" ]]; then
    # [macOS] 지민님 환경 (lsof 사용)
    # sudo가 필요할 수 있으므로 유지하되, 비밀번호 입력 안내 추가
    echo "(macOS 환경: 관리자 권한이 필요할 수 있습니다)"
    sudo lsof -iTCP -sTCP:LISTEN -n -P

elif [[ "$OS_NAME" == *"MINGW"* ]] || [[ "$OS_NAME" == *"MSYS"* ]]; then
    # [Windows] 작성자님 환경 (netstat 사용)
    # 윈도우는 lsof가 없으므로 netstat 사용
    netstat -ano | grep "LISTEN"

else
    # [Linux] 그 외 리눅스 환경
    netstat -tuln 2>/dev/null || ss -tuln
fi

echo
echo "----------------------------------------"
echo

### 2) ESTABLISHED (현재 연결된 외부 IP) 출력 ###
echo "[2] 현재 ESTABLISHED 연결 상태 (외부 접속 감시)"
echo "----------------------------------------"

if [[ "$OS_NAME" == "Darwin" ]]; then
    # [macOS] 
    netstat -an | grep ESTABLISHED | awk '{print $5}'

elif [[ "$OS_NAME" == *"MINGW"* ]] || [[ "$OS_NAME" == *"MSYS"* ]]; then
    # [Windows]
    # 윈도우 netstat 결과에서 ESTABLISHED 된 연결만 필터링
    netstat -ano | grep "ESTABLISHED"

else
    # [Linux]
    netstat -an | grep ESTABLISHED
fi

echo
echo "----------------------------------------"
echo " 진단 완료!"
echo "========================================"