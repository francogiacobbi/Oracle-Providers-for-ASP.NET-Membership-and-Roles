
Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Public Class Login
    Inherits System.Web.UI.Page


    Private Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        RegisterHyperLink.NavigateUrl = "Register"
        OpenAuthLogin.ReturnUrl = Request.QueryString("ReturnUrl")

        Dim returnUrl = HttpUtility.UrlEncode(Request.QueryString("ReturnUrl"))
        If Not String.IsNullOrEmpty(returnUrl) Then
            RegisterHyperLink.NavigateUrl &= "?ReturnUrl=" & returnUrl
        End If


    End Sub
End Class
