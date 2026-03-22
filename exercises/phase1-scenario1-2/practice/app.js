// ShopEasy 메인 애플리케이션
const products = [
    { id: 1, name: '무선 이어폰', price: 45000 },
    { id: 2, name: '노트북 거치대', price: 32000 },
    { id: 3, name: 'USB-C 허브', price: 28000 },
    { id: 4, name: '기계식 키보드', price: 89000 },
];

function renderProducts() {
    const list = document.getElementById('product-list');
    list.innerHTML = products
        .map(p => `
            <div class="product-card">
                <h3>${p.name}</h3>
                <p>${p.price.toLocaleString()}원</p>
                <button onclick="addToCart(${p.id})">장바구니 담기</button>
            </div>
        `)
        .join('');
}

document.addEventListener('DOMContentLoaded', renderProducts);
