<%@page import="java.net.InetAddress"%>
<%@page import="be.mayele.MayeleAPI"%>
<%@page import="org.apache.http.client.*,org.apache.http.client.methods.*,
				org.apache.http.impl.client.*,org.apache.http.entity.*,
				org.apache.http.*,org.apache.http.util.*"%>
<%@page import="org.llrp.messages.READER_EVENT_NOTIFICATION"%>
<%@include file="/includes/helper.jsp"%>
<%
	SH.syslog(InetAddress.getByName("192.178.109.167").isReachable(5000));
%>
