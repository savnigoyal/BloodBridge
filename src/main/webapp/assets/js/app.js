"use strict";

document.addEventListener("DOMContentLoaded", () => {
    const sidebar = document.getElementById("sidebar");
    const toggle = document.getElementById("menuToggle");
    const scrim = document.getElementById("sidebarScrim");
    const search = document.getElementById("dashboardSearch");
    const toast = document.getElementById("feedbackToast");
    let toastTimer;

    function closeSidebar() {
        sidebar?.classList.remove("is-open");
        if (toggle) {
            toggle.setAttribute("aria-expanded", "false");
            toggle.setAttribute("aria-label", "Open navigation");
        }
        if (scrim) scrim.hidden = true;
    }

    toggle?.addEventListener("click", () => {
        const isOpen = sidebar.classList.toggle("is-open");
        toggle.setAttribute("aria-expanded", String(isOpen));
        toggle.setAttribute("aria-label", isOpen ? "Close navigation" : "Open navigation");
        if (scrim) scrim.hidden = !isOpen;
    });
    scrim?.addEventListener("click", closeSidebar);

    document.querySelectorAll(".nav-link").forEach(link => {
        link.addEventListener("click", () => {
            document.querySelectorAll(".nav-link").forEach(item => {
                item.classList.remove("active");
                item.removeAttribute("aria-current");
            });
            link.classList.add("active");
            link.setAttribute("aria-current", "page");
            closeSidebar();
        });
    });

    function filterTables(value) {
        const query = value.trim().toLocaleLowerCase();
        document.querySelectorAll(".data-table").forEach(table => {
            let shown = 0;
            table.querySelectorAll("tbody [data-filter-row]").forEach(row => {
                const match = row.textContent.toLocaleLowerCase().includes(query);
                row.hidden = !match;
                if (match) shown++;
            });
            const emptyMessage = table.closest(".table-scroll, .inventory-table-wrap")?.querySelector(".empty-state");
            if (emptyMessage) emptyMessage.hidden = shown !== 0;
        });
    }
    search?.addEventListener("input", () => filterTables(search.value));
    document.addEventListener("keydown", event => {
        if (event.key === "/" && !event.ctrlKey && !event.metaKey && document.activeElement !== search) {
            event.preventDefault();
            search?.focus();
        }
        if (event.key === "Escape") closeSidebar();
    });

    document.querySelectorAll("[data-feedback]").forEach(button => {
        button.addEventListener("click", () => {
            if (!toast) return;
            toast.textContent = button.dataset.feedback || "This is demonstration behavior; no data was saved.";
            toast.hidden = false;
            window.clearTimeout(toastTimer);
            toastTimer = window.setTimeout(() => { toast.hidden = true; }, 4200);
        });
    });
});