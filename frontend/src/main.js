async function loadProgress() {
    const resp = await fetch('/region20/progress/1?term=2025-Fall');
    const data = await resp.json();
    document.getElementById('output').textContent = JSON.stringify(data, null, 2);
}
loadProgress();
