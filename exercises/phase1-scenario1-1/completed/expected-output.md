# Scenario 1.1 예상 출력 결과

> 커밋 해시(`abc1234`)는 환경마다 다릅니다. 구조와 메시지만 일치하면 정상입니다.

---

## Part A: git revert로 안전하게 되돌리기

### Step 1: git log --oneline

```
$ git log --oneline
f4a2b1c feat: 사용자 인증 기능 추가
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정
```

### Step 2: git show HEAD --stat

```
$ git show HEAD --stat
commit f4a2b1c (HEAD -> main, origin/main)
Author: Your Name <you@example.com>
Date:   ...

    feat: 사용자 인증 기능 추가

 auth.js    | 30 ++++++++++++++++++++++++++++++
 index.html |  8 ++++++++
 2 files changed, 38 insertions(+)
```

### Step 3: git revert HEAD --no-edit

```
$ git revert HEAD --no-edit
[main e5f6g7h] Revert "feat: 사용자 인증 기능 추가"
 2 files changed, 38 deletions(-)
 delete mode 100644 auth.js
```

### Step 4: git log --oneline (revert 후)

```
$ git log --oneline
e5f6g7h Revert "feat: 사용자 인증 기능 추가"
f4a2b1c feat: 사용자 인증 기능 추가
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정
```

> **핵심 포인트**: 커밋이 5개입니다. 원래 4개 + revert 커밋 1개.
> 잘못된 커밋(f4a2b1c)은 히스토리에 남아있지만, 그 변경사항은 e5f6g7h에 의해 취소되었습니다.

### Step 5: 파일 상태 확인

```
$ ls
app.js  index.html  profile.html  style.css

(auth.js가 없으면 정상!)
```

```
$ git diff HEAD~2 HEAD -- index.html
(출력 없음 = index.html이 원래 상태로 완벽히 복원됨)
```

### Step 6: git push origin main

```
$ git push origin main
   f4a2b1c..e5f6g7h  main -> main
```

> **핵심 포인트**: 일반 push만으로 충분합니다. force push가 필요 없습니다!

---

## Part B: (심화) git reset으로 되돌리기

### Step 8: 실습용 브랜치 생성

```
$ git checkout -b practice/reset-demo HEAD~1
Switched to a new branch 'practice/reset-demo'
```

### Step 9: git log --oneline

```
$ git log --oneline
f4a2b1c feat: 사용자 인증 기능 추가
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정
```

### Step 11: git reset --hard HEAD~1

```
$ git reset --hard HEAD~1
HEAD is now at c3d8e9f feat: 사용자 프로필 페이지 추가
```

### Step 12: git log --oneline (reset 후)

```
$ git log --oneline
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정
```

> **핵심 포인트**: 커밋이 3개입니다. 버그 커밋이 히스토리에서 완전히 사라졌습니다.

### Step 13: git push -f

```
$ git push -f origin practice/reset-demo
+ f4a2b1c...c3d8e9f practice/reset-demo -> practice/reset-demo (forced update)
```

> `(forced update)` 표시에 주목하세요. 이것이 force push의 증거입니다.

### Step 14: 최종 비교

```
=== main 브랜치 (revert 사용) ===
e5f6g7h Revert "feat: 사용자 인증 기능 추가"
f4a2b1c feat: 사용자 인증 기능 추가
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정

=== practice/reset-demo 브랜치 (reset 사용) ===
c3d8e9f feat: 사용자 프로필 페이지 추가
b2a7d6e feat: 메인 페이지 스타일링
a1b3c5d init: 프로젝트 초기 설정
```

> **결론**:
> - **revert**: 히스토리 보존 (5개 커밋). 팀원은 `git pull`만 하면 됨.
> - **reset**: 히스토리 제거 (3개 커밋). 팀원은 `git pull`하면 충돌 발생!
