<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="OpenAuthProviders.ascx.vb" Inherits="MPO.OpenAuthProviders" %>


<fieldset class="open-auth-providers">
    <legend>Accedi tramite un altro servizio</legend>
    
    <asp:ListView runat="server" ID="providerDetails" ItemType="Microsoft.AspNet.Membership.OpenAuth.ProviderDetails"
        SelectMethod="GetProviderNames" ViewStateMode="Disabled">
        <ItemTemplate>
            <button type="submit" name="provider" value="<%#: Item.ProviderName %>"
                title="Accedi con l'account <%#: Item.ProviderDisplayName %> personale.">
                <%#: Item.ProviderDisplayName %>
            </button>
        </ItemTemplate>
    
        <EmptyDataTemplate>
            <div class="message-info">
                <p>Non sono configurati servizi di autenticazione esterni. Vedere <a href="http://go.microsoft.com/fwlink/?LinkId=252803">questo articolo</a> per informazioni su come configurare l'applicazione ASP.NET per il supporto dell'accesso tramite servizi esterni.</p>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
</fieldset>