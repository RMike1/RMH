<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*"%>
<%
String ClientCode=request.getParameter("ClientCode");
String CDate=request.getParameter("CDate");
String CounsellorName=request.getParameter("CounsellorName");
String EntryPoint=request.getParameter("EntryPoint");
String RequestDoctor=request.getParameter("RequestDoctor");
String PreviuosDate=request.getParameter("PreviousDate");
String PreviousResult=request.getParameter("PreviousResult");
String HTEST1=request.getParameter("HTEST1");
String HTEST2=request.getParameter("HTEST2");
String FinalResult=request.getParameter("FinalResult");
String receiveResult=request.getParameter("receiveResult");
String TypeCounselliing=request.getParameter("TypeCounselliing");
String TB=request.getParameter("TB");
String TI=request.getParameter("TI");
String DisclosurePlan=request.getParameter("DisclosurePlan");
String RefferedTo=request.getParameter("RefferedTo");
String OtherRef=request.getParameter("OtherRef");
String SysPatientID=request.getParameter("SysPatientID");
String CounsellerNotes=request.getParameter("CounsellerNotes");
String ConsellerCode=request.getParameter("CounsellerCode");
String Actives=("No");
String NActives=("Yes");
String Done=("Yes");
String c_id=request.getParameter("c_id");
try
{
Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/htc", "root", "rmh@kigali.");
Statement st=conn.createStatement();
//out.println(st);
int y=st.executeUpdate("UPDATE counsellernotes SET Actives='"+Actives+"' where c_id='"+c_id+"' ");
                                
int i=st.executeUpdate("insert into counsellernotes (ClientCode,admissiondate,counsellerName,EntryPoint,RequestingDoctor,PreviousTestDate,PreviousTestResult,HIVTestI,HIVTestII,FinalResult,TypeOfCounselling,TBScreening,STIScreening,ReceivedResult,DisclosurePlan,RefferedTo,OtherRef,SysPatientID,Done,Actives,CounsellerNote,CounsellerCodes)values('"+ClientCode+"','"+CDate+"','"+CounsellorName+"'"
        + ",'"+EntryPoint+"','"+RequestDoctor+"','"+PreviuosDate+"','"+PreviousResult+"','"+HTEST1+"','"+HTEST2+"','"+FinalResult+"','"+TypeCounselliing+"','"+TB+"','"+TI+"','"+receiveResult+"','"+DisclosurePlan+"','"+RefferedTo+"','"+OtherRef+"','"+SysPatientID+"','"+Done+"','"+NActives+"','"+CounsellerNotes+"','"+ConsellerCode+"')");
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
