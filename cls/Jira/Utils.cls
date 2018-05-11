/// General Utils to assist with working with Jira data 
Class Jira.Utils Extends %RegisteredObject [ ProcedureBlock ]
{

/// Make a connection to the Jira Server, execute a Jql query and load the results into the Cache Data Model.
ClassMethod GetJiraIssueData(jira = "", searchproject = "", searchkey = "", username = "", password = "", error, debug = 1) As %Status
{
 
 kill jira,error
 if searchproject="" set searchproject=$get(^JIRA("config","searchproject"))
 if searchkey="" set searchkey=$get(^JIRA("config","searchkey"))
 if username="" set username=$get(^JIRA("config","username"))
 if password="" set password=$get(^JIRA("config","password"))
 set server=$get(^JIRA("config","server"))
 set sslconfiguration=$get(^JIRA("config","sslconfiguration"))
 set port=$get(^JIRA("config","Port"))
 //new http, response, status, item, stack, key, textreader, path, itemstack
 set http=##class(%Net.HttpRequest).%New()
 set http.Server=server
 set http.SSLConfiguration=sslconfiguration // as set up in the system management portal for SSL connections
 set http.Https=1
 set http.Port=port
 set http.Username=username
 set http.Password=password
 set http.Timeout=120 // 2 min timeout
 kill username,password
 
 set get="/jira/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml"
 //set param("jqlQuery")="project='"_searchproject_"' AND "_$select(searchkey["FPI":"key", 1:"fixVersion")_"='"_searchkey_"'"
 
 set rangestart=101,rangeend=200
 set param("jqlQuery")="project='"_searchproject_"' AND id >= '"_searchproject_"-"_rangestart_"' AND id <= '"_searchproject_"-"_rangeend_"'"
 
 if $extract(searchkey,1,1)="v" {
  set searchkey2=$extract(searchkey,2,$length(searchkey))
  set param("jqlQuery")="project='"_searchproject_"' AND ( key='"_searchkey_"' OR key='"_searchkey2_"' )"
 }
 set param("tempMax")=1000
 set p=""
 for  {
  set p=$order(param(p))
  quit:p=""
  do http.SetParam(p, param(p))
 }
 if debug {
  write !,"Server : ",http.Server
  write !,"https get : ",get
  write !,"Parameters;",!
  zw param
 }
 set sc=http.Get(get)
 if '+sc {
  kill error
  do DecomposeStatus^%apiOBJ(sc,.error,"-d")
  quit sc
 }
 set response=http.HttpResponse.Data // response data string or object stream
 if debug {
  write !,"Response;",!
  zw response
 }
 set textreader=""
 if $isobject(response) {
  set status=##class(%XML.TextReader).ParseStream(response,.textreader)
  if '+status {
   kill error
   do DecomposeStatus^%apiOBJ(status,.error,"-d")
  
   do response.Rewind()
   set stk=0
   while 'response.AtEnd {
    set stk=stk+1
    set jira(stk)=response.ReadLine(,.sc,.eol)
   }              
   quit $$$ERROR($$$GeneralError,"Cannot Parse Response Stream")
  }
 }
 if '$isobject(textreader) quit $$$ERROR($$$GeneralError,"Cannot create Text Reader Object")
 // iterate through document, node by node
 set item=0,stack=0,key=""
 while textreader.Read()
 {
  if textreader.NodeType="element",textreader.Name="item" {
   write:debug !!,"[Start of item]"
   set item=1,stack=stack+1,key=""
  }
  if item,textreader.Value'="" {
   set path=textreader.Path
   set path=$piece(path,"/rss/channel/item/",2,512)
   write:debug !,path," ",textreader.Value
   set itemstack=$order(jira(stack,path,""),-1)+1
   set jira(stack,path,itemstack)=textreader.Value
   if path="key" set key=textreader.Value
  }
  if item,textreader.NodeType="endelement",textreader.Name="item" {
   write:debug !,"[End of item]"
   if key'="" {
    merge ^JIRA("issues",key)=jira(stack)
    kill jira(stack)
    set key=""
   }
   set item=0
  }
 }
 kill textreader
 kill response
 kill http
 quit 1
}

}

