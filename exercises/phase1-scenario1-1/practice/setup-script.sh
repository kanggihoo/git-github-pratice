#!/bin/bash
# ══════════════════════════════════════════════════════════════
# 초기 환경 구성 스크립트
# Phase 1 - Scenario 1.1: 이미 푸시된 잘못된 커밋 수습하기
# ══════════════════════════════════════════════════════════════
# 이 스크립트를 실행하면 다음과 같은 환경이 만들어집니다:
#
# [Git 히스토리]
#   1. init: 프로젝트 초기 설정          (index.html, app.js, style.css)
#   2. feat: 메인 페이지 스타일링         (style.css 수정)
#   3. feat: 사용자 프로필 페이지 추가     (profile.html 추가)
#   4. feat: 사용자 인증 기능 추가        (auth.js 추가 - 버그 포함!) ← 이 커밋이 문제!
#
# [원격 저장소]
#   - /tmp/scenario1.1-remote.git 에 로컬 bare repo를 생성하여 origin으로 사용
#   - 위 4개 커밋이 모두 push된 상태
#
# 학습자는 이 상태에서 "버그가 있는 마지막 커밋"을 되돌리는 미션을 시작합니다.
# ══════════════════════════════════════════════════════════════

# set -e  # 에러 발생 시 스크립트 중단

# # ─── [사전 체크: 기존 Git 저장소 안에서 실행 방지] ─────
# if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
#     echo "❌ 오류: 이미 Git 저장소 안에 있습니다!"
#     echo "   빈 폴더에서 실행해주세요."
#     echo "   예: mkdir workspace && cd workspace && bash ../setup-script.sh"
#     exit 1
# fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Scenario 1.1 실습 환경을 구성합니다..."
echo ""

# ─── [원격 저장소(bare repo) 생성] ────────────────────
# 실제 GitHub 대신 로컬 bare repo를 원격 저장소로 사용합니다.
# 이미 GitHub 리포지토리가 있다면 이 단계를 건너뛰어도 됩니다.
# REMOTE_PATH="/tmp/scenario1.1-remote.git"
# if [ -d "$REMOTE_PATH" ]; then
#     rm -rf "$REMOTE_PATH"
# fi
# git init --bare "$REMOTE_PATH" --quiet
# echo "📦 원격 저장소 생성 완료: $REMOTE_PATH"

# # ─── [Git 저장소 초기화] ──────────────────────────────
# git init --quiet
# git branch -M main

# ─── [Commit 1: 프로젝트 초기 설정] ──────────────────
# 기본 프로젝트 파일들을 추가합니다.
cp "$SCRIPT_DIR/project-files/index.html" .
cp "$SCRIPT_DIR/project-files/app.js" .
cp "$SCRIPT_DIR/project-files/style.css" .
git add index.html app.js style.css
git commit -m "init: 프로젝트 초기 설정" --quiet

# ─── [Commit 2: 메인 페이지 스타일링] ────────────────
# style.css에 추가 스타일을 넣습니다.
cat >> style.css << 'STYLE'

/* 할 일 항목 스타일 */
#tasks li {
    padding: 0.75rem;
    border-bottom: 1px solid #eee;
    cursor: pointer;
    transition: all 0.2s;
}

#tasks li:hover {
    background-color: #f0f0f0;
}

#tasks li.done {
    text-decoration: line-through;
    color: #999;
}
STYLE
git add style.css
git commit -m "feat: 메인 페이지 스타일링" --quiet

# ─── [Commit 3: 사용자 프로필 페이지 추가] ───────────
# 새로운 HTML 페이지를 생성합니다.
cat > profile.html << 'HTML'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>TaskFlow - 프로필</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>TaskFlow</h1>
        <nav>
            <a href="/">홈</a>
            <a href="/profile">프로필</a>
        </nav>
    </header>
    <main>
        <h2>내 프로필</h2>
        <div id="profile-info">
            <p>이름: 홍길동</p>
            <p>이메일: hong@example.com</p>
        </div>
    </main>
</body>
</html>
HTML
git add profile.html
git commit -m "feat: 사용자 프로필 페이지 추가" --quiet

# ─── [Commit 4: 사용자 인증 기능 추가 (버그 포함!)] ──
# ⚠️ 이 커밋이 문제의 커밋입니다!
# auth.js에 3가지 보안 버그가 포함되어 있습니다:
#   1. 비밀번호 검증 없이 로그인 허용
#   2. 비밀번호 평문 저장
#   3. 하드코딩된 시크릿 키
cp "$SCRIPT_DIR/project-files/auth.js" .

# index.html에 로그인 폼도 추가
cat >> index.html << 'HTML'

    <!-- 인증 섹션 (auth.js에 의존) -->
    <section id="auth">
        <h2>로그인</h2>
        <input type="text" id="username" placeholder="사용자명">
        <input type="password" id="password" placeholder="비밀번호">
        <button onclick="handleLogin()">로그인</button>
    </section>
    <script src="auth.js"></script>
HTML

git add auth.js index.html
git commit -m "feat: 사용자 인증 기능 추가" --quiet

# ─── [원격에 Push] ───────────────────────────────────
# 모든 커밋을 원격 저장소에 push합니다.
# 이로써 "이미 push된 잘못된 커밋" 상황이 만들어집니다.
git push -u origin main --quiet 2>/dev/null

echo ""
echo "✅ 환경 구성 완료!"
echo ""
echo "📋 현재 Git 히스토리:"
git log --oneline
echo ""
echo "📦 원격 저장소(origin)에도 동일하게 push 되어있습니다."
echo ""
echo "⚠️  마지막 커밋 'feat: 사용자 인증 기능 추가'에 치명적인 버그가 있습니다!"
echo "   auth.js 파일을 확인해보세요."
echo ""
echo "🎯 미션: 이 커밋을 안전하게 되돌리세요!"
echo "   exercise-guide.md를 참고하여 실습을 시작하세요."
