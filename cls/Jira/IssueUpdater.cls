Class Jira.IssueUpdater Extends %RegisteredObject
{

/// set sc=##class(Jira.IssueUpdater).DeleteAllJiraData()
ClassMethod DeleteAllJiraData() As %Status
{
 do ##class(Jira.JiraProject).%DeleteExtent()
 do ##class(Jira.Issue).%DeleteExtent()
 do ##class(Jira.OpenIssue).%DeleteExtent()
 quit 1
}

// Property AuditObject As QUASAR.System.Audit.Audit;

ClassMethod DeleteJiraIssue(deleteobj As %Persistent = "") As %Status
{
 if '$isobject(deleteobj) quit $$$ERROR($$$GeneralError,"Must supply a valid object for deletion")
 
 set classname=deleteobj.%ClassName(1)
 lock +^QOBJ(classname):1 if '$T quit $$$ERROR($$$GeneralError,classname_" object is being updated elsewhere")
 
 // Get the Current Values for the object
 set mode="D"

 // Copy the old details (used for audit later)
 set oldobj=deleteobj.%ConstructClone()
 
 // Delete the object from the Database
 set sc=$classmethod(classname,"%DeleteId",deleteobj.%Id())
 
 // Release lock as early as possible
 lock -^QOBJ(classname)
 
 if $$$ISERR(sc) Q sc
 
 // Do the Audit
 //do ..AuditOptions(..AuditObject,..%ClassName(1),mode,oldobj,deleteobj)
 
 quit $$$OK
}

ClassMethod UpdateJiraIssue(newobj As %Persistent = "", ByRef vals, stack As %Integer = 1) As %Status
{
 if '$isobject(newobj) quit $$$ERROR($$$GeneralError,"Must supply a valid object for update")
 if $order(vals(""))="" quit $$$ERROR($$$GeneralError,"No Data Values to update in input array")
 
 set classname=newobj.%ClassName(1)
 //lock +^QOBJ(classname):1 if '$T quit $$$ERROR($$$GeneralError,classname_" object is being updated elsewhere")
 
 // Get the Current Values for the object
 set mode=$S(newobj.%Id()="":"C",1:"A")

 // Copy the old details (used for audit later)
 set oldobj=newobj.%ConstructClone()

 // convert field names on input array to upper for match to field name in update object class def
 set name="" for  set name=$order(vals(name)) quit:name=""||('$data(vals(name,stack)))  if name'?1.U set vals($zconvert(name,"U"),stack)=vals(name,stack)
 set cdef=##class(%Dictionary.CompiledClass).%OpenId("Jira."_newobj.%ClassName())
 if '$isobject(cdef) quit $$$ERROR($$$GeneralError,"Cannot access class definition object for: "_newobj.%ClassName())
 
 kill auditvals
 for count=1:1:cdef.Properties.Count()
 {
    set propname=cdef.Properties.GetAt(count).Name
    if $extract(propname)="%" continue //Ignore system properties
    set propnameU=$zconvert(propname,"U")
    if '$data(vals(propnameU,stack)) continue //No match between field name in class def and input array
    set val=vals(propnameU,stack)
    set auditvals(propname)=val //store for subsequent audit
    
    //Translate the data into correct storage format
    
    // Dates on ^jira in Jira format must convert to %DN format for storage
    if cdef.Properties.GetAt(count).Type["Date" {
	    if val'="" {
		    set val=$extract(val,6,16),val=$tr(val," ",""),val=$zconvert(val,"U")
	        if $length(val)<9 set dd="0"_$extract(val,1),val=dd_$extract(val,2,9)
	    }
	    if val?2N3U4N set %DA=val D %B11V^AB11L000 set val=%DN
    	if val?8N set val=$ZDATEH(val,5)
    	if val?4N1"-"2N1"-"2N set val=$ZDATEH(val,3)
    	}
        
    //continue:$property(newobj,propname)=val  //only update changes
    
    /*if propname="Project" {
    	set val=##class(JiraProject).GetJiraProject(vals("ProjectCode",stack))
    	set val.Description=$get(vals("ProjectDesc",stack)) kill vals("ProjectDesc",stack)
    	}*/
    
    set $property(newobj,propname)=val       //update the field value
    }
 
 // Update to Database
 set sc=newobj.%Save()
 
 if $$$ISERR(sc) {
	 do $system.Status.DecomposeStatus(%objlasterror,.err)
	 merge ^JIRA("errors",$increment(^JIRA("errors")))=err
	 merge ^JIRA("errors",^JIRA("errors"),"update_vals")=vals
 }
 
 // Release lock as early as possible
 //lock -^QOBJ(classname)
 
 if $$$ISERR(sc) Q sc
 
 // Do the Audit
 //do ..AuditOptions(..AuditObject,..%ClassName(1),mode,oldobj,newobj)
 
 quit $$$OK
}

/// Example: set sc=##class(Jira.IssueUpdater).UpdateAllJiraIssuesFromImportFile()
ClassMethod UpdateAllJiraIssuesFromImportFile() As %Status
{
 kill ^JIRA("errors")
 set jirn="",sc=1 for {
	 set jirn=$order(^JIRA("issues",jirn)) quit:jirn=""
	 set sc=##class(IssueUpdater).UpdateJiraIssueFromImportFile(jirn)
	 quit:'sc
 	 }
 quit sc
}

ClassMethod UpdateJiraIssueFromImportFile(jirn As %String = "") As %Status
{
 if jirn="" quit $$$ERROR($$$GeneralError,"Jira Issue IRN is null")

 // Check data exists for this IRN
 if '$data(^JIRA("issues",jirn))#10 quit $$$ERROR($$$GeneralError,"No data on Import File for this IRN")

 if '$data(%F) set %F=0
 if '$data(%ID) set %ID=$J	
 //set ..AuditObject=##class(QUASAR.System.Audit.Interface).StartAudit(0,%F,%ID)
 
 // Get Message data for message irn and populate array of values for update
 kill vals
 set issuedata=..GetIssueData(jirn) for i=1:1:$listlength(issuedata) {
    set data=$listget(issuedata,i)
	set fieldname=$piece(data,";",1),fieldvalue=$piece(data,";",2)
	set fieldname=$translate(fieldname," ","")
	set stk=$order(vals(fieldname,""),-1)+1 //need to store by stack for list/array based fields
	set vals(fieldname,stk)=fieldvalue	 
	}
  
 // Populate any additional field values where data is not set from Jira messages
 set vals("CreatedInJira",1)="Y"
 
 // All objects to show date/time/user details of last update from Jira
 set vals("LastUpdatedFromJira",1)=$zdatetime($ztimestamp,3)
 
 // Get object instance to update
 set newobj=""
 set project=$piece(jirn,"-",1),issuenumber=$piece(jirn,"-",2)
 if (##class(Issue).%ExistsId(project_"||"_issuenumber)) {
	 set newobj=##class(Issue).%OpenId(project_"||"_issuenumber)
	 set mode="A"
	 }
	 else
	 {
	 set newobj=##class(Issue).%New()
	 set mode="C"
	 }
	  
 // If we have not retrieved an object for update then sub message type is not set for update so just quit
 if '$isobject(newobj) quit $$$OK

 // Perform main updates
 if mode'="D" {set sc=##class(IssueUpdater).UpdateJiraIssue(newobj,.vals) if $$$ISERR(sc) quit sc}
 elseif mode="D" {set sc=##class(IssueUpdater).DeleteJiraIssue(newobj,.vals) if $$$ISERR(sc) quit sc}
	 
 if $$$ISERR(sc) quit sc
 quit $$$OK
}

ClassMethod GetIssueData(jirn As %Integer) As %Library.List
{

 set A="*",list=""
 kill tData
 merge tData(jirn)=^JIRA("issues",jirn)
 
 set propdata=$get(tData(jirn,"assignee",1)),list=list_$lb("Assignee;"_propdata)
 set propdata=$get(tData(jirn,"created",1)),list=list_$lb("CreatedDate;"_propdata)
 set propdata=$piece(jirn,"-",2),list=list_$lb("IssueNumber;"_propdata)
 set propdata=$get(tData(jirn,"type",1)),list=list_$lb("IssueType;"_propdata)
 set propdata=$piece(jirn,"-",1),list=list_$lb("ProjectCode;"_propdata)
 set propdata=$get(tData(jirn,"reporter",1)),list=list_$lb("Reporter;"_propdata)
 set propdata=$get(tData(jirn,"resolved",1)),list=list_$lb("ResolvedDate;"_propdata)
 set propdata=$get(tData(jirn,"resolution",1)),list=list_$lb("Resolution;"_propdata)
 set propdata=$get(tData(jirn,"status",1)),list=list_$lb("Status;"_propdata)
 set propdata=$get(tData(jirn,"summary",1)),list=list_$lb("Summary;"_propdata)
 set list=list_$lb("Project;") // object valued property. Ref. will be set at point of update.
 set propdata=$get(tData(jirn,"project",1)),list=list_$lb("ProjectDesc;"_propdata)
 // Idkey fields -
 set list=list_$lb("ProjectCode;"_$piece(jirn,"-",1))
 set list=list_$lb("IssueNumber;"_$piece(jirn,"-",2))
 quit list
}

/*
Method AuditOptions(oAUD As QUASAR.System.Audit.Audit, rtn As %Library.String, mode As %Library.String, oldobj As %Persistent, oOBJ As %Persistent) [ Private ]
{
 //set audfmt=##class(QUASAR.System.Audit.Interface).CreateAuditFormatter(oAUD)
 set A="*"
 ;do audfmt.SetfieldvalueIndent(50)
 
 set (fieldname,fieldvalue)=""
 if mode="C"
 {
	 if '..DoneAuditHeader do ..AddAuditHeader(audfmt,rtn,mode,oOBJ)	 
	 for {
	 	set fieldname=$order(auditvals(fieldname)) quit:fieldname=""
	 	set fieldvalue=auditvals(fieldname)
	 	do audfmt.AuditItem(fieldname,fieldvalue)
	 	}
 }
 else
 {
	 for {
	 	set fieldname=$order(auditvals(fieldname)) quit:fieldname=""
	 	set oldval=$method(oldobj,fieldname_"Get")
	 	set newval=$method(newobj,fieldname_"Get")
	 	if oldval'=newval {
		 	if '..DoneAuditHeader do ..AddAuditHeader(audfmt,rtn,mode,oOBJ)
		 	do audfmt.AuditAmendedItem(fieldname,oldval,newval)
	 		}
	 	}
 }
 quit
}

Method AddAuditHeader(audfmt As QUASAR.System.Audit.AuditFormatter, rtn As %Library.String, mode As %Library.String, oOBJ As %Persistent) [ Private ]
{
 do audfmt.AuditRoutine(rtn)
 do audfmt.AddLine($S(mode="C":"Created",mode="A":"Amended",mode="D":"Deleted",1:mode)_" Jira Module Object: "_oOBJ.%ClassName())
 do audfmt.AddLine(" ")
 
 set ..DoneAuditHeader=1
 
 quit
}
*/
Property DoneAuditHeader As %Library.Boolean [ InitialExpression = 0, Private ];

}

