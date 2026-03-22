# 📌 Scenario 1.3 명령어 요약 카드

## 핵심 명령어

| 명령어 | 설명 | 예시 |
|--------|------|------|
| `git reflog` | HEAD의 모든 이동 기록 보기 | `git reflog` |
| `git reflog --date=relative` | 시간 정보 포함 reflog | `git reflog --date=relative` |
| `git reflog show <브랜치>` | 특정 브랜치의 reflog | `git reflog show main` |
| `git show <해시>` | 특정 커밋의 내용 확인 | `git show HEAD@{5}` |
| `git reset --hard <해시>` | HEAD를 해당 커밋으로 이동 | `git reset --hard HEAD@{5}` |
| `git branch <이름> <해시>` | 해당 커밋에서 브랜치 생성 | `git branch feature/payment abc1234` |

## reflog 참조 형식

| 형식 | 의미 | 예시 |
|------|------|------|
| `HEAD@{0}` | 가장 최근 기록 | 현재 HEAD 위치 |
| `HEAD@{1}` | 1개 전 기록 | 바로 이전 HEAD 위치 |
| `HEAD@{N}` | N개 전 기록 | N번째 이전 HEAD 위치 |
| `abc1234` | 직접 해시 지정 | reflog에서 찾은 해시 |

## git log vs git reflog

| 항목 | `git log` | `git reflog` |
|------|:---------:|:------------:|
| 보여주는 것 | 현재 브랜치의 커밋 | HEAD 이동 기록 전체 |
| 삭제된 커밋 | 안 보임 | **보임** |
| 범위 | 원격에서도 공유 | **로컬 전용** |
| 만료 | 영구 | 기본 90일 |

## 복구 패턴 요약

```
사라진 커밋 복구:
  1. git reflog         (해시 찾기)
  2. git show <해시>    (내용 확인)
  3. git reset --hard <해시>  (복구)

삭제된 브랜치 복구:
  1. git reflog         (마지막 커밋 해시 찾기)
  2. git show <해시>    (내용 확인)
  3. git branch <이름> <해시>  (복구)
```
