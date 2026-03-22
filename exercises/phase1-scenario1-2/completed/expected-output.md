# Scenario 1.2 예상 출력 결과

> 커밋 해시는 환경마다 다릅니다. 구조와 메시지만 일치하면 정상입니다.

---

## Part A: squash로 커밋 합치기

### Step 1: git log --oneline (합치기 전)

```
$ git log --oneline
a1b2c3d 아 또 수정
e4f5g6h 진짜 수정
i7j8k9l fix typo
m0n1o2p wip
q3r4s5t feat: 장바구니 UI 추가
u6v7w8x init: 프로젝트 초기 설정
```

### Step 2: git log --oneline --stat

```
$ git log --oneline --stat
a1b2c3d 아 또 수정
 cart.js  | 20 ++++++++++++--------
 style.css | 18 ++++++++++++++++++
 2 files changed, 30 insertions(+), 8 deletions(-)

e4f5g6h 진짜 수정
 cart.js | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

i7j8k9l fix typo
 cart.js | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

m0n1o2p wip
 cart.js | 7 +++++++
 1 file changed, 7 insertions(+)

q3r4s5t feat: 장바구니 UI 추가
 cart.html | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

u6v7w8x init: 프로젝트 초기 설정
 app.js     | 22 ++++++++++++++++++++++
 index.html | 21 +++++++++++++++++++++
 style.css  | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)
```

### Step 3: git rebase -i HEAD~4 (에디터 화면)

에디터가 열리면 다음과 같이 보입니다:

```
pick m0n1o2p wip
pick i7j8k9l fix typo
pick e4f5g6h 진짜 수정
pick a1b2c3d 아 또 수정

# Rebase q3r4s5t..a1b2c3d onto q3r4s5t (4 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
```

이것을 다음과 같이 수정합니다:

```
pick m0n1o2p wip
squash i7j8k9l fix typo
squash e4f5g6h 진짜 수정
squash a1b2c3d 아 또 수정
```

### Step 3 (계속): 커밋 메시지 에디터

저장 후 두 번째 에디터가 열립니다:

```
# This is a combination of 4 commits.
# This is the 1st commit message:

wip

# This is the commit message #2:

fix typo

# This is the commit message #3:

진짜 수정

# This is the commit message #4:

아 또 수정
```

모두 지우고 다음과 같이 작성합니다:

```
feat: 장바구니 기능 구현

- 상품을 장바구니에 추가/삭제하는 기능
- 수량 관리 및 총합 계산
- 장바구니 UI 렌더링
```

### Step 4: git log --oneline (합친 후)

```
$ git log --oneline
x9y0z1a feat: 장바구니 기능 구현
q3r4s5t feat: 장바구니 UI 추가
u6v7w8x init: 프로젝트 초기 설정
```

> **핵심 포인트**: 6개 커밋이 3개로 줄었습니다.
> 지저분한 4개 커밋이 의미 있는 1개 커밋으로 합쳐졌습니다.

### Step 5: git show HEAD --stat (합쳐진 커밋)

```
$ git show HEAD --stat
commit x9y0z1a (HEAD -> main)
Author: Your Name <you@example.com>
Date:   ...

    feat: 장바구니 기능 구현

    - 상품을 장바구니에 추가/삭제하는 기능
    - 수량 관리 및 총합 계산
    - 장바구니 UI 렌더링

 cart.js   | 45 +++++++++++++++++++++++++++++++++++++++++++++
 style.css | 18 ++++++++++++++++++
 2 files changed, 63 insertions(+)
```

> 4개 커밋에 나뉘어 있던 변경사항이 하나의 깔끔한 커밋으로 통합되었습니다.

---

## Part B: reword로 메시지만 수정

### Step 7: git rebase -i HEAD~2

```
reword q3r4s5t feat: 장바구니 UI 추가
pick x9y0z1a feat: 장바구니 기능 구현
```

메시지 편집 에디터에서:

```
feat: 장바구니 페이지 HTML 구조 추가
```

결과 확인:

```
$ git log --oneline
b2c3d4e feat: 장바구니 기능 구현
a1b2c3d feat: 장바구니 페이지 HTML 구조 추가
u6v7w8x init: 프로젝트 초기 설정
```

> **주의**: reword 후에는 해당 커밋과 그 이후 커밋의 해시가 모두 변경됩니다.
