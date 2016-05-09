<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

		    <tiles:insertAttribute name="header" ignore="true" />
		    <div id="content">
	    		<tiles:insertAttribute name="body" /> 
		    </div>
		<tiles:insertAttribute name="footer" ignore="true"/>
	</body>
</html>
