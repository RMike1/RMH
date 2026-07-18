<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<html>
<body bgcolor="#CCFFFF">

<%
String[] c_ids = request.getParameterValues("c_id");

if (c_ids == null || c_ids.length == 0) {
%>
    <div align="center" style="color: red;">
        <strong>No counselor IDs provided.</strong>
    </div>
<%
} else {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/htc", "root", "rmh@kigali.");
%>

    <div align="center">
        <h1>Counsellor Interface</h1>
    </div>

<%
        for (int i = 0; i < c_ids.length; i++) {
            String c_id = c_ids[i];
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM counsellernotes WHERE c_id = ?");
            ps.setString(1, c_id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
%>

    <form method="post" action="process.jsp" style="margin-bottom:30px; border:1px solid #666; padding:10px;">
        <fieldset>
            <legend><b>Counselor Entry for Patient ID: <%= rs.getString("SysPatientID") %> at: <%= rs.getString("EnterDTM") %></b></legend>

            <input type="hidden" name="c_id" value="<%= c_id %>" />

            <table border="1" bgcolor="#CCFFFF" align="center">
                <tbody>
                    <tr>
                        <td bgcolor="#66CCCC" colspan="2">Date</td>
                        <td bgcolor="#66CCCC">System PatientID</td>
                        <td bgcolor="#66CCCC">Client Code</td>
                        <td bgcolor="#66CCCC">Counseller Code</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="text" name="CDate" value="<%= rs.getString(3) %>" size="15" readonly />
                        </td>
                        <td>
                            <input type="text" name="SysPatientID" value="<%= rs.getString(19) %>" size="15" readonly />
                        </td>
                        <td>
                            <input type="text" name="ClientCode" value="" size="15" />
                        </td>
                        <td>
                            <input type="text" name="CounsellerCode" value="" size="15" />
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#66CCCC">Counsellor Name</td>
                        <td bgcolor="#66CCCC">Entry Point</td>
                        <td bgcolor="#66CCCC">Requesting Doctor</td>
                        <td bgcolor="#66CCCC">Previous Test Date</td>
                        <td bgcolor="#66CCCC">Previous Test Result</td>
                    </tr>
                    <tr>
                        <td><input type="text" name="CounsellorName" value="" size="15" /></td>
                        <td><input type="text" name="EntryPoint" value="<%= rs.getString(5) %>" size="15" readonly /></td>
                        <td><input type="text" name="RequestDoctor" value="<%= rs.getString(6) %>" size="15" readonly /></td>
                        <td><input type="text" name="PreviousDate" value="" size="15" /></td>
                        <td><input type="text" name="PreviousResult" value="" size="15" /></td>
                    </tr>
                    <tr>
                        <td bgcolor="#66CCCC">HIV Test 1</td>
                        <td bgcolor="#66CCCC">HIV Test 2</td>
                        <td bgcolor="#66CCCC">Final result</td>
                        <td bgcolor="#66CCCC">Received result</td>
                        <td bgcolor="#66CCCC">Type of counselling</td>
                    </tr>
                    <tr>
                        <td>
                            <select name="HTEST1">
                                <option></option>
                                <option value="Reactive">Reactive</option>
                                <option value="No Reactive">No Reactive</option>
                                <option value="Indetermine">Indetermine</option>
                            </select>
                        </td>
                        <td>
                            <select name="HTEST2">
                                <option></option>
                                <option value="Reactive">Reactive</option>
                                <option value="No Reactive">No Reactive</option>
                                <option value="Indetermine">Indetermine</option>
                            </select>
                        </td>
                        <td>
                            <select name="FinalResult">
                                <option></option>
                                <option value="Positive">Positive</option>
                                <option value="Negative">Negative</option>
                                <option value="Indetermine">Indetermine</option>
                            </select>
                        </td>
                        <td>
                            <select name="receiveResult">
                                <option></option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </td>
                        <td>
                            <select name="TypeCounselliing">
                                <option></option>
                                <option value="Individuel">Individuel</option>
                                <option value="Accompagne">Accompagne</option>
                                <option value="Couple">Couple</option>
                                <option value="PMTCT">PMTCT</option>
                                <option value="Preop">Preop</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#66CCCC">TB Screening</td>
                        <td bgcolor="#66CCCC">STI Screening</td>
                        <td bgcolor="#66CCCC">Disclosure plan</td>
                        <td bgcolor="#66CCCC">Reffered to</td>
                        <td bgcolor="#66CCCC"></td>
                    </tr>
                    <tr>
                        <td>
                            <select name="TB">
                                <option></option>
                                <option value="TB">TB</option>
                                <option value="NTB">NTB</option>
                            </select>
                        </td>
                        <td>
                            <select name="TI">
                                <option></option>
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                            </select>
                        </td>
                        <td>
                            <select name="DisclosurePlan">
                                <option></option>
                                <option value="Spouse">Spouse</option>
                                <option value="Mother">Mother</option>
                                <option value="Father">Father</option>
                                <option value="Friend">Friend</option>
                            </select>
                        </td>
                        <td>
                            <select name="RefferedTo">
                                <option></option>
                                <option value="RMH ARV">RMH ARV</option>
                                <option value="Other HC">Other HC</option>
                                <option value="Other">Other</option>
                            </select>
                            <input type="text" name="OtherRef" value="" size="15" />
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Notes from Doctor</td>
                        <td colspan="2">
                            <textarea name="DoctorNotes" rows="4" cols="20" readonly><%= rs.getString(20) %></textarea>
                        </td>
                        <td>Counsellor Notes</td>
                        <td colspan="2">
                            <textarea name="CounsellerNotes" rows="4" cols="20"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div align="center" style="margin-top:10px;">
                <input type="submit" name="save" value="Save This Entry" />
            </div>
        </fieldset>
    </form>

<%
            } else {
%>
    <div style="color:red; margin-bottom:20px;" align="center">
        No counselor note found for c_id: <%= c_id %>
    </div>
<%
            }
            rs.close();
            ps.close();
        }
        conn.close();
    } catch (Exception e) {
%>
    <div align="center" style="color: red;">
        <strong>Error:</strong> <%= e.getMessage() %>
    </div>
<%
        e.printStackTrace();
    }
}
%>

<br>
</body>
</html>
