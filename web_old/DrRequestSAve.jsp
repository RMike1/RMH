<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*"%>
<html>
<body bgcolor="#CCFFFF">
<%
int SysPatientID3=Integer.parseInt(request.getParameter("SysPatientID"));
String CDate3=request.getParameter("CDate");

String EntryPoint3=request.getParameter("EntryPoint");
String RequestDoctor3=request.getParameter("RequestDoctor");
String DoctorNotes=request.getParameter("DoctorNotes");
String Actives3=("Yes");
String Done3=("No");

try
{
Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/htc", "root", "rmh@kigali.");
Statement st3=conn.createStatement();
//out.println(st);
int i3=st3.executeUpdate("insert into counsellernotes (SysPatientID,admissiondate,EntryPoint,RequestingDoctor,Actives,Done,DoctorNotes)"
                                 + "values('"+SysPatientID3+"','"+CDate3+"','"+EntryPoint3+"','"+RequestDoctor3+"','"+Actives3+"','"+Done3+"','"+DoctorNotes+"')");
out.println("Data is successfully inserted!");


}
catch(Exception e)
{
 out.println("SQLException caught: " +e.getMessage());
}

%>

 <BR>
       <form method="post" action="main.do?CheckService=true&CheckMedicalCenter=true&ts="+getTs()">
         <div align="center">
              <input type="submit" name="back" value="                 BACK              " />
          </div>
       </form>
</body>

 