// DevNote 메인 애플리케이션
const notes = [
    { id: 1, title: 'Git 학습 메모', content: 'revert와 reset의 차이점...' },
    { id: 2, title: 'JS 비동기 패턴', content: 'Promise, async/await...' },
    { id: 3, title: '코드 리뷰 체크리스트', content: '변수명, 에러 처리...' },
];

function renderNotes() {
    const list = document.getElementById('note-list');
    list.innerHTML = notes
        .map(n => `
            <div class="note-card">
                <h3>${n.title}</h3>
                <p>${n.content}</p>
            </div>
        `)
        .join('');
}

document.addEventListener('DOMContentLoaded', renderNotes);
