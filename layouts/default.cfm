<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><cfoutput>
<head>
<!---Mobile meta tags--->
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"><!doctype>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>John Gagliardi</title>
<meta name="description" content="The home of John Gagliardi" />
<meta name="keywords" content="John Gagliardi" />
<link rel="stylesheet" media="screen" href="assets/css/styles.min.css" />
</head>

<body>	
<!---error output--->
<cfif structkeyexists(rc,'message')>
	<cfif not arrayIsEmpty(rc.message)> 
		<cfloop array="#rc.message#" index="msg">
			#msg#&nbsp;
		</cfloop>
	</cfif>
</cfif>
#body#
</cfoutput>
</body>
<script src="http://code.jquery.com/jquery-1.5.2.min.js" language="javascript" type="text/javascript"></script>
<script src="assets/scripts/home.min.js" language="javascript" type="text/javascript"></script>
</html>
