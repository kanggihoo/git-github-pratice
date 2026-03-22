#!/bin/bash
# ══════════════════════════════════════════════════════════════
# 초기 환경 구성 스크립트
# Phase 1 - Scenario 1.3: 잃어버린 커밋/브랜치 예토전생 (Reflog)
# ══════════════════════════════════════════════════════════════
# 이 스크립트를 실행하면 다음과 같은 환경이 만들어집니다:
#
# [사고 1: reset --hard로 커밋 유실]
#   main 브랜치에 원래 5개 커밋이 있었지만,
#   git reset --hard HEAD~2로 최근 2개가 사라진 상태
#   → git log에는 3개만 보임
#
# [사고 2: 브랜치 강제 삭제]
#   feature/payment 브랜치(2개 고유 커밋)가
#   merge 되지 않은 상태에서 git branch -D로 삭제됨
#
# 학습자 미션: reflog를 사용하여 모든 것을 복구!
# ══════════════════════════════════════════════════════════════

# set -e

# # ─── [사전 체크] ──────────────────────────────────────
# if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
#     echo "❌ 오류: 이미 Git 저장소 안에 있습니다!"
#     echo "   빈 폴더에서 실행해주세요."
#     echo "   예: mkdir workspace && cd workspace && bash ../setup-script.sh"
#     exit 1
# fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Scenario 1.3 실습 환경을 구성합니다..."
echo "(사고 상황을 재현합니다. 잠시 기다려주세요...)"
echo ""

# ─── [Git 저장소 초기화] ──────────────────────────────
# git init --quiet
# git branch -M main

# ─── [Commit 1: 프로젝트 초기 설정] ──────────────────
cp "$SCRIPT_DIR/project-files/index.html" .
cp "$SCRIPT_DIR/project-files/app.js" .
cp "$SCRIPT_DIR/project-files/style.css" .
git add .
git commit -m "init: 프로젝트 초기 설정" --quiet

# ─── [Commit 2: 노트 목록 스타일링] ──────────────────
cat >> style.css << 'CSS'

.note-card h3 {
    color: #e94560;
    margin-bottom: 0.5rem;
}

.note-card p {
    color: #b0b0b0;
    line-height: 1.6;
}
CSS
git add style.css
git commit -m "feat: 노트 카드 스타일 개선" --quiet

# ─── [Commit 3: 노트 검색 기능] ──────────────────────
cat >> app.js << 'JS'

function searchNotes(keyword) {
    return notes.filter(n =>
        n.title.includes(keyword) || n.content.includes(keyword)
    );
}
JS
git add app.js
git commit -m "feat: 노트 검색 기능 추가" --quiet

# ─── [Commit 4: 노트 삭제 기능 (이 커밋이 사라질 예정)] ──
cat >> app.js << 'JS'

function deleteNote(id) {
    const index = notes.findIndex(n => n.id === id);
    if (index > -1) {
        notes.splice(index, 1);
        renderNotes();
    }
}
JS
git add app.js
git commit -m "feat: 노트 삭제 기능 추가" --quiet

# ─── [Commit 5: 노트 편집 기능 (이 커밋도 사라질 예정)] ──
cat >> app.js << 'JS'

function editNote(id, newTitle, newContent) {
    const note = notes.find(n => n.id === id);
    if (note) {
        note.title = newTitle;
        note.content = newContent;
        renderNotes();
    }
}
JS
git add app.js
git commit -m "feat: 노트 편집 기능 추가" --quiet

# ─── [feature/payment 브랜치 생성 및 작업] ───────────
# Commit 3 시점에서 브랜치를 생성합니다
git checkout -b feature/payment HEAD~2 --quiet

cat > payment.js << 'JS'
// 결제 시스템 모듈
const PAYMENT_METHODS = ['card', 'bank', 'mobile'];

function initPayment(method) {
    if (!PAYMENT_METHODS.includes(method)) {
        throw new Error('지원하지 않는 결제 수단입니다');
    }
    return { method, status: 'initialized', createdAt: new Date() };
}

function processPayment(payment, amount) {
    return {
        ...payment,
        amount,
        status: 'completed',
        transactionId: 'TXN-' + Date.now()
    };
}

module.exports = { initPayment, processPayment };
JS
git add payment.js
git commit -m "feat: 결제 시스템 초기 구현" --quiet

cat > payment-ui.html << 'HTML'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DevNote - 결제</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header><h1>DevNote Pro</h1></header>
    <main>
        <h2>프로 버전 결제</h2>
        <div id="payment-form">
            <select id="payment-method">
                <option value="card">카드 결제</option>
                <option value="bank">계좌이체</option>
                <option value="mobile">모바일 결제</option>
            </select>
            <button onclick="handlePayment()">결제하기</button>
        </div>
    </main>
    <script src="payment.js"></script>
</body>
</html>
HTML
git add payment-ui.html
git commit -m "feat: 결제 페이지 UI 추가" --quiet

# ─── [main 브랜치로 돌아가기] ─────────────────────────
git checkout practice/reflog --quiet

# ═══════════════════════════════════════════════════════
# 🚨 사고 발생!
# ═══════════════════════════════════════════════════════

# ─── [사고 1: reset --hard 실수] ──────────────────────
# main에서 최근 2개 커밋을 날려버림!
git reset --hard HEAD~2 --quiet

# ─── [사고 2: 브랜치 강제 삭제] ───────────────────────
# merge하지 않은 feature/payment 브랜치를 삭제!
git branch -D feature/payment > /dev/null 2>&1

echo "✅ 환경 구성 완료! (사고 상황이 재현되었습니다)"
echo ""
echo "🚨 사고 발생 보고서:"
echo "════════════════════════════════════════"
echo ""
echo "📋 사고 1: git reset --hard 실수"
echo "   현재 main 브랜치의 커밋 히스토리:"
git log --oneline
echo ""
echo "   ⚠️  원래 5개 커밋이 있었는데, 2개가 사라졌습니다!"
echo "   (노트 삭제 기능, 노트 편집 기능 커밋이 없어짐)"
echo ""
echo "📋 사고 2: 브랜치 강제 삭제"
echo "   ⚠️  feature/payment 브랜치가 삭제되었습니다!"
echo "   (결제 시스템 코드 2개 커밋이 통째로 날아감)"
echo ""
echo "════════════════════════════════════════"
echo "🎯 미션: reflog를 사용하여 모든 것을 복구하세요!"
echo "   exercise-guide.md를 참고하여 실습을 시작하세요."
