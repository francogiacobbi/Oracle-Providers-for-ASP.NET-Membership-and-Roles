<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="RegisterExternalLogin.aspx.vb" Inherits="MPO.RegisterExternalLogin" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <hgroup class="title">
        <h1>Esegui registrazione con account <%: ProviderDisplayName %> personale</h1>
        <h2><%: ProviderUserName %>.</h2>
    </hgroup>

    
    <asp:ModelErrorMessage runat="server" ModelStateKey="Provider" CssClass="field-validation-error" />
    

    <asp:PlaceHolder runat="server" ID="userNameForm">
        <fieldset>
            <legend>Form di associazione</legend>
            <p>
                L'utente ha eseguito l'autenticazione con <strong><%: ProviderDisplayName %></strong> come
                <strong><%: ProviderUserName %></strong>. Immettere di seguito un nome utente per il sito corrente
                e fare clic sul pulsante Accedi.
            </p>
            <ol>
                <li class="email">
                    <asp:Label runat="server" AssociatedControlID="userName">Nome utente</asp:Label>
                    <asp:TextBox runat="server" ID="userName" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="userName"
                        Display="Dynamic" ErrorMessage="Il nome utente è obbligatorio" ValidationGroup="NewUser" />
                    
                    <asp:ModelErrorMessage runat="server" ModelStateKey="UserName" CssClass="field-validation-error" />
                    
                </li>
            </ol>
            <asp:Button runat="server" Text="Accedi" ValidationGroup="NewUser" OnClick="logIn_Click" />
            <asp:Button runat="server" Text="Annulla" CausesValidation="false" OnClick="cancel_Click" />
        </fieldset>
    </asp:PlaceHolder>
</asp:Content>
