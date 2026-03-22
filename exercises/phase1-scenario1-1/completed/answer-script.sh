#!/bin/bash
# ══════════════════════════════════════════════════════════════
# 정답 스크립트
# Phase 1 - Scenario 1.1: 이미 푸시된 잘못된 커밋 수습하기
# ══════════════════════════════════════════════════════════════
# ⚠️ 주의: 이 스크립트는 참고용입니다.
# 각 Step을 하나씩 직접 입력하며 결과를 확인하세요.
# ══════════════════════════════════════════════════════════════


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Part A: git revert로 안전하게 되돌리기 (공유 브랜치용)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── [Step 1: 현재 히스토리 확인] ─────────────────────
# 어떤 커밋이 문제인지 파악합니다.
git log --oneline

# 예상 출력:
# <hash4> feat: 사용자 인증 기능 추가      ← 이 커밋을 되돌려야 함
# <hash3> feat: 사용자 프로필 페이지 추가
# <hash2> feat: 메인 페이지 스타일링
# <hash1> init: 프로젝트 초기 설정

# ─── [Step 2: 버그가 있는 커밋의 변경 내용 확인] ─────
# revert하기 전에, 정확히 무엇이 되돌려질지 확인합니다.
git show HEAD --stat

# 예상 출력:
# commit <hash4>
# feat: 사용자 인증 기능 추가
#  auth.js    | 30 ++++++++++++++++++++++++++++++
#  index.html |  8 ++++++++
#  2 files changed, 38 insertions(+)

# ─── [Step 3: git revert 실행] ────────────────────────
# HEAD(마지막 커밋)를 되돌리는 새 커밋을 생성합니다.
# --no-edit 옵션으로 기본 커밋 메시지를 자동 사용합니다.
git revert HEAD --no-edit

# 예상 출력:
# [main <new_hash>] Revert "feat: 사용자 인증 기능 추가"
#  2 files changed, 38 deletions(-)
#  delete mode 100644 auth.js

# ─── [Step 4: revert 결과 확인] ───────────────────────
# 히스토리를 확인하면 revert 커밋이 새로 추가되어 있습니다.
git log --oneline

# 예상 출력:
# <hash5> Revert "feat: 사용자 인증 기능 추가"   ← 새로 생긴 revert 커밋
# <hash4> feat: 사용자 인증 기능 추가
# <hash3> feat: 사용자 프로필 페이지 추가
# <hash2> feat: 메인 페이지 스타일링
# <hash1> init: 프로젝트 초기 설정

# ─── [Step 5: 파일 상태 확인] ─────────────────────────
# auth.js가 삭제되었는지 확인합니다.
ls -la

# auth.js가 사라지고, index.html이 원래 상태로 돌아왔는지 확인:
git diff HEAD~2 HEAD -- index.html

# 출력이 없으면 = 원래 상태로 완벽히 복원됨

# ─── [Step 6: 원격에 push] ────────────────────────────
# revert 커밋을 원격에 push합니다.
# 일반 push로 충분합니다 (force push 불필요!)
git push origin main

# ─── [Step 7: 원격 히스토리 확인] ─────────────────────
# 원격의 히스토리도 확인합니다.
git log --oneline origin/main

# 예상 출력: 로컬과 동일한 5개 커밋 (revert 포함)


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Part B: (심화) git reset으로 되돌리기 (개인 브랜치용)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 이 부분은 Part A를 완료한 후 별도 브랜치에서 실습합니다.

# ─── [Step 8: 실습용 브랜치 생성] ─────────────────────
# Part A의 revert 전 상태를 재현하기 위해 새 브랜치를 만듭니다.
git checkout -b practice/reset-demo HEAD~1
# → revert 직전 커밋(= 버그 커밋이 있는 상태)으로 브랜치 생성

# ─── [Step 9: 현재 상태 확인] ─────────────────────────
git log --oneline
# 예상 출력:
# <hash4> feat: 사용자 인증 기능 추가
# <hash3> feat: 사용자 프로필 페이지 추가
# <hash2> feat: 메인 페이지 스타일링
# <hash1> init: 프로젝트 초기 설정

# ─── [Step 10: 원격에 push (reset 전 상태 기록)] ─────
git push origin practice/reset-demo --quiet 2>/dev/null

# ─── [Step 11: git reset으로 마지막 커밋 제거] ────────
# --hard: 워킹 디렉토리와 스테이징 영역 모두 되돌림
git reset --hard HEAD~1

# 예상 출력:
# HEAD is now at <hash3> feat: 사용자 프로필 페이지 추가

# ─── [Step 12: reset 결과 확인] ───────────────────────
git log --oneline
# 예상 출력: (커밋 4가 완전히 사라짐!)
# <hash3> feat: 사용자 프로필 페이지 추가
# <hash2> feat: 메인 페이지 스타일링
# <hash1> init: 프로젝트 초기 설정

# auth.js가 완전히 사라졌는지 확인:
ls auth.js 2>/dev/null || echo "auth.js가 삭제되었습니다"

# ─── [Step 13: force push] ───────────────────────────
# 원격의 히스토리를 로컬과 일치시킵니다.
# ⚠️ 주의: force push는 개인 브랜치에서만 사용하세요!
git push -f origin practice/reset-demo

# ─── [Step 14: revert와 reset 비교] ──────────────────
# main 브랜치로 돌아와서 두 브랜치의 히스토리를 비교합니다.
git checkout main

echo ""
echo "=== main 브랜치 (revert 사용) ==="
git log --oneline main
echo ""
echo "=== practice/reset-demo 브랜치 (reset 사용) ==="
git log --oneline practice/reset-demo
echo ""
echo "결론:"
echo "  - revert: 히스토리가 보존됨 (4+1=5개 커밋)"
echo "  - reset:  히스토리가 제거됨 (3개 커밋)"
echo "  - 공유 브랜치 → revert / 개인 브랜치 → reset"
