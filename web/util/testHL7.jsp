<%@page import="java.nio.file.*"%>
<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="be.openclinic.medical.*,be.openclinic.hl7.*,ca.uhn.hl7v2.*,ca.uhn.hl7v2.parser.*,ca.uhn.hl7v2.util.*,ca.uhn.hl7v2.model.*,ca.uhn.hl7v2.model.v251.message.*,ca.uhn.hl7v2.model.v251.group.*" %>
<%
	String fileContent = "";
	try {
	    byte[] bytes = Files.readAllBytes(Paths.get("/tmp/hl7.msg"));
	    fileContent = new String (bytes);
	} catch (IOException e) {
	    //handle exception
	}
	SH.syslog(fileContent);
	HapiContext context = new DefaultHapiContext();
	Parser p = context.getPipeParser();
	Message message = p.parse(fileContent);
	HL7Sender.send(message, "10.8.0.149", 4001);
	
%>