#!/bin/bash

set -e

TEMPLATE="templates/engineering-note.md"

if [ ! -f "$TEMPLATE" ]; then
    echo "❌ 템플릿을 찾을 수 없습니다: $TEMPLATE"
    exit 1
fi

echo "=== TURTLESS Engineering Note Generator ==="
echo

read -p "날짜 (YYYY-MM-DD): " DATE
read -p "제목: " TITLE

if [ -z "$DATE" ] || [ -z "$TITLE" ]; then
    echo "❌ 날짜와 제목은 반드시 입력해야 합니다."
    exit 1
fi

if ! [[ "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "❌ 날짜 형식이 올바르지 않습니다."
    echo "예: 2026-10-08"
    exit 1
fi

FILENAME=$(echo "$TITLE" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/ /-/g' \
    | sed 's#[^a-zA-Z0-9가-힣_-]##g')

YEAR="${DATE:0:4}"
DIR="$YEAR"
FILE="$DIR/${DATE}-${FILENAME}.md"

mkdir -p "$DIR"

if [ -f "$FILE" ]; then
    echo "❌ 이미 존재하는 파일입니다:"
    echo "$FILE"
    exit 1
fi

cp "$TEMPLATE" "$FILE"

sed -i "s/YYYY-MM-DD/$DATE/" "$FILE"
sed -i "s/^# Engineering Note/# $TITLE/" "$FILE"

echo
echo "✅ Engineering Note가 생성되었습니다!"
echo "📄 $FILE"
