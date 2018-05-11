/// Object representing a JIRA Issue.
/// 
Class Jira.Issue Extends %Persistent
{

Method %OnBeforeSave() As %Status [ Private, ServerOnly = 1 ]
{
    // Calculate OpenDates
    do ..OpenDates.Clear()
    if '..OpenDates.Count()&&(..CreatedDate'="")&&(..ResolvedDate'="") {
	    for date=(..CreatedDate-1):1:..ResolvedDate {
		    do ..OpenDates.Insert(date)
	    	}
	    }
	set ..DaysOpen=..OpenDates.Count()
	quit 1
}

ClassMethod GetOpenDates(jirn As %String) As %Library.ListOfDataTypes
{
    set project=$piece(jirn,"-",1)
    set issuenumber=$piece(jirn,"-",2)
    set opendates=##class(Issue).%OpenId(project_"||"_issuenumber,0).OpenDates
    if (opendates.Count()=0) {quit $listfromstring("No Data Available")}
    set list=""
    for i=1:1:opendates.Count() {
        set $li(list,i)=opendates.GetAt(i)_",68947" //$zd(opendates.GetAt(i),3) 
        }
    quit list
}

Property DaysOpen As %Integer;

Property OpenDates As list Of %Date;

Property Assignee As %String;

Property CreatedDate As %Date;

Property CreatedInJira As %String;

Property Reporter As %String;

Property ResolvedDate As %Date;

Property Resolution As %String;

Property Status As %String;

Property Summary As %String(MAXLEN = 250);

Property IssueType As %String;

Property ProjectCode As %String;

Property Project As JiraProject;

// [ SqlComputeCode = {set {*} = ##class(JiraProject).GetJiraProject({IssueNumber})}, SqlComputed ];

Property IssueNumber As %Integer [ Required ];

Property LastUpdatedFromJira As %TimeStamp;

Index IssueKeyIndex On (ProjectCode, IssueNumber) [ IdKey, PrimaryKey, Unique ];

Index ProjectCodeIndex On ProjectCode;

Storage Default
{
<Data name="IssueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastUpdatedFromJira</Value>
</Value>
<Value name="3">
<Value>Assignee</Value>
</Value>
<Value name="4">
<Value>CreatedDate</Value>
</Value>
<Value name="5">
<Value>Reporter</Value>
</Value>
<Value name="6">
<Value>ResolvedDate</Value>
</Value>
<Value name="7">
<Value>Resolution</Value>
</Value>
<Value name="8">
<Value>Status</Value>
</Value>
<Value name="9">
<Value>Summary</Value>
</Value>
<Value name="10">
<Value>IssueType</Value>
</Value>
<Value name="11">
<Value>CreatedInJira</Value>
</Value>
<Value name="12">
<Value>OpenDates</Value>
</Value>
<Value name="13">
<Value>DaysOpen</Value>
</Value>
<Value name="14">
<Value>Project</Value>
</Value>
</Data>
<DataLocation>^Jira.IssueD</DataLocation>
<DefaultData>IssueDefaultData</DefaultData>
<IdLocation>^Jira.IssueD</IdLocation>
<IndexLocation>^Jira.IssueI</IndexLocation>
<StreamLocation>^Jira.IssueS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

