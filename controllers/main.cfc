<cfcomponent displayname="Main" hint="Main Controller">
	<cfset variables.fw = "">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="fw">
		
		<cfset variables.fw = arguments.fw>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setjson" access="public" output="false" returntype="void">
		<cfargument name="json" type="any" required="true">
		<cfset variables.json = arguments.json />
	</cffunction>
	<cffunction name="getjson" access="public" output="false" returntype="any">
		<cfreturn variables.json />
	</cffunction>
	
	<cffunction name="home" access="public" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		
		
	</cffunction>
	
	<cffunction name="ajaxCftips" access="public" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<cfset var cftipsfeed = ''>
		<cfset var retJson = '' />
		
		<cffeed action="read" source="http://www.cftips.net/feeds/rss.cfm" name="cftipsfeed">
		
		<cfset retJson = returnJSONFeed(cftipsfeed) />

		<cfoutput>#retJson#</cfoutput>
		<cfabort>
		
	</cffunction>
	
	<cffunction name="ajaxTumblr" access="public" returntype="void">
		<cfargument name="rc" type="struct" required="true">
		<cfset var tumblrfeed = ''>
		<cfset var retJson = '' />
		
		<cffeed action="read" source="http://johngag.tumblr.com/rss" name="tumblrfeed">
		<cfset retJson = returnJSONFeed(tumblrfeed) />

		<cfoutput>#retJson#</cfoutput>
		<cfabort>
	</cffunction>
	
	<cffunction name="returnJSONFeed" access="private" returntype="String">
		<cfargument name="feeds" type="any" required="true">
		<cfset var feedStruct = structNew()>
		<cfset var entry = structNew()>
		<cfset var jsonService = getjson()>
		<cfset var feed = ''>

		<cfset feedStruct.items = ArrayNew(1)>
		<cfif FindNoCase("Tumblr",feeds.generator) GT 0>
			<cfset feedStruct.type = "tumblr">
		<cfelse>
			<cfset feedStruct.type = "cftips">
		</cfif>

		<cfloop array="#arguments.feeds.item#" index="wow">
			<cfset entry = structNew()>
			<cfset entry.title = wow.title>
			<cfset entry.pubDate = wow.pubDate>
			<cfset entry.link = wow.link>
			<cfset arrayAppend(feedStruct.items, entry)>
		</cfloop>

		<cfreturn jsonService.encode(feedStruct)>
	</cffunction>
	
	<cfscript>
		function ago(dateThen){
			var result = "";
			var i = "";
			var rightNow = Now();
			Do{
				i = dateDiff('yyyy',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# years ago";
					break;
				}else if (i EQ 1){
					result = "#i# year ago";
					break;
				}
			
				i = dateDiff('m',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# months ago";
					break;
				}else if (i EQ 1){
					result = "#i# month ago";
					break;
				}
			
				i = dateDiff('d',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# days ago";
					break;
				}else if (i EQ 1){
					result = "#i# day ago";
					break;
				}
			
				i = dateDiff('h',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# hours ago";
					break;
				}else if (i EQ 1){
					result = "#i# hour ago";
					break;
				}
			
				i = dateDiff('n',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# minutes ago";
					break;
				}else if (i EQ 1){
					result = "#i# minute ago";
					break;
				}
			
				i = dateDiff('s',dateThen,rightNow);
				if(i GTE 2){
					result = "#i# seconds ago";
					break;
				}else if (i EQ 1){
					result = "#i# second ago";
					break;
				}else{
					result = "less than 1 second ago";
					break;
				}
			}
			While (0 eq 0);
				return result;
		}
	</cfscript>
</cfcomponent>

