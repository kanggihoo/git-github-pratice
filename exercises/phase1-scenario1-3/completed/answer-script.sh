#!/bin/bash
# ══════════════════════════════════════════════════════════════
# 정답 스크립트
# Phase 1 - Scenario 1.3: 잃어버린 커밋/브랜치 예토전생 (Reflog)
# ══════════════════════════════════════════════════════════════
# ⚠️ 주의: 이 스크립트는 참고용입니다.
# 각 Step을 하나씩 직접 입력하며 결과를 확인하세요.
# ══════════════════════════════════════════════════════════════


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Part A: 사라진 커밋 복구하기 (reset --hard 실수 복구)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── [Step 1: 현재 상태 확인 - git log] ──────────────
# 먼저 일반적인 git log로 확인합니다.
git log --oneline

# 예상 출력 (3개만 보임):
# <hash3> feat: 노트 검색 기능 추가
# <hash2> feat: 노트 카드 스타일 개선
# <hash1> init: 프로젝트 초기 설정
#
# → "노트 삭제 기능"과 "노트 편집 기능" 커밋이 보이지 않음!

# ─── [Step 2: reflog로 숨겨진 기록 확인] ─────────────
# git reflog는 HEAD의 모든 이동 기록을 보여줍니다.
git reflog

# 예상 출력:
# <hash3> HEAD@{0}: reset: moving to HEAD~2        ← reset 기록!
# <hash5> HEAD@{1}: checkout: moving from feature/payment to main
# <hashF2> HEAD@{2}: commit: feat: 결제 페이지 UI 추가
# <hashF1> HEAD@{3}: commit: feat: 결제 시스템 초기 구현
# <hash3> HEAD@{4}: checkout: moving from main to feature/payment
# <hash5> HEAD@{5}: commit: feat: 노트 편집 기능 추가   ← 찾았다!
# <hash4> HEAD@{6}: commit: feat: 노트 삭제 기능 추가   ← 찾았다!
# <hash3> HEAD@{7}: commit: feat: 노트 검색 기능 추가
# ...

# ─── [Step 3: 사라진 커밋 내용 확인] ─────────────────
# 복구하기 전에 해당 커밋이 맞는지 확인합니다.
# HEAD@{5}의 해시를 사용합니다 (또는 reflog에서 찾은 해시).
git show HEAD@{5} --stat

# 예상 출력:
# commit <hash5>
# feat: 노트 편집 기능 추가
#  app.js | ... insertions(+)
# → 이것이 우리가 찾는 커밋!

# ─── [Step 4: 커밋 복구 (reset으로 되돌아가기)] ──────
# HEAD를 사라졌던 커밋으로 이동시킵니다.
git reset --hard HEAD@{5}
# 또는: git reset --hard <hash5>

# 예상 출력:
# HEAD is now at <hash5> feat: 노트 편집 기능 추가

# ─── [Step 5: 복구 확인] ─────────────────────────────
git log --oneline

# 예상 출력 (5개 커밋 모두 복구!):
# <hash5> feat: 노트 편집 기능 추가
# <hash4> feat: 노트 삭제 기능 추가
# <hash3> feat: 노트 검색 기능 추가
# <hash2> feat: 노트 카드 스타일 개선
# <hash1> init: 프로젝트 초기 설정

# app.js에 deleteNote, editNote 함수가 복원되었는지 확인:
cat app.js


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Part B: 삭제된 브랜치 복구하기
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── [Step 6: 삭제된 브랜치 확인] ────────────────────
# 현재 브랜치 목록을 확인합니다.
git branch -a

# 예상 출력:
# * main
# → feature/payment가 없음!

# ─── [Step 7: reflog에서 브랜치의 마지막 커밋 찾기] ──
# reflog를 다시 확인하여 feature/payment 관련 기록을 찾습니다.
git reflog

# reflog에서 "feat: 결제 페이지 UI 추가" 커밋의 해시를 찾습니다.
# HEAD@{2}: commit: feat: 결제 페이지 UI 추가 ← 이 해시!

# ─── [Step 8: 해당 커밋 내용 확인] ───────────────────
git show HEAD@{2} --stat

# 예상 출력:
# commit <hashF2>
# feat: 결제 페이지 UI 추가
#  payment-ui.html | ... insertions(+)

# ─── [Step 9: 브랜치 복구] ───────────────────────────
# 삭제된 브랜치의 마지막 커밋에서 새 브랜치를 생성합니다.
git branch feature/payment HEAD@{2}
# 또는: git branch feature/payment <hashF2>

# ─── [Step 10: 복구 확인] ────────────────────────────
git branch -a

# 예상 출력:
# feature/payment   ← 복구됨!
# * main

# 복구된 브랜치의 커밋 확인:
git log --oneline feature/payment

# 예상 출력:
# <hashF2> feat: 결제 페이지 UI 추가
# <hashF1> feat: 결제 시스템 초기 구현
# <hash3> feat: 노트 검색 기능 추가
# <hash2> feat: 노트 카드 스타일 개선
# <hash1> init: 프로젝트 초기 설정

# ─── [Step 11: 브랜치에 있는 파일 확인] ──────────────
git checkout feature/payment
ls

# payment.js와 payment-ui.html이 복구되었는지 확인:
cat payment.js

# 다시 main으로 돌아옴:
git checkout main


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Part C: (심화) reflog 항목 분석
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── [Step 12: reflog 상세 보기] ─────────────────────
# 시간 정보와 함께 reflog를 확인합니다.
git reflog --date=relative

# HEAD@{2 minutes ago}: reset: moving to HEAD~2
# HEAD@{3 minutes ago}: checkout: ...

# 특정 브랜치의 reflog만 보기:
git reflog show main

# ─── [최종 상태 확인] ────────────────────────────────
echo ""
echo "=== 복구 완료! ==="
echo ""
echo "main 브랜치:"
git log --oneline main
echo ""
echo "feature/payment 브랜치:"
git log --oneline feature/payment
echo ""
echo "모든 코드가 성공적으로 복구되었습니다!"
