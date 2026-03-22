# 📌 Scenario 1.1 명령어 요약 카드

## 핵심 명령어

| 명령어 | 설명 | 예시 |
|--------|------|------|
| `git log --oneline` | 커밋 히스토리 한 줄 요약 | `git log --oneline` |
| `git show <커밋> --stat` | 특정 커밋의 변경 파일 목록 | `git show HEAD --stat` |
| `git revert <커밋>` | 해당 커밋을 되돌리는 새 커밋 생성 | `git revert HEAD` |
| `git revert --no-edit <커밋>` | 에디터 없이 기본 메시지로 revert | `git revert --no-edit HEAD` |
| `git reset --hard <커밋>` | 해당 커밋으로 히스토리 되감기 | `git reset --hard HEAD~1` |
| `git push origin <브랜치>` | 원격에 push | `git push origin main` |
| `git push -f origin <브랜치>` | 강제 push (히스토리 덮어쓰기) | `git push -f origin feature` |

## 자주 쓰는 커밋 참조

| 표현 | 의미 |
|------|------|
| `HEAD` | 현재 커밋 (가장 최근) |
| `HEAD~1` | 현재에서 1개 전 커밋 |
| `HEAD~2` | 현재에서 2개 전 커밋 |
| `abc1234` | 특정 커밋 해시 (7자리 이상) |

## reset 옵션 비교

| 옵션 | 워킹 디렉토리 | 스테이징 영역 | 커밋 히스토리 |
|------|:---:|:---:|:---:|
| `--soft` | 유지 | 유지 | 되감기 |
| `--mixed` (기본) | 유지 | 되감기 | 되감기 |
| `--hard` | 되감기 | 되감기 | 되감기 |

## 핵심 요약

```
공유 브랜치 (main)    → git revert (안전)
개인 브랜치 (feature) → git reset + push -f (깔끔)
```
