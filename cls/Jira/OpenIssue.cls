Class Jira.OpenIssue Extends %Persistent
{

Property Assignee As %String;

Property CreatedDate As %Date;

Property CreatedInJira As %String;

Property Reporter As %String;

Property ResolvedDate As %Date;

Property Resolution As %String;

Property Status As %String;

Property Summary As %String(MAXLEN = 250);

Property IssueType As %String;

Property Date As %Date [ Required ];

Property ProjectCode As %String [ Required ];

Property IssueNumber As %Integer [ Required ];

Property IssueObject As Issue;

Index IssueKeyIndex On (Date, ProjectCode, IssueNumber) [ IdKey, PrimaryKey, Unique ];

Storage Default
{
<Data name="OpenIssueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IssueObject</Value>
</Value>
<Value name="3">
<Value>Assignee</Value>
</Value>
<Value name="4">
<Value>CreatedDate</Value>
</Value>
<Value name="5">
<Value>CreatedInJira</Value>
</Value>
<Value name="6">
<Value>Reporter</Value>
</Value>
<Value name="7">
<Value>ResolvedDate</Value>
</Value>
<Value name="8">
<Value>Resolution</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>Summary</Value>
</Value>
<Value name="11">
<Value>IssueType</Value>
</Value>
</Data>
<DataLocation>^Jira.OpenIssueD</DataLocation>
<DefaultData>OpenIssueDefaultData</DefaultData>
<IdLocation>^Jira.OpenIssueD</IdLocation>
<IndexLocation>^Jira.OpenIssueI</IndexLocation>
<StreamLocation>^Jira.OpenIssueS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

