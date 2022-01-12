Public Class SiteMaster
    Inherits MasterPage


    Private Const AntiXsrfTokenKey As String = "__AntiXsrfToken"
    Private Const AntiXsrfUserNameKey As String = "__AntiXsrfUserName"
    Private _antiXsrfTokenValue As String
    Private gd As New GetOracleData


    Protected Sub Page_Init(sender As Object, e As System.EventArgs)
        ' Il codice seguente facilita la protezione da attacchi XSRF
        Dim requestCookie = Request.Cookies(AntiXsrfTokenKey)
        Dim requestCookieGuidValue As Guid

        If requestCookie IsNot Nothing AndAlso Guid.TryParse(requestCookie.Value, requestCookieGuidValue) Then
            _antiXsrfTokenValue = requestCookie.Value
            Page.ViewStateUserKey = _antiXsrfTokenValue
        Else
            _antiXsrfTokenValue = Guid.NewGuid().ToString("N")
            Page.ViewStateUserKey = _antiXsrfTokenValue
            Dim responseCookie = New HttpCookie(AntiXsrfTokenKey) With {
                .HttpOnly = True,
                .Value = _antiXsrfTokenValue
            }
            If FormsAuthentication.RequireSSL AndAlso Request.IsSecureConnection Then responseCookie.Secure = True
            Response.Cookies.[Set](responseCookie)
        End If

        '        RaiseEvent(Pagebase.PreLoad += AddressOf master_Page_PreLoad)
        AddHandler Page.PreLoad, AddressOf master_Page_PreLoad
    End Sub

    Private Sub master_Page_PreLoad(sender As Object, e As System.EventArgs)
        If Not IsPostBack Then
            ViewState(AntiXsrfTokenKey) = Page.ViewStateUserKey
            ViewState(AntiXsrfUserNameKey) = If(Context.User.Identity.Name, String.Empty)
            Session("AntiXsrfTokenKey") = Page.ViewStateUserKey
            Session("AntiXsrfUserNameKey") = If(Context.User.Identity.Name, String.Empty)
        Else

            If CStr(ViewState(AntiXsrfTokenKey)) <> _antiXsrfTokenValue OrElse CStr(ViewState(AntiXsrfUserNameKey)) <> (If(Context.User.Identity.Name, String.Empty)) Then
                Throw New InvalidOperationException("Validation of AntiXSRF token failed.")
            End If
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    End Sub
End Class