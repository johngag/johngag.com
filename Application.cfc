<cfcomponent extends="org.corfield.framework">

	<cfscript>
	this.name = 'johngag';
	this.sessionmanagement = true;
	this.sessiontimeout = createTimeSpan(20,0,0,0);
	this.SetClientCookies 	= true;
	this.SetDomainCookies = false;
	
	// FW/1 - configuration eat my shorts:
	variables.framework = {
		home = "main.home",
		generateSES = true,
  		SESOmitIndex = false,
		reloadApplicationOnEveryRequest = true,
		maxNumContextsPreserved = 1
		
	};
	
	variables.framework.base = getDirectoryFromPath( CGI.SCRIPT_NAME ).replace( getContextRoot(), '' );
	
	function setupRequest()
	{
		
	}
	
	function setupSession()
	{
			
	}
	
	</cfscript>
	
	<cffunction name="setupApplication">
		<cfset setBeanFactory(createObject("component", "models.ObjectFactory").init(expandPath("/assets/config/beans.xml.cfm")))/>
	</cffunction>
	 
</cfcomponent>