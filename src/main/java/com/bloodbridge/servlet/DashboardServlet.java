package com.bloodbridge.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("activeRequests", 24);
        request.setAttribute("urgentRequests", 6);
        request.setAttribute("verifiedBanks", 18);
        request.setAttribute("fulfilledRequests", 42);
        request.setAttribute("requestsFulfilled", 42);
        List<Map<String, String>> requests = new ArrayList<>();
        requests.add(requestRow("BB-2048", "City General Hospital", "O−", "Urgent", "Awaiting response", "urgent"));
        requests.add(requestRow("BB-2047", "Northside Medical Centre", "AB+", "High", "Partially fulfilled", "progress"));
        requests.add(requestRow("BB-2046", "Riverside Clinic", "B+", "Standard", "Matched", "matched"));
        requests.add(requestRow("BB-2045", "Greenfield Hospital", "A−", "High", "Awaiting response", "urgent"));
        requests.add(requestRow("BB-2044", "Central Care Hospital", "O+", "Standard", "Fulfilled", "complete"));
        request.setAttribute("recentRequests", requests);
        List<Map<String, String>> inventory = new ArrayList<>();
        inventory.add(inventoryRow("O−", "12 units", "3 banks", "critical"));
        inventory.add(inventoryRow("O+", "48 units", "8 banks", "healthy"));
        inventory.add(inventoryRow("A−", "19 units", "5 banks", "healthy"));
        inventory.add(inventoryRow("A+", "36 units", "7 banks", "healthy"));
        inventory.add(inventoryRow("B−", "14 units", "4 banks", "healthy"));
        inventory.add(inventoryRow("B+", "27 units", "6 banks", "healthy"));
        inventory.add(inventoryRow("AB−", "8 units", "3 banks", "low"));
        inventory.add(inventoryRow("AB+", "22 units", "5 banks", "healthy"));
        request.setAttribute("inventory", inventory);
        List<Map<String, String>> activity = new ArrayList<>();
        activity.add(activityRow("A new urgent O− request was submitted", "City General Hospital · 8 min ago", "alert"));
        activity.add(activityRow("Request BB-2044 was marked fulfilled", "Central Care Hospital · 32 min ago", "success"));
        activity.add(activityRow("Inventory updated for A+ and B+", "Hope Blood Centre · 1 hr ago", "update"));
        request.setAttribute("activity", activity);
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
    private Map<String, String> requestRow(String id, String hospital, String group, String priority, String status, String style) {
        Map<String, String> row = new LinkedHashMap<>();
        row.put("id", id); row.put("hospital", hospital); row.put("group", group); row.put("priority", priority); row.put("status", status); row.put("style", style);
        return row;
    }
    private Map<String, String> inventoryRow(String group, String units, String banks, String level) {
        Map<String, String> row = new LinkedHashMap<>();
        row.put("group", group); row.put("units", units); row.put("banks", banks); row.put("level", level); return row;
    }
    private Map<String, String> activityRow(String message, String detail, String type) {
        Map<String, String> row = new LinkedHashMap<>();
        row.put("message", message); row.put("detail", detail); row.put("type", type); return row;
    }
}
