Imports Oracle.ManagedDataAccess.Client
Imports Oracle.ManagedDataAccess.Types
Imports System.Xml
Imports System.Data.Linq
Imports Newtonsoft.Json
Imports System.Web.Configuration
Imports Oracle.ManagedDataAccess
Imports System.Reflection

Public Class GetOracleData
    Private json As String
    Public Errore As Boolean
    Public Messaggio As String
    Public Tipo As String

    

    Public Function GetDataSet_FromQuery(strSQL As String) As DataTable

        Dim strConn As String = GetConnOracleString()

        Dim dsReturn As New DataTable()

        Try
            Using con As New OracleConnection(strConn)
                con.Open()
                Using sda As New OracleDataAdapter(strSQL, con)
                    sda.Fill(dsReturn)
                End Using
                con.Close()
            End Using
            Errore = False
            Messaggio = "OK"
            Return dsReturn
        Catch ex As Exception
            Errore = True
            Messaggio = ex.Message
            Return Nothing
        End Try

    End Function

    
    Public Function GetConnOracleString() As String
        Dim x As String

        x = "Data Source=" + _
            System.Configuration.ConfigurationManager.AppSettings("ORACLE_DATA_SOURCE_PMS") + ";" + _
            "User Id=" + _
            WebConfigurationManager.AppSettings("ORACLE_USER_SOURCE_PMS") + ";" + _
            "Password=" + _
            WebConfigurationManager.AppSettings("ORACLE_PASSWORD_SOURCE_PMS")

        Return x
    End Function

    

    

    

    
    
    

    

    

    
    



    
    
    

    
    


    

    


End Class
