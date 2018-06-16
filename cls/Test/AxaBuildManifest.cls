Include %occInclude

Class Test.AxaBuildManifest
{

/// You can see generated method in zsetup+1^App.Installer.1
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
    <If Condition='(##class(Config.Namespaces).Exists("${Namespace}")=0)'>
        <Log Text="Creating namespace ${Namespace}" Level="0"/>
        <Namespace Name="${Namespace}" Create="yes" Code="${Namespace}" Ensemble="0" Data="${Namespace}">
            <Configuration>
           
                <Database Name="${Namespace}" Dir="${MGRDIR}${Namespace}" Create="yes"/>
                
                <!--<GlobalMapping Global="CacheMsg" From="ENSLIB" /> 
                <GlobalMapping Global="ALL" From="ENSEMBLE"   />
                
                
                 <RoutineMapping Routines="Ens*" Type="ALL" From="ENSLIB"/> -->
                <!--RoutineMapping Routines="HS.*" Type="ALL" From="HSLIB"/--> 
                
                 <!--<ClassMapping Package="Ens" From="ENSLIB"/>
                <ClassMapping Package="EnsLib" From="ENSLIB"/>
                <ClassMapping Package="EnsPortal" From="ENSLIB"/>
                <ClassMapping Package="CSPX.Dashboard" From="ENSLIB"/> -->
                <!--ClassMapping Package="HS" From="HSLIB"/>
                <ClassMapping Package="HS.Local" From="HSCUSTOM"/-->
                               
               </Configuration>
        </Namespace>
        <Log Text="End Creating namespace ${Namespace}" Level="0"/>
    </If>

    <Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_CACHESYS:RW,%Admin_Secure:U" />

    <Namespace Name="${Namespace}" Create="no">
        <CSPApplication Url="/csp/${Namespace}" Directory="${CSPDIR}${Namespace}" AuthenticationMethods="64" IsNamespaceDefault="true" Grant="AppRole" />
        <IfDef Var="SourceFile">
            <Log Text="SourceFile defined - offline install from ${SourceFile}" Level="3"/>
            <Import File="${SourceFile}" Recurse="true"/>
            <!--<Var Name="AddClassesErrors" Value="&quot;,5202,5373,&quot;" />-->
             
       <!--IgnoreErrors="1" -->
    

        </IfDef>
    </Namespace>
</Manifest>
}

/// Entry point method, you need to call
/// At class compile time it generate Caché ObjectScript code from the manifest
/// After that you can run this installer from a terminal:
/// Set pVars("Namespace")="NewNamespace"
/// Set pVars("SourceDir")="C:\temp\distr\"
/// Do ##class(Test.AxaBuildManifest).setup(.pVars)
ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
     Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

}

