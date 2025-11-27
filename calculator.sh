#!/usr/bin/env bash
# 간단한 터미널 계산기 프로그램
# GitHub에 올리기 좋은 예제

# ----- 함수 정의 -----

show_menu() {
    echo "==========================="
    echo "      터미널 계산기"
    echo "==========================="
    echo "1) 더하기 (+)"
    echo "2) 빼기 (-)"
    echo "3) 곱하기 (*)"
    echo "4) 나누기 (/)"
    echo "5) 종료"
    echo "---------------------------"
}

read_number() {
    local prompt="$1"
    local var
    while true; do
        read -p "$prompt" var
        # 숫자인지 체크 (정수/실수 모두 허용)
        if [[ "$var" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
            echo "$var"
            return
        else
            echo "❗ 숫자를 입력해주세요."
        fi
    done
}

calculate() {
    local a="$1"
    local b="$2"
    local op="$3"

    # 0으로 나누기 방지
    if [[ "$op" == "/" && "$b" == "0" ]]; then
        echo "❗ 0으로는 나눌 수 없습니다."
        return 1
    fi

    # bc를 사용해서 실수 계산
    local result
    result=$(echo "$a $op $b" | bc -l)

    # 소수점 너무 길면 보기 좋게 자르기
    # 예: 1.000000 → 1 로 보이게
    if [[ "$result" == *.* ]]; then
        # 소수점 아래 필요없는 0 제거
        result=$(printf "%g" "$result")
    fi

    echo "결과: $result"
    return 0
}

# ----- 메인 루프 -----

while true; do
    show_menu
    read -p "메뉴 번호를 선택하세요: " choice
    echo

    case "$choice" in
        1)
            echo "[더하기]"
            a=$(read_number "첫 번째 숫자: ")
            b=$(read_number "두 번째 숫자: ")
            calculate "$a" "$b" "+"
            ;;
        2)
            echo "[빼기]"
            a=$(read_number "첫 번째 숫자(앞): ")
            b=$(read_number "두 번째 숫자(뒤): ")
            calculate "$a" "$b" "-"
            ;;
        3)
            echo "[곱하기]"
            a=$(read_number "첫 번째 숫자: ")
            b=$(read_number "두 번째 숫자: ")
            calculate "$a" "$b" "*"
            ;;
        4)
            echo "[나누기]"
            a=$(read_number "나눠질 숫자(피제수): ")
            b=$(read_number "나누는 숫자(제수): ")
            calculate "$a" "$b" "/"
            ;;
        5)
            echo "프로그램을 종료합니다."
            exit 0
            ;;
        *)
            echo "❗ 1~5 사이의 번호를 선택하세요."
            ;;
    esac

    echo
done
