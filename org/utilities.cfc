<!--- provides a set of useful general functions --->
<cfcomponent>
	<cffunction name="init" access="public" returntype="utilities">
		<cfreturn this />
	</cffunction>

	<cffunction name="queryRowToObject" access="public" returntype="any"
		hint="converts a query row to the specified object type.  Objects must have a function called setFieldName for each existing field
			in the query row.">
		<cfargument name="qry" type="query" required="true">
		<cfargument name="row" type="numeric" required="true" />
		<cfargument name="type" type="string" required="false" default="" />
		
		<cfset var keys = "" />
		<cfset var cols = listToArray(qry.columnList) />
		<cfset var str = structnew() />
		<cfset var obj = "" />
		<cfset var ii = "" />
		<cfset var key = "" />
			
		<cfloop from="1" to="#arrayLen(cols)#" index="ii">
			<cfset str[cols[ii]] = qry[cols[ii]][row] />
		</cfloop>
		
		<cfif arguments.type NEQ "">
			<cfset obj = createObject("component", arguments.type) />
			<cfset obj.init() />
			
			<cfset keys = structKeyArray(str) />
			<cfloop array="#keys#" index="key">
				<cftry>
					<cfinvoke component="#obj#" method="set#key#">
						<cfinvokeargument name="value" value="#str[key]#" />
					</cfinvoke>
				<cfcatch>
					<cfinvoke component="#obj#" method="set#key#">
						<cfinvokeargument name="#key#" value="#str[key]#" />
					</cfinvoke>
				</cfcatch></cftry>
			</cfloop>
			
			<cfset str = obj />
		</cfif>
		
		<cfreturn str/>
	</cffunction>
	
	<cffunction name="queryToObjects" access="public" returntype="Array" >
		<cfargument name="qry" type="query" required="true" />
		<cfargument name="type" type="string" required="false" default="" />
		
		<cfset var ret = arrayNew(1) />
		<cfset var str = "" />
		<cfset var i = "" />
		
		<cfloop from="1" to="#arguments.qry.RecordCount#" index="i">
			<cfset str = queryRowToObject(arguments.qry, i, arguments.type) />
			<cfset arrayAppend(ret, str) />
		</cfloop>
		
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="makeCleanString" output="false" hint="Creates a nice string to use in URLs" access="public" returntype="string">
		<cfargument name="stringToClean" type="string" required="true">
		<cfargument name="maxLength" type="numeric" required="false" default="150">
		<cfargument name="maxWords" type="numeric" required="false" default="70">	
		
		<!--- Code provided by Seb Duggan, thank you! --->
		<cfset var s = lcase(arguments.stringToClean) />
		<cfset var i = 0 />
		<cfset var c = "" />
		<cfset var cleanedString = "" />
		
		<cfloop from="1" to="#len(s)#" index="i">
			<cfset c = mid(s,i,1) />
			
			<cfswitch expression="#asc(c)#">
				<cfcase delimiters="," value="192,193,194,195,196,197,224,225,226,227,228,229">
					<cfset c = "a" />
				</cfcase>
				
				<cfcase delimiters="," value="198,230">
					<cfset c = "ae" />
				</cfcase>
				
				<cfcase delimiters="," value="199,231">
					<cfset c = "c" />
				</cfcase>
				
				<cfcase delimiters="," value="200,201,202,203,232,233,234,235">
					<cfset c = "e" />
				</cfcase>
				
				<cfcase delimiters="," value="204,205,206,207,236,237,238,239">
					<cfset c = "i" />
				</cfcase>
				
				<cfcase delimiters="," value="208,240">
					<cfset c = "d" />
				</cfcase>

				<cfcase delimiters="," value="209,241">
	               <cfset c = "n" />
	            </cfcase>

	            <cfcase delimiters="," value="210,211,212,213,214,216,242,243,244,245,246,248">
	               <cfset c = "o" />
	            </cfcase>
	
	            <cfcase delimiters="," value="215">
	               <cfset c = "x" />
	            </cfcase>
	
	            <cfcase delimiters="," value="217,218,219,220,249,250,251,252">
	               <cfset c = "u" />
	            </cfcase>
	
	            <cfcase delimiters="," value="221,253,255">
	               <cfset c = "y" />
	            </cfcase>
	
	            <cfcase delimiters="," value="222,254">
	               <cfset c = "p" />
	            </cfcase>
	
	            <cfcase delimiters="," value="223">
	               <cfset c = "b" />
	            </cfcase>
	         </cfswitch>

	         <cfset cleanedString = cleanedString & c />
	      </cfloop>
	
	      <cfset cleanedString = rereplace(cleanedString, "[^a-z0-9]", "-", "all") />
	      <cfset cleanedString = rereplace(cleanedString, "-{2,}", "-", "all") />
	      <cfset cleanedString = rereplace(cleanedString, "(^-|-$)", "", "all") />
	
		<cfreturn cleanedString />
	</cffunction>
	
	<cffunction name="resizeScaledImage" output="false" access="public" returntype="Struct">
		<cfargument name="imgname" type="string" required="true">
		<cfargument name="imagesrc" type="any" required="true">
			
		<cfset var fatemediapk = ""  />
		<cfset var image = "" />
		<cfset var height = 0 />
		<cfset var width = 0 />
		<cfset var margin = 0 />
		<cfset var path = "" />
		<cfset var scaledPath = "" />
		<cfset var thumbPath = "" />
		<cfset var scaledName = "" />
		<cfset var thumbName = "" />
		<cfset var scaledURL = "" />
		<cfset var thumbURL = "" />
		<cfset var ret = structNew() />
		<cfset var fileName = "" />
		<cfset var imageCFC = "" />
		<cfset var imageObj = "" />
		<cfset var imageInfo = "" />
		<cfset var scaledInfo = "" />
		<cfset var thumbInfo = "" />
		<cfset var thumbImageInfo = "" />
			
		<cfif structKeyExists(arguments, "imgname")>
			<cfset fileName = arguments.imgname />
		<cfelse>
			<cfoutput>error</cfoutput>
			<cfabort />
		</cfif>
		
		<cfimage action="write" destination="#ExpandPath('./tmp/')#/#filename#" source="#arguments.imagesrc#" overwrite="yes">

		<cfset path = "#ExpandPath('./tmp/')#/#filename#" />
		
		<cfset scaledPath = expandPath('./tmp') & "/" & session.sessionid & "-scaled-" & fileName />
		<cfset thumbPath = expandPath('./tmp') & "/" & session.sessionid & "-thumb-" & fileName />
		
		<cffile action="readbinary" file="#path#" variable="image" />
		<cfset image = imageNew(image) />
		<cfset imageScaleTofit(image, 800, 600) />
		<cfimage action="write" source="#image#" destination="#scaledPath#" overwrite="yes"/>
		<cfset scaledName = session.sessionid & "-scaled-" & fileName />
		<cfset scaledURL = '/f8ball/tmp/' & session.sessionid & "-scaled-" & fileName />
		
		<cfset height = imageGetHeight(image) />
		<cfset width = imageGetWidth(image) />
		
		<cfif height GT width>
			<cfset imageScaleToFit(image, 80, "") />
			<cfset height = imageGetHeight(image) />
			<cfset margin = (height - 80) * 0.5 />
			<cfset imageCrop(image, 0, margin, 80, 80) />
		<cfelse>
			<cfset imageScaleToFit(image, "", 80) />
			<cfset width  = imageGetWidth(image) />
			<cfset margin = (width - 80) * 0.5 />
			<cfset imageCrop(image, margin, 0, 80, 80) />
		</cfif>
		
		<cfset imageWrite(image, thumbPath) />
		<!---
		<cfset imageCFC = createObject("component", "f8ball.com.imagecfc.image") />
		<cfset imageObj = imageCFC.readImage(path) />
		<cfset imageInfo = imageCFC.getImageInfo(imageObj, "") />
		
		<cfset scaledInfo = imageCFC.resize(imageObj, "", scaledPath, 600, 450, true, false, 60) />
		<cfset scaledName = session.sessionid & "-scaled-" & fileName />
		<cfset scaledURL = '/f8ball/tmp/' & session.sessionid & "-scaled-" & fileName />
		
		<cfif imageInfo.height GT imageInfo.width>
			<cfset thumbInfo = imageCFC.resize(imageObj, "", "", 80, 0, true) />
			<cfset thumbImageInfo = imageCFC.getImageInfo(thumbInfo.img, "") />
			<cfset margin = (thumbImageInfo.height - 80) * 0.5 />
			<cfset thumbInfo = imageCFC.crop(thumbInfo.img, "", thumbPath, 0, margin, 80, 80) />
		<cfelse>
			<cfset thumbInfo = imageCFC.resize(imageObj, "", "", 0, 80, true) />
			<cfset thumbImageInfo = imageCFC.getImageInfo(thumbInfo.img, "") />
			<cfset margin = (thumbImageInfo.width - 80) * 0.5 />
			<cfset thumbInfo = imageCFC.crop(thumbInfo.img, "", thumbPath, margin, 0, 80, 80) />
		</cfif>
		--->
		<cfset thumbName =  session.sessionid & "-thumb-" & fileName />
		<cfset thumbURL = '/f8ball/tmp/' & session.sessionid & "-thumb-" & fileName />
		
		<cffile action="delete" file="#path#" />
		<cfset ret.scaledName = scaledName>
		<cfset ret.thumbName = thumbName>
		<cfreturn ret>
	</cffunction>
	
	<cffunction access="public" name="getUserLink" returntype="String" >
		<cfargument name="userName" type="string" required="true" />
		<cfargument name="userID" type="string" required="true" />
		
		<cfset var userURL = "" />
		
		<cfif arguments.userName NEQ "">
			<cfset userURL = '/user/public/username/#UserName#' />
		<cfelse>
			<cfset userURL = '/user/public/user/#UserID#' />
		</cfif>
		
		<cfreturn userURL />
	</cffunction> 
	
	<cffunction access="public" name="constructService" returnType="any">
		<cfargument name="id" type="string" required="true" />
		
		<cfset var xmlFile = "" />
		<cfset var argsNode = "" />
		<cfset var argsXml = "" />
		<cfset var xmlFileData = "" />
		<cfset var service = "" />
		<cfset var args = structNew() />
		<cfset var argument = "">
	
		<cfset xmlFile = expandPath("/") & "#Application.assetsDir#/config/beans.xml.cfm" />
		<cffile action="read" file="#xmlFile#" variable="xmlFileData" />
		<cfset argsXml = xmlParse(#xmlFileData#) />
		
		<cfset argsNode = xmlSearch(argsXml, "/beans/bean[@id='#arguments.id#']") />
		<cfset argsNode = argsNode[1] />

		<cfloop array="#argsNode.XmlChildren#" index="argument">
			<cfset args[argument.XmlAttributes.name] = argument.element.XmlAttributes.value />
		</cfloop>
		
		<cfset service = createObject("component", argsNode.XmlAttributes.class) />
		<cfset service.init(argumentCollection = args) />
		
		<cfreturn service />
	</cffunction>
	

</cfcomponent>
