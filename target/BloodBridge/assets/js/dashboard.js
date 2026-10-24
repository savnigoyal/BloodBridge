"use strict";
document.addEventListener("DOMContentLoaded", () => {
    const search = document.getElementById("requestSearch");
    const body = document.getElementById("requestRows");
    const empty = document.getElementById("emptyMessage");
    const toggle = document.getElementById("menuToggle");
    const sidebar = document.getElementById("sidebar");
    if (search && body && empty) {
        const rows = Array.from(body.querySelectorAll("tr"));
        search.addEventListener("input", () => {
            const query = search.value.trim().toLocaleLowerCase();
            let count = 0;
            rows.forEach(row => {
                const matches = row.textContent.toLocaleLowerCase().includes(query);
                row.hidden = !matches;
                if (matches) count++;
            });
            empty.hidden = count !== 0;
        });
        document.addEventListener("keydown", event => {
            if (event.key === "/" && !event.ctrlKey && !event.metaKey && document.activeElement !== search) {
                event.preventDefault(); search.focus();
            }
        });
    }
    if (toggle && sidebar) {
        toggle.addEventListener("click", () => {
            const open = sidebar.classList.toggle("open");
            toggle.setAttribute("aria-expanded", String(open));
        });
        sidebar.querySelectorAll(".nav-item").forEach(link => link.addEventListener("click", () => {
            sidebar.classList.remove("open"); toggle.setAttribute("aria-expanded", "false");
        }));
    }
});
