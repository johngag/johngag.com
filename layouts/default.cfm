<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><cfoutput>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>John Gagliardi</title>
<meta name="description" content="The home of John Gagliardi" />
<meta name="keywords" content="John Gagliardi" />
<link rel="stylesheet" media="all" href="assets/css/styles.css" />
<link rel="stylesheet" media="only screen and (max-width: 800px), only screen and (max-device-width: 800px)" href="assets/css/phone.css" />
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
<script src="assets/scripts/home.js" language="javascript" type="text/javascript"></script>
</html>
