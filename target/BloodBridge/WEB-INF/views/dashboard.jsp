<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#451322">
    <title>Overview | BloodBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="${pageContext.request.contextPath}/assets/js/app.js" defer></script>
</head>
<body>
<div class="app-shell">
    <div class="sidebar-scrim" id="sidebarScrim" hidden></div>
    <aside class="sidebar" id="sidebar" aria-label="Main navigation">
        <a class="brand" href="#overview" aria-label="BloodBridge overview">
            <span class="brand-mark" aria-hidden="true">+</span>
            <span class="brand-copy"><strong>BloodBridge</strong><small>Care, connected.</small></span>
        </a>
        <p class="nav-label">WORKSPACE</p>
        <nav class="side-nav">
            <a class="nav-link active" href="#overview" aria-current="page"><span class="nav-icon">&#9635;</span>Overview</a>
            <a class="nav-link" href="#inventory"><span class="nav-icon">&#9906;</span>Find Blood</a>
            <a class="nav-link" href="#requests"><span class="nav-icon">&#9776;</span>Emergency Requests<span class="nav-count"><c:out value="${urgentRequests}"/></span></a>
            <a class="nav-link" href="#inventory"><span class="nav-icon">&#9678;</span>Blood Inventory</a>
            <a class="nav-link" href="#allocations"><span class="nav-icon">&#8644;</span>Allocations</a>
            <a class="nav-link" href="#notifications"><span class="nav-icon">&#9825;</span>Notifications<span class="nav-dot" aria-label="New activity"></span></a>
            <a class="nav-link" href="#reports"><span class="nav-icon">&#9638;</span>Reports</a>
            <a class="nav-link" href="#audit"><span class="nav-icon">&#9711;</span>Audit Logs</a>
            <a class="nav-link" href="#settings"><span class="nav-icon">&#9881;</span>Settings</a>
        </nav>
        <div class="sidebar-bottom">
            <div class="demo-note"><span class="online-dot"></span><div><strong>Demo workspace</strong><small>Fictional sample data</small></div></div>
            <button class="profile profile-button" type="button" data-feedback="Demo profile: Riya Sharma, Hospital Staff. Account settings are not connected yet." aria-label="Show demo profile details">
                <span class="avatar">RS</span><span class="profile-copy"><strong>Riya Sharma</strong><small>Hospital staff</small></span><span class="profile-more" aria-hidden="true">•••</span>
            </button>
        </div>
    </aside>

    <main class="main-content" id="overview">
        <header class="topbar">
            <div class="topbar-start">
                <button class="menu-toggle" id="menuToggle" type="button" aria-label="Open navigation" aria-expanded="false" aria-controls="sidebar"><span></span><span></span><span></span></button>
                <div class="breadcrumb">Workspace <span>/</span> <strong>Overview</strong></div>
            </div>
            <div class="topbar-actions">
                <label class="global-search"><span aria-hidden="true">&#9906;</span><input id="dashboardSearch" type="search" placeholder="Search dashboard" aria-label="Search requests and inventory"><kbd>/</kbd></label>
                <button class="icon-button notification-button" type="button" data-feedback="Notifications shown here are fictional demo activity." aria-label="Show demo notifications">&#9825;<span class="notification-dot"></span></button>
                <span class="top-avatar" aria-hidden="true">RS</span>
            </div>
        </header>

        <div class="page-wrap">
            <section class="welcome-row">
                <div><p class="eyebrow">BLOODBRIDGE NETWORK <span class="eyebrow-line"></span> DEMO OVERVIEW</p><h1>Good morning, Riya <span class="wave" aria-hidden="true">✦</span></h1><p class="welcome-copy">A clearer view of requests and availability across your network.</p></div>
                <button class="button button-primary" type="button" data-feedback="Request creation is planned for a later phase. No request was saved."><span aria-hidden="true">＋</span> Create request</button>
            </section>

            <section class="stats-grid" id="reports" aria-label="Network statistics">
                <article class="stat-card"><div class="stat-heading"><span>Active Requests</span><span class="stat-icon icon-burgundy" aria-hidden="true">&#8599;</span></div><p class="stat-value"><c:out value="${activeRequests}"/></p><p class="stat-note"><span class="trend">+12%</span> compared with last week</p><span class="stat-decoration decoration-one" aria-hidden="true"></span></article>
                <article class="stat-card"><div class="stat-heading"><span>Urgent Requests</span><span class="stat-icon icon-red" aria-hidden="true">!</span></div><p class="stat-value"><c:out value="${urgentRequests}"/></p><p class="stat-note"><span class="attention">Needs attention</span> across the network</p><span class="stat-decoration decoration-two" aria-hidden="true"></span></article>
                <article class="stat-card"><div class="stat-heading"><span>Verified Blood Banks</span><span class="stat-icon icon-green" aria-hidden="true">&#10003;</span></div><p class="stat-value"><c:out value="${verifiedBanks}"/></p><p class="stat-note"><span class="trend">+2</span> added this month</p><span class="stat-decoration decoration-three" aria-hidden="true"></span></article>
                <article class="stat-card"><div class="stat-heading"><span>Requests Fulfilled</span><span class="stat-icon icon-gold" aria-hidden="true">&#9825;</span></div><p class="stat-value"><c:out value="${requestsFulfilled}"/></p><p class="stat-note"><span class="trend">+8.4%</span> this quarter</p><span class="stat-decoration decoration-four" aria-hidden="true"></span></article>
            </section>

            <section class="dashboard-grid" aria-label="Dashboard details">
                <article class="panel requests-panel" id="requests">
                    <div class="panel-heading"><div><p class="section-kicker">NEEDS YOUR ATTENTION</p><h2>Urgent blood requests</h2><p class="panel-subtitle">Fictional requests from the demonstration network</p></div><a class="text-link" href="#allocations">View allocation status <span aria-hidden="true">&#8594;</span></a></div>
                    <div class="table-scroll"><table class="data-table" id="requestTable"><caption class="visually-hidden">Fictional emergency blood requests</caption><thead><tr><th scope="col">REQUEST</th><th scope="col">HOSPITAL</th><th scope="col">GROUP</th><th scope="col">PRIORITY</th><th scope="col">STATUS</th><th scope="col"><span class="visually-hidden">Action</span></th></tr></thead><tbody>
                    <c:forEach var="item" items="${recentRequests}"><tr data-filter-row><td class="request-id"><c:out value="${item['id']}"/></td><td class="hospital-name"><c:out value="${item['hospital']}"/></td><td><span class="blood-type"><c:out value="${item['group']}"/></span></td><td><span class="priority"><i class="priority-dot ${item['style']}" aria-hidden="true"></i><c:out value="${item['priority']}"/></span></td><td><span class="status-badge ${item['style']}"><c:out value="${item['status']}"/></span></td><td><button class="row-action" type="button" data-feedback="Request ${item['id']} is fictional sample data; details are not available in this phase." aria-label="Show demo details for request ${item['id']}">&#8599;</button></td></tr></c:forEach>
                    </tbody></table><p class="empty-state" id="requestEmpty" hidden>No matching requests. Try a different search.</p></div>
                    <div class="table-footnote"><span aria-hidden="true">&#9432;</span> These records are synthetic and do not represent real requests.</div>
                </article>

                <article class="panel inventory-panel" id="inventory">
                    <div class="panel-heading"><div><p class="section-kicker">NETWORK AVAILABILITY</p><h2>Blood inventory</h2><p class="panel-subtitle">Sample units at fictional verified banks</p></div><button class="text-link-button" type="button" data-feedback="Inventory values are synthetic demonstration data; no live stock system is connected.">View details <span aria-hidden="true">&#8594;</span></button></div>
                    <div class="inventory-table-wrap"><table class="data-table inventory-table"><caption class="visually-hidden">Fictional blood inventory by blood group</caption><thead><tr><th scope="col">GROUP</th><th scope="col">UNITS</th><th scope="col">BANKS</th><th scope="col">LEVEL</th></tr></thead><tbody>
                    <c:forEach var="item" items="${inventory}"><tr data-filter-row><td><span class="blood-type"><c:out value="${item['group']}"/></span></td><td class="unit-count"><c:out value="${item['units']}"/></td><td><c:out value="${item['banks']}"/></td><td><span class="inventory-status ${item['level']}"><i aria-hidden="true"></i><c:choose><c:when test="${item['level'] == 'critical'}">Critical</c:when><c:when test="${item['level'] == 'low'}">Low</c:when><c:otherwise>Available</c:otherwise></c:choose></span></td></tr></c:forEach>
                    </tbody></table><p class="empty-state inventory-empty" hidden>No matching inventory groups.</p></div>
                    <div class="inventory-legend"><span><i class="legend-dot healthy"></i>Available</span><span><i class="legend-dot low"></i>Low</span><span><i class="legend-dot critical"></i>Critical</span></div>
                </article>

                <article class="panel activity-panel" id="notifications">
                    <div class="panel-heading"><div><p class="section-kicker">LATEST UPDATES</p><h2>Recent activity</h2><p class="panel-subtitle">A sample timeline for this demo</p></div><a class="text-link" href="#audit">Audit trail <span aria-hidden="true">&#8594;</span></a></div>
                    <div class="timeline" id="audit"><c:forEach var="item" items="${activity}"><div class="timeline-item"><span class="timeline-icon ${item['type']}" aria-hidden="true"><c:choose><c:when test="${item['type'] == 'alert'}">!</c:when><c:when test="${item['type'] == 'success'}">&#10003;</c:when><c:otherwise>&#8635;</c:otherwise></c:choose></span><div><strong><c:out value="${item['message']}"/></strong><small><c:out value="${item['detail']}"/></small></div></div></c:forEach></div>
                    <p class="table-footnote">Activity shown is fictional; no real notification was sent.</p>
                </article>

                <article class="action-card" id="allocations"><span class="action-orb" aria-hidden="true">+</span><p class="action-kicker">COORDINATE CARE</p><h2>Every connection<br>can make a difference.</h2><p>Review the sample requests and follow their displayed status.</p><a class="action-button" href="#requests">Review requests <span aria-hidden="true">&#8594;</span></a><p class="action-disclaimer">Demonstration only · Not for clinical use</p></article>
            </section>
            <footer class="page-footer" id="settings"><span>BloodBridge <b>·</b> Coordination made clearer</span><span>Demo only. Decisions belong to authorized professionals.</span></footer>
        </div>
    </main>
</div>
<div class="toast" id="feedbackToast" role="status" aria-live="polite" hidden></div>
</body>
</html>