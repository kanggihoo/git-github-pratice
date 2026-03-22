# Phase 1 - Scenario 1.3: 잃어버린 커밋/브랜치 예토전생 (Reflog)

## 시나리오 정보

| 항목 | 내용 |
|------|------|
| **Phase** | Phase 1: 실수 복구 및 히스토리 세탁 |
| **Scenario** | 1.3 |
| **난이도** | 상 |
| **핵심 개념** | `git reflog`, `git reset`, `git checkout`, `git branch` |

## 상황 설명

> 당신은 3일 동안 작업한 feature 브랜치가 있었습니다. 그런데 실수로 `git reset --hard`를 잘못 입력해서 커밋이 사라져버렸거나, `git branch -D`로 아직 merge하지 않은 브랜치를 강제 삭제해버렸습니다. `git log`에도 보이지 않습니다. 3일치 작업이 날아간 것일까요?

이 시나리오를 선택한 이유: Git에서 **"진짜 복구 불가능한 상황"은 거의 없습니다.** `reflog`는 Git의 숨겨진 안전장치이며, 이것을 아는 것과 모르는 것은 위기 상황에서의 대응력이 완전히 다릅니다.

## 학습 목표

1. `git reflog`가 무엇이고 어떻게 동작하는지 이해한다
2. `git reset --hard`로 사라진 커밋을 reflog로 복구하는 방법을 배운다
3. 삭제된 브랜치를 reflog로 복구하는 방법을 배운다
4. `git log`와 `git reflog`의 차이를 명확히 이해한다
5. reflog의 한계(만료 기간, 로컬 전용)를 이해한다

## 사전 요구사항

- Git 기본 명령어 사용 경험
- `git reset`의 동작 이해 (Scenario 1.1 완료 권장)
- 브랜치 생성/삭제 경험

## 핵심 학습 개념

### git log vs git reflog

```
git log: "현재 브랜치에서 도달 가능한 커밋만" 보여줌
git reflog: "HEAD가 이동한 모든 기록을" 보여줌 (삭제된 커밋 포함!)
```

```
[상황] A → B → C → D 에서 git reset --hard B 실행 후

─── git log ───
B ← HEAD
A
(C, D가 보이지 않음! 사라진 것 같지만...)

─── git reflog ───
B  HEAD@{0}: reset: moving to HEAD~2      ← reset 한 기록!
D  HEAD@{1}: commit: 기능 D 추가          ← D가 여기 있다!
C  HEAD@{2}: commit: 기능 C 추가          ← C도 여기 있다!
B  HEAD@{3}: commit: 기능 B 추가
A  HEAD@{4}: commit (initial): 초기 설정
```

### Reflog의 동작 원리

```
┌──────────────────────────────────────────────────────┐
│                    Git Reflog                         │
│                                                      │
│  HEAD가 이동할 때마다 자동으로 기록됨                   │
│                                                      │
│  기록되는 이벤트:                                     │
│  • commit — 새 커밋 생성                              │
│  • checkout — 브랜치 전환                             │
│  • reset — HEAD 이동                                  │
│  • rebase — 리베이스                                  │
│  • merge — 병합                                      │
│  • pull — 풀                                         │
│                                                      │
│  ⚠️ 한계:                                            │
│  • 로컬에서만 동작 (원격에는 reflog 없음)              │
│  • 기본 90일 후 만료 (gc.reflogExpire)                 │
│  • git gc로 정리되면 영구 삭제                         │
└──────────────────────────────────────────────────────┘
```

### 복구 과정 흐름도

```
사고 발생!
(reset --hard / branch -D)
        │
        ▼
git reflog 실행
        │
        ▼
잃어버린 커밋의 해시 찾기
(HEAD@{N} 형태로 표시됨)
        │
        ├─── 커밋 복구가 목적이라면 ───→ git reset --hard <해시>
        │                               (HEAD를 그 커밋으로 이동)
        │
        └─── 브랜치 복구가 목적이라면 ──→ git branch <브랜치명> <해시>
                                        (그 커밋에서 새 브랜치 생성)
```

## 실습 환경 준비

### 1단계: 작업 폴더 준비

```bash
cd exercises/phase1-scenario1.3-reflog-20260321/practice
mkdir workspace && cd workspace
```

### 2단계: 초기 환경 구성

```bash
bash ../setup-script.sh
```

### 초기 상태 확인

setup 스크립트 실행 후, **2가지 사고**가 발생한 상태입니다:

**사고 1: `git reset --hard`로 커밋 유실**
```
main 브랜치에서 최근 2개 커밋이 reset --hard로 사라진 상태
현재 git log에는 3개 커밋만 보임 (원래 5개였음)
```

**사고 2: 브랜치 강제 삭제**
```
feature/payment 브랜치가 git branch -D로 삭제된 상태
이 브랜치에는 merge되지 않은 2개의 고유 커밋이 있었음
```

## 추천 실습 순서

1. **미션 1**: `git log`로 현재 상태 확인 (커밋이 없어진 것을 확인)
2. **미션 2**: `git reflog`로 잃어버린 커밋 찾기 (핵심!)
3. **미션 3**: 사라진 커밋 복구하기
4. **미션 4**: 삭제된 브랜치 복구하기
5. **미션 5**: (심화) reflog 항목의 의미 분석

## 교육자의 팁

- **reflog는 로컬에서만 동작합니다.** 원격 저장소에서 사라진 커밋은 reflog로 복구할 수 없습니다.
- **시간이 지나면 reflog도 사라집니다.** 기본 90일 후 만료되며, `git gc`가 실행되면 정리됩니다. 실수를 발견하면 빨리 복구하세요!
- `HEAD@{0}`이 가장 최근 기록, 숫자가 커질수록 오래된 기록입니다.
- reflog에서 해시를 찾았다면, `git show <해시>`로 해당 커밋의 내용을 먼저 확인한 후 복구하세요.
- `git reflog`는 `git log -g`와 동일합니다.

## 실무에서의 활용

| 상황 | 해결 방법 |
|------|----------|
| `reset --hard` 실수로 작업 날림 | `reflog`에서 해시 찾기 → `reset --hard <해시>` |
| merge 안 한 브랜치 삭제 | `reflog`에서 해시 찾기 → `branch <이름> <해시>` |
| rebase 실수로 커밋 꼬임 | `reflog`에서 rebase 전 해시 찾기 → `reset --hard <해시>` |
| "어제 분명히 있었는데..." | `reflog`에서 시간대별 검색 |

## 최종 기대 효과

이 시나리오를 마치면:
- `git reset --hard` 실수가 발생해도 **당황하지 않고 reflog로 복구**할 수 있습니다
- 삭제된 브랜치를 **reflog에서 찾아 되살릴** 수 있습니다
- Git에서 **"진짜 복구 불가능한 상황"이 거의 없다**는 것을 체감합니다
- reflog의 한계를 이해하여 **빠른 복구의 중요성**을 인식합니다

## 심화 도전 과제

1. **reflog 만료 설정 확인**: `git config gc.reflogExpire`로 현재 만료 기간을 확인하고, 의미를 이해해보세요.
2. **특정 브랜치의 reflog**: `git reflog show <브랜치명>`으로 특정 브랜치의 이동 기록만 볼 수 있습니다. main 브랜치의 reflog를 확인해보세요.
