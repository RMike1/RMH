<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String dbUrl = "jdbc:mysql://localhost:3306/htc";
    String dbUser = "root";
    String dbPassword = "rmh@kigali.";

    String clientCode = request.getParameter("ClientCode");
    String cDate = request.getParameter("CDate");
    String actives = "Yes";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Counsellor Notes</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f8fb;
            margin: 0;
            padding: 20px;
        }

        h3 {
            text-align: center;
            color: #0077aa;
            margin-bottom: 20px;
        }

        table {
            width: 95%;
            margin: 0 auto 30px;
            border-collapse: collapse;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            background-color: white;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
            font-size: 14px;
        }

        th {
            background-color: #0077aa;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f0f8ff;
        }

        tr:hover {
            background-color: #e6f7ff;
        }

        .error {
            color: red;
            text-align: center;
            font-weight: bold;
        }

        .back-link img {
            width: 36px;
            height: 36px;
        }

        .no-data {
            text-align: center;
            color: red;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>

<%
    if (clientCode == null || clientCode.trim().isEmpty()) {
%>
    <p class="error">Missing client code. Please go back and enter a valid code.</p>
<%
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            String query = "SELECT * FROM counsellernotes WHERE SysPatientID = ? AND Actives = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, clientCode);
            ps.setString(2, actives);
            rs = ps.executeQuery();

            boolean hasData = false;
%>

    <h3>Counsellor Notes</h3>
    <table>
        <tr>
            <th>Date</th>
            <th>System PatientID</th>
            <th>Client Code</th>
            <th>Counsellor Name</th>
            <th>Entry Point</th>
            <th>Counsellor Code</th>
            <th>Requesting Doctor</th>
            <th>Doctor Notes</th>
            <th>Counselling Notes</th>
            <th>Previous Test Date</th>
            <th>Previous Test Result</th>
            <th>HIV Test 1</th>
            <th>HIV Test 2</th>
            <th>Final Result</th>
            <th>Received Result</th>
            <th>Type of Counselling</th>
            <th>TB Screening</th>
            <th>STI Screening</th>
            <th>Disclosure Plan</th>
            <th>Referred To</th>
            <th>Back</th>
        </tr>
<%
        while (rs.next()) {
            hasData = true;
%>
        <tr>
            <td><%= rs.getString(3) %></td>
            <td><%= rs.getString(19) %></td>
            <td><%= rs.getString(2) %></td>
            <td><%= rs.getString(4) %></td>
            <td><%= rs.getString(5) %></td>
            <td><%= rs.getString(22) %></td>
            <td><%= rs.getString(6) %></td>
            <td><%= rs.getString(20) %></td>
            <td><%= rs.getString(21) %></td>
            <td><%= rs.getString(7) %></td>
            <td><%= rs.getString(8) %></td>
            <td><%= rs.getString(9) %></td>
            <td><%= rs.getString(10) %></td>
            <td><%= rs.getString(11) %></td>
            <td><%= rs.getString(14) %></td>
            <td><%= rs.getString(12) %></td>
            <td><%= rs.getString(13) %></td>
            <td><%= rs.getString(15) %></td>
            <td><%= rs.getString(16) %></td>
            <td><%= rs.getString(17) %></td>
            <td class="back-link">
                <a href="index.jsp">
                    <img src="smiley.gif" alt="Back">
                </a>
            </td>
        </tr>
<%
        }

        if (!hasData) {
%>
        <tr>
            <td colspan="21" class="no-data">No counselling records found for the given client code.</td>
        </tr>
<%
        }
%>
    </table>
<%
        } catch (Exception e) {
%>
    <p class="error">An error occurred while fetching data. Please try again later.</p>
    <% e.printStackTrace(); %>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
%>

</body>
</html>
