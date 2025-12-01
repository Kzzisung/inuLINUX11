#!/bin/bash
# process_monitor.sh
# 작성자: 강지성
# 기능: 실시간 프로세스 모니터링 (ps aux 호환성 버전)

while true; do
    clear
    echo "========================================"
    echo "   실시간 프로세스 모니터링 (CPU순)    "
    echo "========================================"
    
    # 헤더 직접 출력 (모양 예쁘게 잡기)
    printf "%-8s %-10s %-6s %-6s %s\n" "PID" "USER" "%CPU" "%MEM" "COMMAND"
    echo "----------------------------------------"

    # ps aux 명령어 사용 (호환성 개선)
    # 1. ps aux: 모든 프로세스 정보 출력
    # 2. tail -n +2: 첫 줄(헤더) 제거
    # 3. sort -k 3 -nr: 3번째 열(%CPU) 기준으로 숫자 내림차순 정렬
    # 4. head -n 5: 상위 5개만 자름
    # 5. awk: PID($2), USER($1), CPU($3), MEM($4), CMD($11) 순서로 출력
    ps aux | tail -n +2 | sort -k 3 -nr | head -n 5 | awk '{printf "%-8s %-10s %-6s %-6s %s\n", $2, $1, $3, $4, $11}'
    
    echo "========================================"
    echo "1. 새로고침"
    echo "2. 프로세스 종료 (PID 입력)"
    echo "3. 종료"
    echo -n "선택 > "
    read choice

    case $choice in
        1) continue ;;
        2) 
            echo -n "종료할 PID 입력: "
            read target_pid
            # PID가 숫자인지 확인
            if [[ "$target_pid" =~ ^[0-9]+$ ]]; then
                kill -9 $target_pid
                echo "PID $target_pid 종료 시도 완료."
                sleep 2
            else
                echo "잘못된 PID입니다."
                sleep 1
            fi
            ;;
        3) echo "모니터링을 종료합니다."; break ;;
        *) echo "잘못된 입력입니다."; sleep 1 ;;
    esac
done