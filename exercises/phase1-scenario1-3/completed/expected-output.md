# Scenario 1.3 예상 출력 결과

> 커밋 해시와 HEAD@{N} 번호는 환경마다 다릅니다. 구조만 일치하면 정상입니다.

---

## Part A: 사라진 커밋 복구하기

### Step 1: git log --oneline (복구 전)

```
$ git log --oneline
c3d4e5f feat: 노트 검색 기능 추가
b2c3d4e feat: 노트 카드 스타일 개선
a1b2c3d init: 프로젝트 초기 설정
```

> 3개 커밋만 보입니다. 원래 5개였는데 2개가 사라졌습니다!

### Step 2: git reflog

```
$ git reflog
c3d4e5f HEAD@{0}: reset: moving to HEAD~2
e5f6g7h HEAD@{1}: checkout: moving from feature/payment to main
j0k1l2m HEAD@{2}: commit: feat: 결제 페이지 UI 추가
i9j0k1l HEAD@{3}: commit: feat: 결제 시스템 초기 구현
c3d4e5f HEAD@{4}: checkout: moving from main to feature/payment
e5f6g7h HEAD@{5}: commit: feat: 노트 편집 기능 추가
d4e5f6g HEAD@{6}: commit: feat: 노트 삭제 기능 추가
c3d4e5f HEAD@{7}: commit: feat: 노트 검색 기능 추가
b2c3d4e HEAD@{8}: commit: feat: 노트 카드 스타일 개선
a1b2c3d HEAD@{9}: commit (initial): init: 프로젝트 초기 설정
```

> **핵심**: `HEAD@{0}`에서 `reset: moving to HEAD~2` 기록이 보입니다.
> `HEAD@{5}`에 사라진 "노트 편집 기능" 커밋이 있습니다!

### Step 3: git show HEAD@{5} --stat

```
$ git show HEAD@{5} --stat
commit e5f6g7h
Author: Your Name <you@example.com>
Date:   ...

    feat: 노트 편집 기능 추가

 app.js | 9 +++++++++
 1 file changed, 9 insertions(+)
```

### Step 4: git reset --hard HEAD@{5}

```
$ git reset --hard HEAD@{5}
HEAD is now at e5f6g7h feat: 노트 편집 기능 추가
```

### Step 5: git log --oneline (복구 후)

```
$ git log --oneline
e5f6g7h feat: 노트 편집 기능 추가
d4e5f6g feat: 노트 삭제 기능 추가
c3d4e5f feat: 노트 검색 기능 추가
b2c3d4e feat: 노트 카드 스타일 개선
a1b2c3d init: 프로젝트 초기 설정
```

> **5개 커밋이 모두 복구되었습니다!**

---

## Part B: 삭제된 브랜치 복구하기

### Step 6: git branch -a

```
$ git branch -a
* main
```

> feature/payment 브랜치가 없습니다!

### Step 7: reflog에서 브랜치 커밋 찾기

reflog에서 `HEAD@{2}: commit: feat: 결제 페이지 UI 추가`를 찾습니다.
이것이 feature/payment 브랜치의 마지막 커밋입니다.

### Step 9: git branch feature/payment HEAD@{2}

```
$ git branch feature/payment HEAD@{2}
(출력 없음 = 성공)
```

### Step 10: git branch -a (복구 후)

```
$ git branch -a
  feature/payment
* main
```

> **브랜치가 복구되었습니다!**

### Step 10 (계속): 복구된 브랜치의 커밋 확인

```
$ git log --oneline feature/payment
j0k1l2m feat: 결제 페이지 UI 추가
i9j0k1l feat: 결제 시스템 초기 구현
c3d4e5f feat: 노트 검색 기능 추가
b2c3d4e feat: 노트 카드 스타일 개선
a1b2c3d init: 프로젝트 초기 설정
```

### Step 11: 복구된 브랜치의 파일 확인

```
$ git checkout feature/payment
Switched to branch 'feature/payment'

$ ls
app.js  index.html  payment-ui.html  payment.js  style.css
```

> `payment.js`와 `payment-ui.html`이 복구되었습니다!

---

## Part C: reflog 상세 분석

### Step 12: git reflog --date=relative

```
$ git reflog --date=relative
e5f6g7h HEAD@{30 seconds ago}: reset: moving to HEAD@{5}
c3d4e5f HEAD@{1 minute ago}: reset: moving to HEAD~2
e5f6g7h HEAD@{1 minute ago}: checkout: moving from feature/payment to main
...
```

> `--date=relative` 옵션으로 각 기록이 언제 발생했는지 시간을 확인할 수 있습니다.

---

## 최종 상태 요약

```
=== 복구 완료! ===

main 브랜치 (5개 커밋):
e5f6g7h feat: 노트 편집 기능 추가
d4e5f6g feat: 노트 삭제 기능 추가
c3d4e5f feat: 노트 검색 기능 추가
b2c3d4e feat: 노트 카드 스타일 개선
a1b2c3d init: 프로젝트 초기 설정

feature/payment 브랜치 (5개 커밋, 고유 2개):
j0k1l2m feat: 결제 페이지 UI 추가
i9j0k1l feat: 결제 시스템 초기 구현
c3d4e5f feat: 노트 검색 기능 추가
b2c3d4e feat: 노트 카드 스타일 개선
a1b2c3d init: 프로젝트 초기 설정
```

> **결론**: `git reflog`는 Git의 최후의 안전장치입니다.
> `git log`에서 보이지 않는 커밋도 reflog에는 남아있습니다.
> 실수를 발견하면 **빨리** 복구하세요 (90일 후 만료됩니다).
