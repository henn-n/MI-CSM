/// 
Class Jira.DeepSee.JiraIssues Extends %DeepSee.CubeDefinition [ DependsOn = Jira.Issue, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Issues" displayName="Jira Issues" disabled="false" abstract="false" sourceClass="Jira.Issue" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="IssueType" disabled="false" hasAll="false" allCaption="All IssueType" allDisplayName="IssueType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Level 1" disabled="false" sourceProperty="IssueType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Resolution" displayName="Resolution Code" description="Resolution Code" disabled="false" hasAll="false" allCaption="All Resolution" allDisplayName="Resolution" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Level 1" description="Level 1" disabled="false" sourceProperty="Resolution" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Assignee" displayName="Assignee" description="Assignee" disabled="false" hasAll="false" allCaption="All Assignee" allDisplayName="Assignee" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Level 1" description="Level 1" disabled="false" sourceProperty="Assignee" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Project" disabled="false" hasAll="false" allCaption="All Project" allDisplayName="Project" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Level 1" description="Level 1" disabled="false" sourceProperty="ProjectCode" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Status" disabled="false" hasAll="true" allCaption="Total" allDisplayName="Total" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Level 1" description="Level 1" disabled="false" sourceProperty="Status" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="CreatedDate" displayName="Created Date" description="Created Date" disabled="false" hasAll="false" allCaption="All CreatedDate" allDisplayName="CreatedDate" sourceProperty="CreatedDate" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="L1" displayName="Year" description="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="L2" displayName="Month" description="Month" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="L3" displayName="Week" description="Week" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="L4" displayName="Day" description="Day" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="DaysOpen" displayName="Days Open Sum" disabled="false" sourceProperty="DaysOpen" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="DaysOpenAvg" displayName="Days Open Average" description="The average number of days call was open" disabled="false" sourceProperty="DaysOpen" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="Listing 1" displayName="Listing 1" description="Listing 1" disabled="false" listingType="table" fieldList="%ID,Summary,CreatedDate,Assignee,Reporter,Resolution,ResolvedDate">
  </listing>
</cube>
}

Parameter DOMAIN;

}

