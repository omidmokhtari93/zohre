<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="CMMS.admin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="card">
        <div class="card-header bg-primary text-white" style="text-align: center; font-family: tahoma;">License Expiration Date</div>
        <div class="card-body">
            <div style="display: block; text-align: center; text-align: center; font-family: tahoma;">
                License End Date : 
                <asp:Label runat="server" ID="lbl" style="display: inline-block; padding: 10px;"></asp:Label>
            </div>
            <div class="row" style="margin: 0;">
                <div class="col-lg-3">
                    <asp:Button runat="server" Text="ثبت" OnClick="OnClick" style="width: 100%;" CssClass="button"/>        
                </div>
                <div class="col-lg-9">
                    <input id="txt" class="form-control text-center" readonly autocomplete="off" type="text" style="cursor: pointer;" runat="server" ClientIDMode="Static"/> 
                </div>
            </div>  
        </div>
    </div>
    <script>
        $(document).ready(function () {
            kamaDatepicker('txt', customOptions);
        });
    </script>
</asp:Content>