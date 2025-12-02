#!/bin/bash
# auto_compiler.sh
# 작성자: 강지성
# 기능: C언어, Python 파일 자동 감지 및 실행

while true; do
    echo "========================================"
    echo "   소스코드 자동 컴파일러 & 실행기     "
    echo "========================================"
    echo "현재 디렉토리의 소스코드 목록:"
    echo "----------------------------------------"
    
    # 1. .c 또는 .py 파일이 있는지 확인하고 목록 출력
    # ls *.c *.py 2>/dev/null : 에러 메시지(파일 없음)는 숨김
    files=$(ls *.c *.py 2>/dev/null)

    if [ -z "$files" ]; then
        echo "[!] 실행 가능한 소스코드(.c, .py)가 없습니다."
        echo "----------------------------------------"
    else
        # 파일 목록을 번호와 함께 출력
        i=1
        for file in $files; do
            echo "$i. $file"
            file_array[$i]=$file # 배열에 저장
            ((i++))
        done
    fi

    echo "----------------------------------------"
    echo "Q. 나가기"
    echo -n "실행할 파일 번호 또는 이름을 입력하세요: "
    read input

    # 'q' 또는 'Q' 입력 시 종료
    if [[ "$input" == "q" || "$input" == "Q" ]]; then
        echo "프로그램을 종료합니다."
        break
    fi

    # 입력값이 숫자인 경우 배열에서 파일명 가져오기
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        filename=${file_array[$input]}
    else
        filename=$input
    fi

    # 파일 존재 여부 확인
    if [ ! -f "$filename" ]; then
        echo "[Error] '$filename' 파일을 찾을 수 없습니다."
        sleep 1
        continue
    fi

    # 확장자 추출 및 실행 로직
    extension="${filename##*.}"
    
    echo "----------------------------------------"
    case $extension in
        c)
            echo "detected: C Source Code"
            echo "Compiling..."
            # gcc로 컴파일 (-o로 실행파일명 지정)
            gcc "$filename" -o "${filename%.c}"
            
            if [ $? -eq 0 ]; then
                echo "Build Success! Running..."
                echo "----------------------------------------"
                # 윈도우(Git Bash) 호환성을 위해 ./파일명 실행
                ./"${filename%.c}"
                echo ""
            else
                echo "[Error] 컴파일에 실패했습니다."
            fi
            ;;
        py)
            echo "detected: Python Script"
            echo "Running..."
            echo "----------------------------------------"
            # python 명령어로 실행 (윈도우는 python, 리눅스는 보통 python3)
            # winpty는 윈도우 Git Bash에서 파이썬 입출력 버그 방지용 (없으면 그냥 python)
            if command -v winpty &> /dev/null; then
                winpty python "$filename"
            else
                python "$filename"
            fi
            echo ""
            ;;
        *)
            echo "[Error] 지원하지 않는 파일 형식입니다."
            ;;
    esac
    
    echo "----------------------------------------"
    echo "실행 완료. (엔터를 누르면 메뉴로 돌아갑니다)"
    read
    clear
done
