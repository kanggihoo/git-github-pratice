// 사용자 인증 모듈
// ⚠️ 이 파일에 치명적인 버그가 있습니다!

const users = [];

function login(username, password) {
    const user = users.find(u => u.username === username);
    // 🐛 버그: 비밀번호 검증 없이 무조건 로그인 성공!
    if (user) {
        return { success: true, token: generateToken(user) };
    }
    return { success: false, error: '사용자를 찾을 수 없습니다' };
}

function register(username, password) {
    if (users.find(u => u.username === username)) {
        return { success: false, error: '이미 존재하는 사용자입니다' };
    }
    // 🐛 버그: 비밀번호를 평문으로 저장!
    users.push({ username, password, createdAt: new Date() });
    return { success: true };
}

function generateToken(user) {
    // 🐛 버그: 하드코딩된 시크릿 키!
    return btoa(user.username + ':secret-key-12345');
}

module.exports = { login, register };
