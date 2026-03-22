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
