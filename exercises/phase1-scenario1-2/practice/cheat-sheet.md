# 📌 Scenario 1.2 명령어 요약 카드

## 핵심 명령어

| 명령어 | 설명 | 예시 |
|--------|------|------|
| `git log --oneline` | 커밋 히스토리 한 줄 요약 | `git log --oneline` |
| `git log --oneline --stat` | 커밋별 변경 파일 목록 포함 | `git log --oneline --stat` |
| `git show <커밋>` | 특정 커밋의 변경 내용 보기 | `git show HEAD` |
| `git rebase -i HEAD~N` | 최근 N개 커밋 인터랙티브 리베이스 | `git rebase -i HEAD~4` |
| `git rebase --abort` | 리베이스 취소 (원래 상태 복구) | `git rebase --abort` |
| `git rebase --continue` | 리베이스 계속 진행 | 충돌 해결 후 사용 |

## 리베이스 에디터 명령어

| 명령어 | 약어 | 설명 |
|--------|:---:|------|
| `pick` | p | 커밋을 그대로 유지 |
| `reword` | r | 커밋 유지, **메시지만** 수정 |
| `squash` | s | 바로 위 커밋에 합치기 (메시지 편집) |
| `fixup` | f | 바로 위 커밋에 합치기 (메시지 버리기) |
| `edit` | e | 커밋에서 일시 정지 (내용 수정 가능) |
| `drop` | d | 커밋 삭제 |

## 에디터 기본 조작

### vim
| 키 | 동작 |
|---|------|
| `i` | 편집 모드 진입 |
| `Esc` | 편집 모드 종료 |
| `:wq` | 저장하고 종료 |
| `:q!` | 저장 안 하고 종료 |

### nano
| 키 | 동작 |
|---|------|
| (바로 입력) | 편집 모드 |
| `Ctrl+X` | 종료 |
| `Y` | 저장 확인 |

### 에디터 변경
```bash
git config --global core.editor "nano"     # nano 사용
git config --global core.editor "code --wait"  # VS Code 사용
```

## 핵심 요약

```
squash 규칙:
  - 첫 번째 줄은 반드시 pick
  - squash는 바로 위의 pick에 합쳐짐
  - 실수하면 --abort로 취소 가능
```
