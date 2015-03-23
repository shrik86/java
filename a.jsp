<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="tripsketch.core.TcmsConfig"%>
<%@page import="tripsketch.connection.SlideConnection"%>
<%@page import="tripsketch.content.SlideFile"%>
<%@page import="tripsketch.user.User"%>

<%@ page import="org.apache.webdav.lib.WebdavResource"%>

<%

response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
response.setHeader("Cache-Control", "private"); // HTTP 1.1
response.setHeader("Expires", "-1"); //Causes the proxy cache to see the page as "stale"
response.addHeader("Cache-control", "max-age=0");
response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility
response.setHeader("Cache-Control", "max-stale=0"); // HTTP 1.1
response.setHeader("Cache-Control","must-revalidate"); 
response.setHeader("Cache-Control","proxy-revalidate");

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>TripSketch</title>
<LINK href="resource/TCMS.css" type="text/css" rel="stylesheet">
<LINK href="resource/BACKGROUND.CSS" type="text/css" rel="stylesheet">

<script type="text/javascript" src="resource/AlertMessage.js"></script>

<script type="text/javascript">

	function checkForm() {
	 
	   var iChars = "^([a-zA-Z|0-9|\-|\_|\ ]*)";
		
		var objRegExp = new RegExp(iChars, 'gi');
	
		if(objRegExp.test(document.templateForm.txtFile.value)==false || document.templateForm.txtFile.value == ""){
				alert ("Please enter only alphabets, numbers, underscore, hyphen and space for file name!");
				document.templateForm.txtFile.focus();
				
		} else {

	  	    if(document.templateForm.template.value == "" ) {
		 	
		 		alert("Please select a template!")
		 		
		 		document.templateForm.template.focus()
		 		
		 	
		 	} else {
		 		
		 		document.templateForm.submit();
		 	}
		 	
		 }
	 
	 }


</script>

</head>

<%

	String userPassword = new User().getPassword(session.getAttribute("user").toString());
	
	WebdavResource wdr = new SlideConnection(session.getAttribute("user").toString(), userPassword).getResource(TcmsConfig.templatepath);
	
	WebdavResource[] templates = new SlideFile(session.getAttribute("user").toString(), userPassword).sortFileResources(wdr);
	
	if(wdr != null) {
		wdr.close();
	}
	
%>

<body onload="javascript:window.history.forward(1);javascript:document.templateForm.txtFile.focus();">

<div>

<%
    
	String folder = request.getParameter("folder");
	
%>

<form action="TemplateHandler?path=<%=folder%>&mode=create" method="post" name="templateForm" id="templateForm" >

<b><font size="4" face="Verdana" color="brown">Create File</font></b>

<table cellspacing="0" cellpadding="0" >
											
	<tr>
		<td class="top-left" height="10"></td>
		<td class="top"></td>
		<td class="top-right" height="10"></td>
	</tr>
												
	<tr>
		<td class="left"></td>
												
		<td>

<table style="WIDTH: 99.25%">
	<tr>
		<td align="center" class="RowBorderColor"></td>
	</tr>
	<tr>
		<td bordercolor=#ffffff colspan=2>
		<div id="divActivityList">
		<table class="Bodytxt" cellspacing="2" align="Left" 
			border="0" id="dgRolesList"
			style="border-width:0px;border-style:None;width:100%;">
			<tr align="Right">

			</tr>
	<tr	style="color:Black;font-weight:bold;height:25px;">
		<td align="left" class="fieldFont" style="WIDTH: 17.39%"
			bgColor="#f3f9fa"><font color="red">*</font> Template</td>
		<td align="left">
		
			<select name="template" id="template" class="dropDown" >
			
				<option value="">Select Template</option>
			
			<%
				if ( templates != null ) {
							
							for ( int i = 0; i < templates.length; i++ ) { 	%>
							   
							   		<option value="<%=templates[i].getName()%>"><%=templates[i].getName()%></option>
													  
						<%			templates[i].close();
						}
				}
			%>
			
			</select>
		
		</td>
	</tr>
	
	<tr style="color:Black;font-weight:bold;height:25px;">
		<td align="left" class="fieldFont" style="WIDTH: 17.39%"
			bgColor="#f3f9fa"><font color="red">*</font> Save As</td>
		<td align="left"><input name="txtFile" id="txtFile"
			type="text" maxlength="100" style="width:280px;font-weight:normal;" /></td>
	</tr>
	
		
</table>
</div>
</td>
</tr>
</table>

</td>
												
		<td class="right"></td>
	</tr>
											
	<tr>
		<td class="bottom-left"></td>
		<td class="bottom"></td>
		<td class="bottom-right" height="10"></td>
	</tr>

</table>

<br>
<!-- <input title="Click to save file" type="button" name="ibtnSave" id="ibtnSave" value="Save" border="0" onclick="javascript:checkForm();"/>
<input title="Click to close window" type="button" name="ibtnClose" id="ibtnClose" value="Close" border="0" onclick="javascript:window.close();"/> -->

<a href="javascript:checkForm();" style="text-decoration: none">
	<img title="Click to create file" alt="Save" src="image\Create.gif" id="imgUpload" style="border-style: none" />
</a>

<input title="Click to close window" type="image" src="image\Cancel.gif" alt="Close" id="imgClose" onclick="javascript:self.close();">


</form>
</div>

<%

String msg = request.getParameter("msg");
if(msg != null)out.println("<script type='text/javascript'>alert('" + msg + "!');window.opener.parent.frames[2].location.href = \"file.jsp?folder=" + folder + "\";</script>");

%>

</body>
</html>
