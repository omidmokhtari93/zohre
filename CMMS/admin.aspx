<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="CMMS.admin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="panel panel-primary">
        <div class="panel-heading" style="text-align: center; font-family: tahoma;">License Expiration Date</div>
        <div class="panel-body">
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
            var customOptions = {
                placeholder: "روز / ماه / سال"
                , twodigit: true
                , closeAfterSelect: true
                , nextButtonIcon: "fa fa-arrow-circle-right"
                , previousButtonIcon: "fa fa-arrow-circle-left"
                , buttonsColor: "blue"
                , forceFarsiDigits: true
                , markToday: true
                , markHolidays: true
                , highlightSelectedDay: true
                , sync: true
                , gotoToday: true
            }
            kamaDatepicker('txt', customOptions);
        });
    </script>
</asp:Content>