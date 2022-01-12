Imports System.Web.Security
Imports DotNetOpenAuth.AspNet
Imports Microsoft.AspNet.Membership.OpenAuth

Namespace MPO
    Public Class RegisterExternalLogin
        Inherits System.Web.UI.Page

        Protected Property ProviderName As String
            Get
                Return If(DirectCast(ViewState("ProviderName"), String), String.Empty)
            End Get
            Private Set(value As String)
                ViewState("ProviderName") = value
            End Set
        End Property

        Protected Property ProviderDisplayName As String
            Get
                Return If(DirectCast(ViewState("PropertyProviderDisplayName"), String), String.Empty)
            End Get
            Private Set(value As String)
                ViewState("ProviderDisplayName") = value
            End Set
        End Property

        Protected Property ProviderUserId As String
            Get
                Return If(DirectCast(ViewState("ProviderUserId"), String), String.Empty)
            End Get

            Private Set(value As String)
                ViewState("ProviderUserId") = value
            End Set
        End Property

        Protected Property ProviderUserName As String
            Get
                Return If(DirectCast(ViewState("ProviderUserName"), String), String.Empty)
            End Get

            Private Set(value As String)
                ViewState("ProviderUserName") = value
            End Set
        End Property

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ProcessProviderResult()
            End If
        End Sub

        Protected Sub logIn_Click(ByVal sender As Object, ByVal e As System.EventArgs)
            CreateAndLoginUser()
        End Sub

        Protected Sub cancel_Click(ByVal sender As Object, ByVal e As System.EventArgs)
            RedirectToReturnUrl()
        End Sub

        Private Sub ProcessProviderResult()
            ' Elaborare il risultato fornito da un provider di autenticazione nella richiesta
            ProviderName = OpenAuth.GetProviderNameFromCurrentRequest()

            If String.IsNullOrEmpty(ProviderName) Then
                Response.Redirect(FormsAuthentication.LoginUrl)
            End If

            ' Generare l'URL di reindirizzamento per la verifica OpenAuth
            Dim redirectUrl As String = "~/Account/RegisterExternalLogin"
            Dim returnUrl As String = Request.QueryString("ReturnUrl")
            If Not String.IsNullOrEmpty(returnUrl) Then
                redirectUrl &= "?ReturnUrl=" & HttpUtility.UrlEncode(returnUrl)
            End If

            ' Verificare il payload OpenAuth
            Dim authResult As AuthenticationResult = OpenAuth.VerifyAuthentication(redirectUrl)
            ProviderDisplayName = OpenAuth.GetProviderDisplayName(ProviderName)
            If Not authResult.IsSuccessful Then
                Title = "Accesso esterno non riuscito"
                userNameForm.Visible = False

                ModelState.AddModelError("Provider", String.Format("Accesso esterno con {0} non riuscito.", ProviderDisplayName))

                ' Per visualizzare questo errore, abilitare la traccia delle pagine in web.config (<system.web><trace enabled="true"/></system.web>) e visitare ~/Trace.axd
                Trace.Warn("OpenAuth", String.Format("Si è verificato un errore durante la verifica dell'autenticazione con {0})", ProviderDisplayName), authResult.Error)
                Return
            End If

            ' L'utente ha eseguito l'accesso con il provider
            ' Verificare se l'utente è già registrato nel computer locale
            If OpenAuth.Login(authResult.Provider, authResult.ProviderUserId, createPersistentCookie:=False) Then
                RedirectToReturnUrl()
            End If

            ' Archiviare i dati del provider in ViewState
            ProviderName = authResult.Provider
            ProviderUserId = authResult.ProviderUserId
            ProviderUserName = authResult.UserName

            ' Rimuovere la stringa di query dall'azione
            Form.Action = ResolveUrl(redirectUrl)

            If (User.Identity.IsAuthenticated) Then
                ' L'utente è già autenticato, aggiungere l'account di accesso esterno ed eseguire il reindirizzamento all'URL restituito
                OpenAuth.AddAccountToExistingUser(ProviderName, ProviderUserId, ProviderUserName, User.Identity.Name)
                RedirectToReturnUrl()
            Else
                ' L'utente è nuovo, chiedere di specificare il nome di appartenenza desiderato
                userName.Text = authResult.UserName
            End If
        End Sub

        Private Sub CreateAndLoginUser()
            If Not IsValid Then
                Return
            End If

            Dim createResult As CreateResult = OpenAuth.CreateUser(ProviderName, ProviderUserId, ProviderUserName, userName.Text)

            If Not createResult.IsSuccessful Then

                ModelState.AddModelError("UserName", createResult.ErrorMessage)

            Else
                ' Utente creato e associato
                If OpenAuth.Login(ProviderName, ProviderUserId, createPersistentCookie:=False) Then
                    RedirectToReturnUrl()
                End If
            End If
        End Sub

        Private Sub RedirectToReturnUrl()
            Dim returnUrl As String = Request.QueryString("ReturnUrl")
            If Not String.IsNullOrEmpty(returnUrl) And OpenAuth.IsLocalUrl(returnUrl) Then
                Response.Redirect(returnUrl)
            Else
                Response.Redirect("~/")
            End If
        End Sub
    End Class
End Namespace