#!/bin/bash
# process_monitor.sh
# 작성자: 강지성
# 기능: 실시간 프로세스 모니터링 (빈 줄 제거 필터링 추가)

while true; do
    clear
    echo "================================================================"
    echo "       실시간 프로세스 모니터링 (실행 중인 앱 - 메모리순)      "
    echo "================================================================"
    
    # 헤더 출력
    printf "%-20s : %-10s : %-10s : %s\n" "PROGRAM NAME" "MEM(MB)" "CPU(sec)" "PID"
    echo "----------------------------------------------------------------"

    # [핵심 로직]
    # awk 안에 'if ($1 == "") next;' 를 추가하여 빈 줄을 싹 무시합니다.
    
    powershell -Command "Get-Process | Where-Object { \$_.MainWindowTitle -ne '' } | Sort-Object WS -Descending | Select-Object -First 5 ProcessName, WorkingSet, CPU, Id | Format-Table -HideTableHeaders -AutoSize" | \
    awk '{
        # [수정된 부분] 프로그램 이름($1)이 비어있으면 이 줄은 건너뜀 (유령 줄 제거)
        if ($1 == "") next;

        # 메모리 계산 (KB -> MB)
        mem_mb = $2 / 1024 / 1024;
        
        # CPU 시간 (비어있으면 0)
        cpu = $3; if (cpu == "") cpu = 0;
        
        # 출력 포맷팅 (이름 20자 제한)
        printf "%-20.20s : %8.2f MB : %8.2f s : %s\n", $1, mem_mb, cpu, $4
    }'
    
    echo "================================================================"
    echo " [안내] 현재 창이 열려있는 프로그램만 표시합니다."
    echo "----------------------------------------------------------------"
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
            # 윈도우 프로세스 강제 종료
            taskkill //PID $target_pid
            sleep 2
            ;;
        3) echo "모니터링을 종료합니다."; break ;;
        *) echo "잘못된 입력입니다."; sleep 1 ;;
    esac
done