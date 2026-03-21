// TaskFlow 메인 애플리케이션
const tasks = [];

function addTask() {
    const input = document.getElementById('task-input');
    const text = input.value.trim();
    if (text) {
        tasks.push({ id: Date.now(), text, done: false });
        input.value = '';
        renderTasks();
    }
}

function toggleTask(id) {
    const task = tasks.find(t => t.id === id);
    if (task) {
        task.done = !task.done;
        renderTasks();
    }
}

function renderTasks() {
    const list = document.getElementById('tasks');
    list.innerHTML = tasks
        .map(t => `<li class="${t.done ? 'done' : ''}" onclick="toggleTask(${t.id})">${t.text}</li>`)
        .join('');
}
