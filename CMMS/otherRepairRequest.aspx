<%@ Page Title="تعمیرات متفرقه" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="otherRepairRequest.aspx.cs" Inherits="CMMS.otherRepairRequest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:HiddenField runat="server" ClientIDMode="Static" ID="typefail"/>
<asp:HiddenField runat="server" ClientIDMode="Static" ID="typereq"/>
    <style>
        label{ margin: 0;margin-right: 5px;}
        .switch-field label { width: 105px;}
    </style>
    <div class="card">
        <div class="card-header bg-primary text-white">ثبت درخواست تعمیر متفرقه</div>
        <div class="card-body">
            <div style="text-align: left; padding-left: 15px;">
                <asp:TextBox ID="txtreqid" runat="server" style="display: inline-block; width: 100px; text-align: center;" Enabled="False" CssClass="form-control"></asp:TextBox>
                <label style="display: inline-block;">شماره درخواست</label>
            </div>
            <hr/>
            <div class="row">
                <div class="col-md-6 rtl">
                    <label>به : </label>
                    <asp:TextBox CssClass="form-control" runat="server" Enabled="False" Text="امور فنی"></asp:TextBox>        
                </div>
                <div class="col-md-6 rtl">
                    <label>از واحد : </label>
                    <asp:DropDownList id="drunit" AppendDataBoundItems="True" runat="server" CssClass="form-control"  DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code" TabIndex="1" > <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>       
                </div>
                <asp:SqlDataSource ID="sqlrequest" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT i_units.unit_name, r_request.other_machine, r_request.id,r_request.req_id ,CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, r_request.req_name, CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, r_request.time_req + '__' + r_request.date_req AS totaltime, r_request.state FROM r_request INNER JOIN i_units ON r_request.unit_id = i_units.unit_code WHERE (r_request.type_repair=0 and r_request.state = 1) ORDER BY r_request.id DESC"></asp:SqlDataSource>
                <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_code], [unit_name] FROM [i_units]"></asp:SqlDataSource>
            </div>
            <div class="row mt-3">
                <div class="col-md-6 rtl" style="padding-top: 25px;">   
                    <label style="display: inline-block;">اقدام نمایید.</label>
                </div>
                <div class="col-md-6 rtl">
                    <label>خواهشمند است نسبت به تعمیر  : </label>
                    <asp:TextBox ID="txtrepair" runat="server" CssClass="form-control" TabIndex="2"></asp:TextBox>        
                </div>
            </div>
            <div class="row mt-3" >
                <div class="col-md-4 rtl">
                    <label>نام درخواست کننده : </label>
                   <asp:TextBox ID="txtreq_name" ClientIDMode="Static" CssClass="form-control" runat="server" TabIndex="7"></asp:TextBox>    
                </div>
                <div class="col-md-8 rtl">
                    <label>نوع خرابی : </label>
                    <div class="switch-field">
                        <input type="radio" id="mech" name="switch1" checked tabindex="3" value="1"/>
                        <label for="mech">مکانیکی</label>
                        <input type="radio" id="mech-elec" name="switch1" tabindex="4" value="2"/>
                        <label for="mech-elec" style="width: 150px;">تاسیساتی_الکتریکی</label>
                        <input type="radio" id="elec" name="switch1" tabindex="5" value="3"/>
                        <label for="elec" style="width: 150px;">الکتریکی واحد برق</label>
                        <input type="radio" id="other" name="switch1" tabindex="6" value="4"/>
                        <label for="other">غیره</label>
                    </div>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-6"></div>
                <div class="col-md-6 rtl">
                    <label>نوع درخواست : </label>
                    <div class="switch-field">
                        <input type="radio" id="EM" name="switch_3" value="EM" checked tabindex="8"/>
                        <label for="EM">اضطراری</label>
                        <input type="radio" id="PM" name="switch_3" value="PM" tabindex="9" />
                        <label for="PM">پیش بینانه</label>
                        <input type="radio" id="ER" name="switch_3" value="ER" tabindex="10"/>
                        <label for="ER">پیش گیرانه</label>
                    </div>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-12 rtl">
                    <label> توضیحات : </label>
                    <asp:TextBox ID="txtcomment" CssClass="form-control" runat="server" TabIndex="11"></asp:TextBox>        
                </div>
            </div>
            <div class="row mt-3" >
                <div class="col-md-6 rtl">
                    <label style="display: block;">ساعت درخواست : </label>
                    <input id="txtRequestTime" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-6 rtl">
                    <label style="display: block;">تاریخ درخواست : </label>
                    <input id="txtRequestDate" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
            </div>
               
        </div>
        <div class="card-footer">
            <asp:Button runat="server" CssClass="button" TabIndex="17" Text="ثبت" ID="btninsert" OnClick="btninsert_OnClick" OnClientClick="getRadioFail();getRadioreq();"/>
            <asp:Button runat="server" CssClass="button" Visible="False" TabIndex="18" Text="ویرایش" ID="btnedit" OnClick="btnedit_OnClick" OnClientClick="getRadioreq();getRadioFail();"/>
            <asp:Button runat="server" CssClass="button" Visible="False" TabIndex="19" Text="انصراف" ID="btncancel" OnClick="btncancel_OnClick"/>
        </div>
        <div class="card-footer">
            <asp:GridView ID="gridrequest" runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="sqlrequest" DataKeyNames="id"  OnRowCommand="gridrequest_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="req_id" HeaderText="شماره درخواست" SortExpression="req_id" InsertVisible="False" ReadOnly="True" />
                    <asp:BoundField DataField="unit_name" HeaderText="واحد درخواست کننده" SortExpression="unit_name" />
                    <asp:BoundField DataField="req_name" HeaderText="نام درخواست کننده" SortExpression="req_name" />
                    <asp:BoundField DataField="other_machine" HeaderText="مورد تعمیر" SortExpression="other_machine" />
                    <asp:BoundField DataField="Treq" HeaderText="نوع درخواست" ReadOnly="True" SortExpression="Treq" />
                    <asp:BoundField DataField="Tfail" HeaderText="نوع خرابی" SortExpression="Tfail" ReadOnly="True" />
                    <asp:BoundField DataField="totaltime" HeaderText="زمان درخواست" SortExpression="totaltime" />
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
        </div>
    </div>
<script>
    $(function() {
        kamaDatepicker('txtRequestDate', customOptions);
        $('#txtRequestTime').clockpicker({ autoclose: true, placement: 'top' });
    })
    function Err()
    {
        if ($('#txtreq_name').val() == '') {
            $('#txtreq_name').addClass('form-controlError');
            setTimeout(function () { $('#txtreq_name').removeClass('form-controlError'); }, 4000);
            $.notify("!!لطفا نام درخواست کننده را وارد نمایید", { globalPosition: 'top left' });
        }       
    }
    function getRadioFail() {
        var hiddenfield;
        var mech = document.getElementById('mech');
        var mechelec = document.getElementById('mech-elec');
        var elec = document.getElementById('elec');
        if (mech.checked) {
            hiddenfield = $('#typefail');
            hiddenfield.val("1");
        }
        else if (mechelec.checked) {
            hiddenfield = $('#typefail');
            hiddenfield.val("2");
        }
        else if (elec.checked) {
            hiddenfield = $('#typefail');
            hiddenfield.val("3");
        }
        else {
            hiddenfield = $('#typefail');
            hiddenfield.val("4");
        }
    }

    function setRadioFail() {
        var hiddenfield = $('#typefail').val();
        var mech = document.getElementById('mech');
        var mechelech = document.getElementById('mech-elec');
        var elec = document.getElementById('elec');
        var other = document.getElementById('other');
        if (hiddenfield == '1') {
            mech.checked = true;
        }
        else if (hiddenfield == '2') {
            mechelech.checked = true;
        }
        else if (hiddenfield == '3') {
            elec.checked = true;
        }
        else {
            other.checked = true;
        }
    }
    //=============================
    function getRadioreq() {
        var hiddenfield;
        var EM = document.getElementById('EM');
        var PM = document.getElementById('PM');
        if (EM.checked) {
            hiddenfield = $('#typereq');
            hiddenfield.val("1");
        }
        else if (PM.checked) {
            hiddenfield = $('#typereq');
            hiddenfield.val("2");
        }
        else {
            hiddenfield = $('#typereq');
            hiddenfield.val("3");
        }
    }

    function setRadioreq() {
        var hiddenfield = $('#typereq').val();
        var EM = document.getElementById('EM');
        var PM = document.getElementById('PM');
        var ER = document.getElementById('ER');
       
        if (hiddenfield == '1') {
            EM.checked = true;
        }
        else if (hiddenfield == '2') {
            PM.checked = true;
        }
        else {
            ER.checked = true;
        }
    }
</script>
</asp:Content>

