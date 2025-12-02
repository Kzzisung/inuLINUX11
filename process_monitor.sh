#!/bin/bash
# process_monitor.sh
# 기능: 실시간 프로세스 모니터링 (Windows/macOS 호환 버전)

# OS 감지
OS_NAME=$(uname -s)

while true; do
    clear
    echo "================================================================"
    echo "       실시간 프로세스 모니터링 (실행 중인 앱 - 메모리순)      "
    echo "================================================================"
    echo " [시스템 감지] $OS_NAME 환경에서 실행 중..."
    echo "----------------------------------------------------------------"
    
    # 헤더 출력
    printf "%-20s : %-10s : %-10s : %s\n" "PROGRAM NAME" "MEM(MB)" "CPU" "PID"
    echo "----------------------------------------------------------------"

    # ==============================================================
    # [분기 처리] OS에 따라 다른 명령어로 프로세스 정보 가져오기
    # ==============================================================
    
    if [[ "$OS_NAME" == *"MINGW"* ]] || [[ "$OS_NAME" == *"MSYS"* ]]; then
        # ----------------------------------------------------------
        # 1. Windows 환경 (기존 작성하신 코드 유지)
        # ----------------------------------------------------------
        # PowerShell을 사용하여 창이 있는 프로그램만 필터링
        powershell -Command "Get-Process | Where-Object { \$_.MainWindowTitle -ne '' } | Sort-Object WS -Descending | Select-Object -First 5 ProcessName, WorkingSet, CPU, Id | Format-Table -HideTableHeaders -AutoSize" | \
        awk '{
            # 빈 줄 제거 (유령 줄 필터링)
            if ($1 == "") next;

            # 메모리 계산 (Bytes -> MB)
            mem_mb = $2 / 1024 / 1024;
            
            # CPU 시간 (비어있으면 0)
            cpu = $3; if (cpu == "") cpu = 0;
            
            # 출력 (Windows는 CPU가 초 단위 숫자)
            printf "%-20.20s : %8.2f MB : %8.2f s : %s\n", $1, mem_mb, cpu, $4
        }'

    elif [[ "$OS_NAME" == "Darwin" ]]; then
        # ----------------------------------------------------------
        # 2. macOS 환경 (지민님용)
        # ----------------------------------------------------------
        # ps 명령어로 메모리(rss) 순 정렬 (-r) 후 상위 5개 출력
        # comm:이름, rss:메모리(KB), time:시간, pid:PID
        ps -Aceo comm,rss,time,pid -r | head -n 6 | tail -n 5 | \
        awk '{
            # 메모리 계산 (KB -> MB)
            mem_mb = $2 / 1024;

            # 출력 (Mac은 CPU가 시간 문자열 00:00.00 형태이므로 문자열로 출력)
            printf "%-20.20s : %8.2f MB : %10s : %s\n", $1, mem_mb, $3, $4
        }'

    else
        # 그 외 리눅스 환경
        echo "   (지원되지 않는 OS입니다. Linux용 ps 명령어로 대체합니다.)"
        ps -eo comm,rss,time,pid --sort=-rss | head -n 6 | awk 'NR>1 {printf "%-20s : %8.2f MB : %10s : %s\n", $1, $2/1024, $3, $4}'
    fi
    
    echo "================================================================"
    if [[ "$OS_NAME" == *"MINGW"* ]]; then
        echo " [안내] 현재 창이 열려있는 프로그램만 표시합니다. (Windows)"
    else
        echo " [안내] 메모리 점유율 상위 5개 프로세스를 표시합니다. (macOS)"
    fi
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
            
            # [종료 로직 분기]
            if [[ "$OS_NAME" == *"MINGW"* ]] || [[ "$OS_NAME" == *"MSYS"* ]]; then
                # Windows 종료 명령어
                taskkill //PID $target_pid //F
            else
                # macOS/Linux 종료 명령어
                kill -9 $target_pid
            fi
            
            # 결과 확인을 위한 잠시 대기
            if [ $? -eq 0 ]; then
                echo ">> PID $target_pid 종료 성공."
            else
                echo ">> 종료 실패 (권한이 없거나 존재하지 않는 PID)."
            fi
            sleep 2
            ;;
        3) echo "모니터링을 종료합니다."; break ;;
        *) echo "잘못된 입력입니다."; sleep 1 ;;
    esac
done