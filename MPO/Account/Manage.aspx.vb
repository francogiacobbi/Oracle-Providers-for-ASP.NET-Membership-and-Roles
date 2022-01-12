﻿Imports System.Collections.Generic
Imports Microsoft.AspNet.Membership.OpenAuth

Namespace MPO

    Public Class Manage
        Inherits System.Web.UI.Page

        Private successMessageTextValue As String
        Protected Property SuccessMessageText As String
            Get
                Return successMessageTextValue
            End Get
            Private Set(value As String)
                successMessageTextValue = value
            End Set
        End Property

        Private canRemoveExternalLoginsValue As Boolean
        Protected Property CanRemoveExternalLogins As Boolean
            Get
                Return canRemoveExternalLoginsValue
            End Get
            Set(value As Boolean)
                canRemoveExternalLoginsValue = value
            End Set
        End Property

        Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            If Not IsPostBack Then
                ' Determinare le sezioni di cui eseguire il rendering
                Dim hasLocalPassword = OpenAuth.HasLocalPassword(User.Identity.Name)
                setPassword.Visible = Not hasLocalPassword
                changePassword.Visible = hasLocalPassword

                CanRemoveExternalLogins = hasLocalPassword

                ' Messaggio di completamento del rendering
                Dim message = Request.QueryString("m")
                If Not message Is Nothing Then
                    ' Rimuovere la stringa di query dall'azione
                    Form.Action = ResolveUrl("~/Account/Manage")

                    Select Case message
                        Case "ChangePwdSuccess"
                            SuccessMessageText = "Cambiamento password completato."
                        Case "SetPwdSuccess"
                            SuccessMessageText = "Impostazione password completata."
                        Case "RemoveLoginSuccess"
                            SuccessMessageText = "L'account di accesso esterno è stato rimosso."
                        Case Else
                            SuccessMessageText = String.Empty
                    End Select

                    successMessage.Visible = Not String.IsNullOrEmpty(SuccessMessageText)
                End If
            End If


        End Sub

        Protected Sub setPassword_Click(ByVal sender As Object, ByVal e As System.EventArgs)
            If IsValid Then
                Dim result As SetPasswordResult = OpenAuth.AddLocalPassword(User.Identity.Name, password.Text)
                If result.IsSuccessful Then
                    Response.Redirect("~/Account/Manage?m=SetPwdSuccess")
                Else

                    ModelState.AddModelError("NewPassword", result.ErrorMessage)

                End If
            End If
        End Sub


        Public Function GetExternalLogins() As IEnumerable(Of OpenAuthAccountData)
            Dim accounts = OpenAuth.GetAccountsForUser(User.Identity.Name)
            CanRemoveExternalLogins = CanRemoveExternalLogins OrElse accounts.Count() > 1
            Return accounts
        End Function

        Public Sub RemoveExternalLogin(ByVal providerName As String, ByVal providerUserId As String)
            Dim m = If(OpenAuth.DeleteAccount(User.Identity.Name, providerName, providerUserId), "?m=RemoveLoginSuccess", String.Empty)
            Response.Redirect("~/Account/Manage" & m)
        End Sub


        Protected Shared Function ConvertToDisplayDateTime(ByVal utcDateTime As Nullable(Of DateTime)) As String
            ' È possibile modificare questo metodo per convertire la data e l'ora UTC in base all'offset e nel formato
            ' di visualizzazione desiderati. In questo caso viene eseguita la conversione in base al fuso orario del server e nel formato
            ' di data breve e ora estesa, secondo le impostazioni cultura del thread corrente.
            Return If(utcDateTime.HasValue, utcDateTime.Value.ToLocalTime().ToString("G"), "[mai]")
        End Function
    End Class
End Namespace