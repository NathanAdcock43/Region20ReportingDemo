// For production (packaged into Spring Boot), leave BASE as "/region20"
// For EC2 local dev: set VITE_API_BASE in frontend/.env to "http://<EC2-IP>:8080/region20"
const BASE = import.meta.env.VITE_API_BASE || "/region20";

function setText(el, val) {
    el.textContent = typeof val === "string" ? val : JSON.stringify(val, null, 2);
}
function qs(sel) { return document.querySelector(sel); }
function fmtPct(v) {
    const n = Number(v);
    return Number.isFinite(n) ? n.toFixed(2) : "";
}

async function postScore(evt) {
    evt.preventDefault();
    const studentId    = Number(qs("#studentId").value);
    const assessmentId = Number(qs("#assessmentId").value);
    const earned       = Number(qs("#earned").value);
    const possible     = Number(qs("#possible").value);

    const url = `${BASE}/score?studentId=${studentId}&assessmentId=${assessmentId}&earned=${earned}&possible=${possible}`;
    try {
        const r = await fetch(url, { method: "POST" });
        if (!r.ok) throw new Error(await r.text());
        const result = await r.json();

        // API returns: { "course_grade_pct": <big decimal> }
        const pct = fmtPct(result.course_grade_pct);
        setText(qs("#scoreResult"), pct ? `Course Grade %: ${pct}` : "No percentage returned");
    } catch (err) {
        setText(qs("#scoreResult"), `Error: ${String(err)}`);
    }
}

function renderProgressTable(rows) {
    const tbody = qs("#progressBody");
    tbody.innerHTML = "";

    if (!Array.isArray(rows) || rows.length === 0) {
        tbody.innerHTML = `<tr><td colspan="2" class="muted">No rows</td></tr>`;
        return;
    }

    for (const row of rows) {
        const tr = document.createElement("tr");
        tr.innerHTML = `
      <td>${row.course_name ?? ""}</td>
      <td>${fmtPct(row.grade_pct)}</td>
    `;
        tbody.appendChild(tr);
    }
} // <-- missing brace added

async function loadProgress(evt) {
    evt.preventDefault();
    const studentId = Number(qs("#pStudentId").value);
    const term = qs("#term").value.trim();
    const url = `${BASE}/progress/${studentId}?term=${encodeURIComponent(term)}`;
    try {
        const r = await fetch(url);
        if (!r.ok) throw new Error(await r.text());
        const data = await r.json();
        renderProgressTable(data);
        setText(qs("#progressRaw"), data);
    } catch (err) {
        setText(qs("#progressRaw"), { ok: false, error: String(err) });
    }
}

document.addEventListener("DOMContentLoaded", () => {
    qs("#scoreForm").addEventListener("submit", postScore);
    qs("#progressForm").addEventListener("submit", loadProgress);
});
