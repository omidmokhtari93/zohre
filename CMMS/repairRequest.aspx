<%@ Page Title="درخواست تعمیر" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="repairRequest.aspx.cs" Inherits="CMMS.repairRequest" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="typefail"/>
<asp:HiddenField runat="server" ClientIDMode="Static" ID="typereq"/>
    <style>
        label{ margin: 0;margin-right: 5px;}
    </style>
    <div class="panel panel-primary">
        <div class="panel-heading">ثبت درخواست تعمیر</div>
        <div class="panel-body">
            <div style="text-align: left; padding-left: 15px;">
                <asp:TextBox ID="txtreqid" runat="server" style="display: inline-block; width: 100px; text-align: center;" Enabled="False" CssClass="form-control"></asp:TextBox>
                <label style="display: inline-block;">شماره درخواست</label>
            </div>
            <hr/>
            <div class="row" style="margin: 0; direction: rtl; text-align: right;">
                <div class="col-md-3">
                    فاز :
                    <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" ID="drFaz" ClientIDMode="Static" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id" TabIndex="3">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                        
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlFaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, faz_name FROM i_faz"></asp:SqlDataSource>
                </div>
                <div class="col-md-3">
                    خط :
                    <asp:DropDownList runat="server" CssClass="form-control" ID="drLine" ClientIDMode="Static" AppendDataBoundItems="True" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id" TabIndex="2">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT line_name, id FROM i_lines"></asp:SqlDataSource>
                </div>
                <div class="col-md-6">
                    <label>از واحد : </label>
                    <asp:DropDownList id="drunit" AppendDataBoundItems="True" runat="server" OnSelectedIndexChanged="drunit_OnSelectedIndexChanged" CssClass="form-control"  DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code" TabIndex="1" AutoPostBack="True"> <asp:ListItem Value="-1">واحد را انتخاب کنید</asp:ListItem></asp:DropDownList>        
                </div>
            </div>
            <asp:SqlDataSource ID="sqlfail" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,fail FROM i_fail_reason"></asp:SqlDataSource>
            <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_code], [unit_name] FROM [i_units]"></asp:SqlDataSource>
                    <label style="display: block;">
            <asp:SqlDataSource ID="sqlrequest" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT i_units.unit_name, r_request.id,r_request.req_id , CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, r_request.req_name, CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, r_request.time_req + '__' + r_request.date_req AS totaltime, r_request.state, r_request.machine_code, m_machine.code FROM r_request INNER JOIN i_units ON r_request.unit_id = i_units.unit_code INNER JOIN m_machine ON r_request.machine_code = m_machine.id WHERE (r_request.type_repair = 1 and r_request.state = 1) ORDER BY r_request.id DESC"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sqlsubsys" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT subsystem.name, m_subsystem.subId FROM subsystem INNER JOIN m_subsystem ON subsystem.id = m_subsystem.subId WHERE (m_subsystem.Mid = @Mid)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="dr_machine" Name="Mid" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource> 
            </label>
            <asp:SqlDataSource ID="sqlmachin" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, name FROM m_machine WHERE (loc = @unit_id)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="drunit" Name="unit_id" PropertyName="SelectedValue" />
               </SelectParameters>
            </asp:SqlDataSource>
            <div class="row" style="margin: 0; direction: rtl; text-align: right; margin-top: 15px;">
                <div class="col-md-5">
                    <label style="display: block;">تجهیز : </label>
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" Width="200px" style="display: inline-block;"  TabIndex="5" CssClass="form-control" id="dr_tools" DataSourceID="sqlsubsys" DataTextField="name" DataValueField="subId"> <asp:ListItem Value="-1">تجهیز را انتخاب کنید</asp:ListItem></asp:DropDownList>  
                    <label style="display: inline-block;">اقدام نمایید.</label>
                </div>
                <div class="col-md-3">
                    <label style="display: block;">به شماره فنی : </label>
                    <asp:TextBox ID="txtmachin_code" CssClass="form-control text-center"  Enabled="False" style="display: inline-block;" Width="100%" runat="server"></asp:TextBox>    
                </div>
                <div class="col-md-4">
                    <label>خواهشمند است نسبت به تعمیر دستگاه : </label>
                    <asp:DropDownList runat="server" AppendDataBoundItems="True" OnSelectedIndexChanged="dr_machine_OnSelectedIndexChanged" TabIndex="4" CssClass="form-control" id="dr_machine"  DataSourceID="sqlmachin" DataTextField="name"  DataValueField="id" AutoPostBack="True"> <asp:ListItem Value="-1">دستگاه را انتخاب کنید</asp:ListItem></asp:DropDownList>        
                </div>
            </div>
            <div class="row" style="margin: 0; direction: rtl; text-align: right;margin-top: 15px;">
                <div class="col-md-4">
                    
                </div>
                <div class="col-md-4">
                    <label>نوع درخواست : </label>
                    <asp:DropDownList runat="server" ID="drTypeReq" CssClass="form-control" TabIndex="7">
                        <asp:ListItem Value="1">اضطراری</asp:ListItem>
                        <asp:ListItem Value="2">پیش بینانه</asp:ListItem>
                        <asp:ListItem Value="3">پیش گیرانه</asp:ListItem>
                    </asp:DropDownList>  
                </div>
                <div class="col-md-4">
                    <label>نوع خرابی : </label>
                    <asp:DropDownList runat="server" ID="drkindFail" CssClass="form-control" TabIndex="6">
                        <asp:ListItem Value="1">مکانیکی</asp:ListItem>
                        <asp:ListItem Value="2">تاسیساتی_الکتریکی</asp:ListItem>
                        <asp:ListItem Value="3">الکتریکی واحد برق</asp:ListItem>
                        <asp:ListItem Value="4">غیره</asp:ListItem>
                    </asp:DropDownList>  
                   <%-- <div class="switch-field">
                        <input type="radio" id="mech" name="switch1" checked tabindex="3" value="1"/>
                        <label for="mech">مکانیکی</label>
                        <input type="radio" id="mech-elec" name="switch1" tabindex="4" value="2"/>
                        <label for="mech-elec" style="width: 150px;">تاسیساتی_الکتریکی</label>
                        <input type="radio" id="elec" name="switch1" tabindex="5" value="3"/>
                        <label for="elec" style="width: 150px;">الکتریکی واحد برق</label>
                        <input type="radio" id="other" name="switch1" tabindex="6" value="4"/>
                        <label for="other">غیره</label>
                   </div>--%>
                </div>
            </div>
            <div class="row" style="margin: 0; direction: rtl; text-align: right;margin-top: 15px;">
                <div class="col-md-4">
                    <label style="display: block;">ساعت درخواست : </label>
                    <input id="txtRequestTime" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-4">
                    <label style="display: block;">تاریخ درخواست : </label>
                    <input id="txtRequestDate" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-4">
                    <label>نام درخواست کننده : </label>
                    <asp:TextBox ID="txtreq_name" ClientIDMode="Static" CssClass="form-control" runat="server" TabIndex="8"></asp:TextBox>        
                </div>
            </div>
           <%-- <div class="row" style="margin: 0; direction: rtl; text-align: right;margin-top: 15px;">
                <div class="col-md-6"></div>
                <div class="col-md-6">
                    <label>نوع درخواست : </label>
                    <div class="switch-field">
                        <input type="radio" id="EM" name="switch_3" value="EM" checked tabindex="8"/>
                        <label for="EM">اضطراری</label>
                        <input type="radio" id="CM" name="switch_3" value="CM" tabindex="9" />
                        <label for="CM">پیش بینانه</label>
                        <input type="radio" id="PM" name="switch_3" value="PM" tabindex="10"/>
                        <label for="PM">پیش گیرانه</label>
                    </div>
                </div>
            </div>--%>
            <div class="row" style="margin: 0; direction: rtl; text-align: right;margin-top: 15px;">
                <div class="col-md-12">
                    <label> توضیحات : </label>
                    <asp:TextBox ID="txtcomment" CssClass="form-control" runat="server" TabIndex="11"></asp:TextBox>        
                </div>
           </div>
           
               
        </div>

        <div class="panel-footer">
            <asp:Button runat="server" CssClass="button" Text="ثبت" ID="btninsert" OnClick="btninsert_Click" TabIndex="12" OnClientClick="getRadioFail();getRadioreq();"/>
            <asp:Button runat="server" CssClass="button" Visible="False" Text="ویرایش" ID="btnedit" OnClick="btnedit_OnClick" OnClientClick="getRadioreq();getRadioFail();"/>
            <asp:Button runat="server" CssClass="button" Visible="False" Text="انصراف" ID="btncancel" OnClick="btncansel_OnClick"/>
        </div>
        <div class="panel-footer">
           
            <asp:GridView ID="gridrequest" runat="server" CssClass="table" AutoGenerateColumns="False" DataSourceID="sqlrequest" DataKeyNames="id"  OnRowCommand="gridrequest_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="req_id" HeaderText="شماره درخواست" SortExpression="req_id" InsertVisible="False" ReadOnly="True" />
                    <asp:BoundField DataField="unit_name" HeaderText="واحد درخواست کننده" SortExpression="unit_name" />
                    <asp:BoundField DataField="req_name" HeaderText="نام درخواست کننده" SortExpression="req_name" />
                    <asp:BoundField DataField="code" HeaderText="کد تجهیز" SortExpression="code" />
                    <asp:BoundField DataField="Treq" HeaderText="نوع درخواست" ReadOnly="True" SortExpression="Treq" />
                    <asp:BoundField DataField="Tfail" HeaderText="نوع خرابی" SortExpression="Tfail" ReadOnly="True" />
                    <asp:BoundField DataField="totaltime" HeaderText="زمان درخواست" SortExpression="totaltime" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <a class="fa fa-print" target="_blank" href="/RequestPrint.aspx?reqid=<%#  Eval("req_id") %>"></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                </Columns>
            </asp:GridView>
        </div>
    </div>
<script>
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
    kamaDatepicker('txtRequestDate', customOptions);
    $('#txtRequestTime').clockpicker({ autoclose: true, placement: 'top' });
    function Err()
    {
        if ($('#txtreq_name').val() == '') {
            $('#txtreq_name').addClass('form-controlError');
            setTimeout(function () { $('#txtreq_name').removeClass('form-controlError'); }, 4000);
            $.notify("!!لطفا نام درخواست کننده را وارد نمایید", { globalPosition: 'top left' });
        }
    }
    //function getRadioFail() {
    //    var hiddenfield;
    //    var mech = document.getElementById('mech');
    //    var mechelec = document.getElementById('mech-elec');
    //    var elec = document.getElementById('elec');
    //    if (mech.checked) {
    //        hiddenfield = $('#typefail');
    //        hiddenfield.val("1");
    //    }
    //    else if (mechelec.checked) {
    //        hiddenfield = $('#typefail');
    //        hiddenfield.val("2");
    //    }
    //    else if (elec.checked) {
    //        hiddenfield = $('#typefail');
    //        hiddenfield.val("3");
    //    }
    //    else {
    //        hiddenfield = $('#typefail');
    //        hiddenfield.val("4");
    //    }
    //}

    //function setRadioFail() {
    //    var hiddenfield = $('#typefail').val();
    //    var mech = document.getElementById('mech');
    //    var mechelech = document.getElementById('mech-elec');
    //    var elec = document.getElementById('elec');
    //    var other = document.getElementById('other');
    //    if (hiddenfield == '1') {
    //        mech.checked = true;
    //    }
    //    else if (hiddenfield == '2') {
    //        mechelech.checked = true;
    //    }
    //    else if (hiddenfield == '3') {
    //        elec.checked = true;
    //    }
    //    else {
    //        other.checked = true;
    //    }
    //}
    ////=============================
    //function getRadioreq() {
    //    var hiddenfield;
    //    var EM = document.getElementById('EM');
    //    var CM = document.getElementById('CM');
    //    if (EM.checked) {
    //        hiddenfield = $('#typereq');
    //        hiddenfield.val("1");
    //    }
    //    else if (CM.checked) {
    //        hiddenfield = $('#typereq');
    //        hiddenfield.val("2");
    //    }
    //    else {
    //        hiddenfield = $('#typereq');
    //        hiddenfield.val("3");
    //    }
    //}

    //function setRadioreq() {
    //    var hiddenfield = $('#typereq').val();
    //    var EM = document.getElementById('EM');
    //    var CM = document.getElementById('CM');
    //    var PM = document.getElementById('PM');
       
    //    if (hiddenfield == '1') {
    //        EM.checked = true;
    //    }
    //    else if (hiddenfield == '2') {
    //        CM.checked = true;
    //    }
    //    else {
    //        PM.checked = true;
    //    }
    //}
</script>
</asp:Content>
