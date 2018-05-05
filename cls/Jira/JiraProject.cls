Class Jira.JiraProject Extends %Persistent
{

Property ProjectCode As %String [ Required ];

Property Description As %String [ Required ];

Index ProjectCodeIndex On ProjectCode [ IdKey, PrimaryKey, Unique ];

ClassMethod GetJiraProject(jirn As %String) As JiraProject
{
    set projectCode=$piece(jirn,"-",1)  
    set projectObj=##class(JiraProject).%OpenId(projectCode,0)
    if '$isobject(projectObj) {
	    set projectObj=##class(JiraProject).%New()
	    set projectObj.ProjectCode=projectCode
	    }
    quit projectObj
}

Storage Default
{
<Data name="JiraProjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^Jira.JiraProjectD</DataLocation>
<DefaultData>JiraProjectDefaultData</DefaultData>
<IdLocation>^Jira.JiraProjectD</IdLocation>
<IndexLocation>^Jira.JiraProjectI</IndexLocation>
<StreamLocation>^Jira.JiraProjectS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

