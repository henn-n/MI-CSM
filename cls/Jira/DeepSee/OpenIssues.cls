/// 
Class Jira.DeepSee.OpenIssues Extends %DeepSee.CubeDefinition [ DependsOn = Jira.OpenIssue, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Open Issues" displayName="Open Issues" disabled="false" abstract="false" sourceClass="Jira.OpenIssue" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false">
  <dimension name="Assignee" displayName="Assignee" description="Assignee" disabled="false" hasAll="true" allCaption="All Assignee" allDisplayName="Assignee" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Assignee" displayName="Assignee" description="Assignee" disabled="false" sourceProperty="Assignee" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Open Date" displayName="Open Date" description="Open Date" disabled="false" hasAll="true" allCaption="All Open Date" allDisplayName="Open Date" sourceProperty="Date" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" displayName="Year" description="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Month" displayName="Month" description="Month" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Week" displayName="Week" description="Week" disabled="false" timeFunction="WeekYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Day" displayName="Day" description="Day" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Project" displayName="Project" description="Project" disabled="false" hasAll="true" allCaption="All Project" allDisplayName="Project" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Project" displayName="Project" description="Project" disabled="false" sourceProperty="ProjectCode" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
</cube>
}

Parameter DOMAIN;

}

