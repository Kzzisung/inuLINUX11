#!/bin/bash

echo "========================================"
echo "   [3] 스마트 코드 실행기 (C / Python)   "
echo "========================================"

# 1. 파일 목록 보여주기 (.c 와 .py 모두 검색)
echo ">> 실행 가능한 소스코드 목록:"
ls *.c *.py 2>/dev/null

# 파일이 하나도 없으면 종료
if [ $? -ne 0 ]; then
    echo ">> 실행할 소스코드(.c 또는 .py)가 없습니다."
    exit 0 # 함수 안에 있다면 return으로 변경
fi

echo ""
echo -n ">> 실행할 파일명을 입력하세요 (확장자 포함): "
read filename

# 2. 파일 존재 여부 확인
if [ ! -f "$filename" ]; then
    echo ">> 오류: '$filename' 파일을 찾을 수 없습니다."
    exit 1 # 함수 안에 있다면 return으로 변경
fi

# 3. 확장자 추출 및 자동 분기 (핵심 로직!)
extension="${filename##*.}"

echo "----------------------------------------"
if [ "$extension" == "c" ]; then
    # [C언어일 때]
    echo ">> C언어 소스코드 감지됨. 컴파일 시작..."
    output_name="${filename%.*}" # .c 뗀 이름
    
    # 컴파일 실행
    gcc "$filename" -o "$output_name"
    
    if [ $? -eq 0 ]; then
        echo ">> 컴파일 성공! 실행합니다."
        echo "----------------------------------------"
        ./"$output_name"
    else
        echo ">> 컴파일 오류 발생! 코드를 확인하세요."
    fi

elif [ "$extension" == "py" ]; then
    # [Python일 때]
    echo ">> Python 스크립트 감지됨. 인터프리터 실행..."
    echo "----------------------------------------"
    
    # OS 감지해서 명령어 선택 (맥/리눅스는 python3, 윈도우는 python)
    if command -v python3 &>/dev/null; then
        python3 "$filename"
    else
        python "$filename"
    fi

else
    echo ">> 지원하지 않는 파일 형식입니다. (.c 또는 .py 만 가능)"
fi

echo "----------------------------------------"
echo ">> 실행 종료."