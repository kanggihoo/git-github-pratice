# Scenario 1.3 실습 가이드: 잃어버린 커밋/브랜치 예토전생 (Reflog)

> **상황**: 실수로 `git reset --hard`를 잘못 입력해서 2개의 커밋이 사라졌습니다.
> 게다가 merge하지 않은 `feature/payment` 브랜치까지 강제 삭제해버렸습니다.
> 3일치 작업이 날아간 것일까요? reflog로 모든 것을 복구하세요!

---

## 🎯 미션 0: 실습 환경 구성

### 📋 해야 할 일
setup-script.sh를 실행하여 사고 상황을 재현하세요.

### 실행 방법
```bash
mkdir workspace && cd workspace
bash ../setup-script.sh
```

### ✅ 확인 방법
- "사고 발생 보고서"가 출력되나요?
- `git log --oneline`에서 커밋이 **3개만** 보이나요? (원래 5개였음)
- `git branch -a`에서 `feature/payment`가 **없나요?**

---

## 🎯 미션 1: 현재 상태 파악 (문제 인식)

### 📋 해야 할 일
1. `git log`로 현재 커밋 히스토리를 확인하세요.
2. `git branch -a`로 브랜치 목록을 확인하세요.
3. 무엇이 사라졌는지 파악하세요.

### 💡 힌트
- `git log --oneline`으로 커밋 목록 확인
- `git branch -a`로 모든 브랜치(로컬+원격) 확인
- 사라진 것:
  - main 브랜치의 커밋 2개 ("노트 삭제 기능", "노트 편집 기능")
  - feature/payment 브랜치 전체

### ✅ 확인 방법
- `git log`에 "노트 삭제 기능"과 "노트 편집 기능" 커밋이 **보이지 않나요?**
- 브랜치 목록에 `feature/payment`가 **없나요?**
- → 이것이 복구해야 할 대상입니다!

---

## 🎯 미션 2: reflog로 잃어버린 커밋 찾기 (핵심!)

### 📋 해야 할 일
`git reflog`를 실행하여 HEAD의 이동 기록을 확인하고, 사라진 커밋의 해시를 찾으세요.

### 💡 힌트
- HEAD의 모든 이동 기록을 보는 명령어: `git r_____`
- 출력에서 `reset: moving to HEAD~2` 기록을 찾으세요 ← 이것이 사고의 흔적!
- 그 **바로 아래 줄**에 사라지기 전의 커밋들이 있습니다
- 각 항목은 `HEAD@{N}` 형식으로 참조할 수 있습니다

### ✅ 확인 방법
- reflog에서 "feat: 노트 편집 기능 추가" 커밋의 해시(또는 HEAD@{N})를 찾았나요?
- reflog에서 "feat: 결제 페이지 UI 추가" 커밋의 해시(또는 HEAD@{N})를 찾았나요?

---

## 🎯 미션 3: 사라진 main 커밋 복구하기

### 📋 해야 할 일
reflog에서 찾은 해시를 사용하여, main 브랜치를 "노트 편집 기능 추가" 커밋 상태로 복구하세요.

### 💡 힌트
- 복구하기 전에 해당 커밋이 맞는지 확인: `git ____ <해시> --stat`
- HEAD를 해당 커밋으로 이동: `git _____ --____ <해시>`
  - `HEAD@{N}` 형식이나 커밋 해시 모두 사용 가능합니다
  - `--hard`는 워킹 디렉토리까지 모두 해당 커밋 상태로 변경합니다

### ✅ 확인 방법
- `git log --oneline`에서 커밋이 **5개**로 복구되었나요?
- "노트 삭제 기능"과 "노트 편집 기능" 커밋이 다시 보이나요?
- `cat app.js`에서 `deleteNote`와 `editNote` 함수가 있나요?

---

## 🎯 미션 4: 삭제된 브랜치 복구하기

### 📋 해야 할 일
reflog에서 찾은 해시를 사용하여, 삭제된 `feature/payment` 브랜치를 복구하세요.

### 💡 힌트
- reflog에서 "feat: 결제 페이지 UI 추가" 커밋의 해시를 찾으세요
  - 이것이 feature/payment 브랜치의 **마지막 커밋**입니다
- 해당 커밋에서 새 브랜치를 생성: `git ______ <브랜치이름> <해시>`
  - 이 명령어는 해당 커밋을 가리키는 새 브랜치를 만듭니다
  - reset과 달리 현재 브랜치는 이동하지 않습니다

### ✅ 확인 방법
- `git branch -a`에서 `feature/payment`가 다시 보이나요?
- `git log --oneline feature/payment`에서 결제 관련 커밋 2개가 보이나요?
- `git checkout feature/payment` 후 `ls`에서 `payment.js`와 `payment-ui.html`이 있나요?
- (확인 후) `git checkout main`으로 돌아오세요

---

## 🎯 미션 5: (심화) reflog 항목 분석

### 📋 해야 할 일
1. reflog를 시간 정보와 함께 확인해보세요.
2. main 브랜치의 reflog만 따로 확인해보세요.

### 💡 힌트
- 시간 정보 포함: `git reflog --date=________`
  - `relative` (몇 분 전), `iso` (날짜/시간), `short` (날짜만)
- 특정 브랜치의 reflog: `git reflog show ____`

### ✅ 확인 방법
- 각 reflog 항목에 시간이 표시되나요?
- main 브랜치의 이동 기록만 필터링되어 보이나요?

---

## 🏁 실습 완료 체크리스트

- [ ] `git reflog`로 HEAD 이동 기록을 확인했다
- [ ] reflog에서 사라진 커밋의 해시를 찾아냈다
- [ ] `git reset --hard`로 main의 커밋을 복구했다 (3개 → 5개)
- [ ] `git branch`로 삭제된 feature/payment를 복구했다
- [ ] 복구된 브랜치의 파일이 정상인지 확인했다
- [ ] (심화) reflog의 시간 정보를 확인했다
- [ ] `git log`와 `git reflog`의 차이를 이해했다
