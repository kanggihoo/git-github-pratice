#!/bin/bash
# ══════════════════════════════════════════════════════════════
# 초기 환경 구성 스크립트
# Phase 1 - Scenario 1.2: 커밋 메시지 수정 및 쪼개기/합치기
# ══════════════════════════════════════════════════════════════
# 이 스크립트를 실행하면 다음과 같은 환경이 만들어집니다:
#
# [Git 히스토리] (총 6개 커밋)
#   1. init: 프로젝트 초기 설정          (기본 파일들)
#   2. feat: 장바구니 UI 추가            (cart.html 추가)
#   3. wip                              ← 지저분한 커밋 시작
#   4. fix typo                         ←
#   5. 진짜 수정                         ←
#   6. 아 또 수정                        ← 지저분한 커밋 끝
#
# 학습자 미션: 커밋 3~6을 의미 있는 1개 커밋으로 합치기
# ══════════════════════════════════════════════════════════════

set -e

# ─── [사전 체크] ──────────────────────────────────────
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ 오류: 이미 Git 저장소 안에 있습니다!"
    echo "   빈 폴더에서 실행해주세요."
    echo "   예: mkdir workspace && cd workspace && bash ../setup-script.sh"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Scenario 1.2 실습 환경을 구성합니다..."
echo ""

# ─── [Git 저장소 초기화] ──────────────────────────────
git init --quiet
git branch -M main

# ─── [Commit 1: 프로젝트 초기 설정] ──────────────────
cp "$SCRIPT_DIR/project-files/index.html" .
cp "$SCRIPT_DIR/project-files/app.js" .
cp "$SCRIPT_DIR/project-files/style.css" .
git add .
git commit -m "init: 프로젝트 초기 설정" --quiet

# ─── [Commit 2: 장바구니 UI 추가] ────────────────────
# 이 커밋은 깔끔한 커밋입니다. 건드리지 않습니다.
cat > cart.html << 'HTML'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ShopEasy - 장바구니</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>ShopEasy</h1>
        <nav>
            <a href="/">상품 목록</a>
            <a href="/cart">장바구니</a>
        </nav>
    </header>
    <main>
        <h2>장바구니</h2>
        <div id="cart-items"></div>
        <div id="cart-total"></div>
    </main>
    <script src="cart.js"></script>
</body>
</html>
HTML
git add cart.html
git commit -m "feat: 장바구니 UI 추가" --quiet

# ─── [Commit 3: wip (지저분한 커밋 1)] ───────────────
# 장바구니 JS 파일 초안
cat > cart.js << 'JS'
// 장바구니 기능
const cart = [];

function addToCart(productId) {
    cart.push(productId);
    console.log('added');  // 임시 디버그 코드
}
JS
git add cart.js
git commit -m "wip" --quiet

# ─── [Commit 4: fix typo (지저분한 커밋 2)] ──────────
# 오타 수정 + 기능 보완
cat > cart.js << 'JS'
// 장바구니 기능
const cart = [];

function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    if (product) {
        cart.push(product);
        console.log('added: ' + product.name);  // 임시 디버그 코드
        renderCart();
    }
}

function renderCart() {
    // TODO: 구현 필요
}
JS
git add cart.js
git commit -m "fix typo" --quiet

# ─── [Commit 5: 진짜 수정 (지저분한 커밋 3)] ────────
# renderCart 구현 + 디버그 코드 일부 제거
cat > cart.js << 'JS'
// 장바구니 기능
const cart = [];

function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    if (product) {
        cart.push({ ...product, quantity: 1 });
        renderCart();
    }
}

function renderCart() {
    const container = document.getElementById('cart-items');
    container.innerHTML = cart
        .map(item => `
            <div class="cart-item">
                <span>${item.name}</span>
                <span>${item.price.toLocaleString()}원</span>
                <button onclick="removeFromCart(${item.id})">삭제</button>
            </div>
        `)
        .join('');
}
JS
git add cart.js
git commit -m "진짜 수정" --quiet

# ─── [Commit 6: 아 또 수정 (지저분한 커밋 4)] ────────
# 총합 계산 추가 + 삭제 기능 구현
cat > cart.js << 'JS'
// 장바구니 기능
const cart = [];

function addToCart(productId) {
    const product = products.find(p => p.id === productId);
    if (product) {
        const existing = cart.find(item => item.id === productId);
        if (existing) {
            existing.quantity += 1;
        } else {
            cart.push({ ...product, quantity: 1 });
        }
        renderCart();
    }
}

function removeFromCart(productId) {
    const index = cart.findIndex(item => item.id === productId);
    if (index > -1) {
        cart.splice(index, 1);
        renderCart();
    }
}

function renderCart() {
    const container = document.getElementById('cart-items');
    container.innerHTML = cart
        .map(item => `
            <div class="cart-item">
                <span>${item.name} x${item.quantity}</span>
                <span>${(item.price * item.quantity).toLocaleString()}원</span>
                <button onclick="removeFromCart(${item.id})">삭제</button>
            </div>
        `)
        .join('');

    const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
    document.getElementById('cart-total').innerHTML =
        `<h3>총합: ${total.toLocaleString()}원</h3>`;
}
JS

# cart 관련 스타일도 추가
cat >> style.css << 'CSS'

/* 장바구니 스타일 */
.cart-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.75rem;
    border-bottom: 1px solid #eee;
}

.product-card {
    background: white;
    border-radius: 8px;
    padding: 1.5rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    text-align: center;
}

.product-card button {
    margin-top: 1rem;
    padding: 0.5rem 1rem;
    background-color: #e74c3c;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
CSS
git add cart.js style.css
git commit -m "아 또 수정" --quiet

echo ""
echo "✅ 환경 구성 완료!"
echo ""
echo "📋 현재 Git 히스토리:"
git log --oneline
echo ""
echo "⚠️  커밋 히스토리가 지저분합니다!"
echo "   'wip', 'fix typo', '진짜 수정', '아 또 수정' 커밋을"
echo "   의미 있는 커밋으로 정리하세요."
echo ""
echo "🎯 미션: interactive rebase로 커밋을 합치고 메시지를 수정하세요!"
echo "   exercise-guide.md를 참고하여 실습을 시작하세요."
