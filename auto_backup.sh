#!/bin/bash

# ================================
#  프로젝트 자동 백업 스크립트
#  - tar 로 압축
#  - 파일명에 날짜/시간 포함
#  - backup/ 폴더에 저장
# ================================

# 백업할 대상 디렉토리 (기본값: 현재 디렉토리)
SOURCE_DIR="${1:-.}"

# 백업 결과를 저장할 디렉토리
BACKUP_DIR="./backup"

# backup 디렉토리가 없으면 생성
mkdir -p "$BACKUP_DIR"

# 날짜/시간 (예: 20251201_113045)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# 백업 파일 이름
ARCHIVE_NAME="project_backup_${TIMESTAMP}.tar.gz"

echo "========================================"
echo " 🗂  프로젝트 자동 백업 실행"
echo " 백업 대상: $SOURCE_DIR"
echo " 백업 폴더: $BACKUP_DIR"
echo " 생성 파일: $ARCHIVE_NAME"
echo "========================================"
echo

# backup 폴더 자체는 백업 대상에서 제외 (--exclude)
tar -czf "${BACKUP_DIR}/${ARCHIVE_NAME}" \
    --exclude="./backup" \
    "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "✅ 백업 완료!"
    echo " -> ${BACKUP_DIR}/${ARCHIVE_NAME}"
else
    echo "❌ 백업 중 오류가 발생했습니다."
fi
