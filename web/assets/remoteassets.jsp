<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String url=MedwanQuery.getInstance().getConfigString("remoteAssetURL","http://localhost/openclinic/assets/enterAssets.jsp")+"?autologin="+SH.cs("remotelogingmao","")+";"+SH.cs("remotepasswordgmao","");
	SH.syslog("url="+url);
%>
<script>
	window.location.href='<%=url%>';
</script>