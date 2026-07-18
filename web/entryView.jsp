<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Counselor Notes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        body {
            background: linear-gradient(135deg, #CCFFFF 0%, #E6F7FF 100%);
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 30px 0;
            color: #003366;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 91, 153, 0.2);
            border: 2px solid #66CCCC;
            padding: 30px 40px;
            font-size: 16px;
        }

        h1 {
            text-align: center;
            font-size: 32px;
            margin-bottom: 35px;
            border-bottom: 3px solid #66CCCC;
            padding-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        table, th, td {
            border: 1px solid #66CCCC;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
            font-size: 18px;
            color: #003366;
        }

        tr:nth-child(even) {
            background-color: #f0fbff;
        }

        input[type="checkbox"] {
            transform: scale(1.3);
            margin-right: 10px;
            cursor: pointer;
        }

        .btn-container {
            text-align: center;
            margin-top: 20px;
        }

        input[type="submit"] {
            background: linear-gradient(135deg, #005B99, #003366);
            color: white;
            border: none;
            padding: 15px 50px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 0 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
            min-width: 140px;
        }

        input[type="submit"]:hover {
            background: linear-gradient(135deg, #004070, #002244);
            box-shadow: 0 8px 20px rgba(0, 91, 153, 0.3);
            transform: translateY(-2px);
        }

        .message {
            font-size: 20px;
            text-align: center;
            margin: 40px 0;
            color: #555555;
        }

        .error {
            color: #cc0000;
            font-weight: bold;
            font-size: 18px;
            text-align: center;
            margin-top: 30px;
        }

        @media (max-width: 768px) {
            .container {
                width: 90%;
                padding: 20px 20px;
            }

            input[type="submit"] {
                width: 100%;
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Counselor Notes</h1>

<%
String SysPatientID1 = request.getParameter("SysPatientID");
String Done1 = "No";
String Actives1 = "Yes";

boolean found = false;

try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/htc", "root", "rmh@kigali.");
    Statement st1 = conn.createStatement();

    ResultSet resultset1 = st1.executeQuery(
        "SELECT * FROM counsellernotes WHERE SysPatientID='" + SysPatientID1 + 
        "' AND Done='" + Done1 + "' AND Actives='" + Actives1 + "'");

    if (resultset1 != null) {
%>
    <form method="post" action="PsychologistForm.jsp">
        <table>
            <tbody>
<%
        while (resultset1.next()) {
            found = true;
%>
                <tr>
                    <td>
                        <input name="c_id" type="checkbox" value="<%= resultset1.getString(1) %>" />

                        <%= resultset1.getString(25) %>
                    </td>
                </tr>
<%
        }
%>
            </tbody>
        </table>

        <div class="btn-container">
            <input type="submit" name="save" value="VIEW" />
        </div>
    </form>
<%
    }

    if (!found) {
%>
    <div class="message">
        No active counselor notes found for this patient.
    </div>
<%
    }

    resultset1.close();
    st1.close();
    conn.close();
} catch (Exception e) {
%>
    <div class="error">
        SQLException caught: <%= e.getMessage() %>
    </div>
<%
}
%>

    <form method="post" action="main.do?CheckService=true&CheckMedicalCenter=true">
        <div class="btn-container">
            <input type="submit" name="back" value="BACK" />
        </div>
    </form>
</div>

</body>
</html>
