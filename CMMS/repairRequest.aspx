<%@ Page Title="درخواست تعمیر" Language="C#" MasterPageFile="~/MainDesign.Master" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="repairRequest.aspx.cs" Inherits="CMMS.repairRequest" %>
<%@ Import Namespace="CMMS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <style>
        label{ margin: 0;margin-right: 5px;}
    </style>
    <div class="card sans">
        <div class="card-header bg-primary text-white">ثبت درخواست تعمیر</div>
        <div class="card-body">
            <div style="text-align: left; padding-left: 15px;">
                <asp:TextBox ID="txtreqid" runat="server" style="display: inline-block; width: 100px; text-align: center;" Enabled="False" CssClass="form-control"></asp:TextBox>
                <label style="display: inline-block;">شماره درخواست</label>
            </div>
            <hr/>
            <div class="row">
                <div class="col-md-3 rtl bold-sans">
                    فاز :
                    <asp:DropDownList runat="server" CssClass="form-control " AppendDataBoundItems="True" ID="drFaz" ClientIDMode="Static" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id" TabIndex="3">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlFaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, faz_name FROM i_faz"></asp:SqlDataSource>
                </div>
                <div class="col-md-3 rtl bold-sans">
                    خط :
                    <asp:DropDownList runat="server" CssClass="form-control " ID="drLine" ClientIDMode="Static" AppendDataBoundItems="True" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id" TabIndex="2">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT line_name, id FROM i_lines"></asp:SqlDataSource>
                </div>
                <div class="col-md-6 rtl">
                    <label>از واحد : </label>
                    <asp:DropDownList runat="server" ID="drUnits" CssClass="chosen-select" ClientIDMode="Static" AppendDataBoundItems="True" 
                                      DataSourceID="Sqlunit" DataTextField="unit_name" DataValueField="unit_code" >
                        <asp:ListItem Value="-1">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <asp:SqlDataSource ID="sqlfail" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,fail FROM i_fail_reason"></asp:SqlDataSource>
            <asp:SqlDataSource ID="Sqlmachine" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id,name FROM m_machine where loc=@Unit" ProviderName="<%$ ConnectionStrings:CMMS.ProviderName %>">
                <SelectParameters>
                    <asp:ControlParameter ControlID="drUnits" Name="Unit" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="Sqltools" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT subsystem.name, m_subsystem.subId FROM subsystem INNER JOIN m_subsystem ON subsystem.id = m_subsystem.subId where Mid = @machine" ProviderName="<%$ ConnectionStrings:CMMS.ProviderName %>">
                <SelectParameters>
                    <asp:ControlParameter ControlID="drMachines" Name="machine" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="Sqlunit" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT [unit_code], [unit_name] FROM [i_units]"></asp:SqlDataSource>
                    <label style="display: block;">
            <asp:SqlDataSource ID="sqlrequest" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT i_units.unit_name, r_request.id,r_request.req_id , CASE WHEN r_request.type_fail = 1 THEN 'مکانیکی' WHEN r_request.type_fail = 2 THEN 'تاسیساتی-الکتریکی' WHEN r_request.type_fail = 3 THEN 'الکتریکی واحد برق' ELSE 'غیره' END AS Tfail, r_request.req_name, CASE WHEN r_request.type_req = 1 THEN 'اضطراری' WHEN r_request.type_req = 2 THEN 'پیش بینانه' ELSE 'پیش گیرانه' END AS Treq, r_request.time_req + '__' + r_request.date_req AS totaltime, r_request.state, r_request.machine_code, m_machine.code FROM r_request INNER JOIN i_units ON r_request.unit_id = i_units.unit_code INNER JOIN m_machine ON r_request.machine_code = m_machine.id WHERE (r_request.type_repair = 1 and r_request.state = 1) ORDER BY r_request.id DESC"></asp:SqlDataSource>
            </label>
            
            <div class="row mt-3">
                <div class="col-md-5 rtl">
                    <label style="display: block;">تجهیز : </label>
                    <div class="row">
                        <div class="col-sm-8">
                            <asp:DropDownList runat="server" id="dr_tools" ClientIDMode="Static" TabIndex="5" CssClass="chosen-select"  ></asp:DropDownList>
                        </div>
                        <div class="col-sm-4">
                            <label style="line-height: 33px;">اقدام نمایید.</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 rtl">
                    <label style="display: block;">به شماره فنی : </label>
                    <asp:TextBox ID="txtmachin_code" CssClass="form-control text-center" ClientIDMode="Static" Enabled="False" style="display: inline-block;" Width="100%" runat="server"></asp:TextBox>    
                </div>
                <div class="col-md-4 rtl">
                    <label>خواهشمند است نسبت به تعمیر دستگاه : </label>
                    <asp:DropDownList runat="server" id="drMachines"   ClientIDMode="Static" CssClass="chosen-select"  TabIndex="4">
                    </asp:DropDownList>             
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-4"></div>
                <div class="col-md-4 rtl">
                    <label>نوع درخواست : </label>
                    <asp:DropDownList runat="server" ID="drTypeReq" CssClass="form-control" TabIndex="7">
                        <asp:ListItem Value="1">اضطراری</asp:ListItem>
                        <asp:ListItem Value="2">پیش بینانه</asp:ListItem>
                        <asp:ListItem Value="3">پیش گیرانه</asp:ListItem>
                    </asp:DropDownList>  
                </div>
                <div class="col-md-4 rtl">
                    <label>نوع خرابی : </label>
                    <asp:DropDownList runat="server" ID="drkindFail" CssClass="form-control" TabIndex="6">
                        <asp:ListItem Value="1">مکانیکی</asp:ListItem>
                        <asp:ListItem Value="2">تاسیساتی_الکتریکی</asp:ListItem>
                        <asp:ListItem Value="3">الکتریکی واحد برق</asp:ListItem>
                        <asp:ListItem Value="4">غیره</asp:ListItem>
                    </asp:DropDownList>  
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-4 rtl">
                    <label style="display: block;">ساعت درخواست : </label>
                    <input id="txtRequestTime" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-4 rtl">
                    <label style="display: block;">تاریخ درخواست : </label>
                    <input id="txtRequestDate" ClientIDMode="Static" runat="server" class="form-control text-center" readonly style="cursor: pointer;"/>
                </div>
                <div class="col-md-4 rtl">
                    <label>نام درخواست کننده : </label>
                    <asp:TextBox ID="txtreq_name" ClientIDMode="Static" CssClass="form-control" runat="server" TabIndex="8"></asp:TextBox>        
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-12 rtl">
                    <label> توضیحات : </label>
                    <asp:TextBox ID="txtcomment" CssClass="form-control" runat="server" TabIndex="11"></asp:TextBox>        
                </div>
           </div> 
        </div>
        <div class="card-footer">
            <asp:Button runat="server" CssClass="button" Text="ثبت" ID="btninsert" OnClick="btninsert_Click" TabIndex="12" />
            <asp:Button runat="server" CssClass="button" Visible="False" Text="ویرایش" ID="btnedit" OnClick="btnedit_OnClick" />
            <asp:Button runat="server" CssClass="button" Visible="False" Text="انصراف" ID="btncancel" OnClick="btncansel_OnClick"/>
        </div>
        <div class="card-footer">
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
                            <a class="fa fa-print" target="_blank" title="چاپ دستور کار" href="/RequestPrint.aspx?reqid=<%#  Eval("req_id") %>"></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:ButtonField Text="ویرایش" CommandName="ed"/>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <a class="fa fa-arrow-circle-left" title="بررسی و تعمیر" target="_blank" href="/Reply.aspx?reqid=<%# Crypto.Crypt(Eval("req_id").ToString()) %>"></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    

<script>
    $(function() {
        kamaDatepicker('txtRequestDate', customOptions);
        $(".chosen-select").chosen({ width: "100%" });
        $('#txtRequestTime').clockpicker({ autoclose: true, placement: 'top' });
    });


    $('#drUnits').change(function () {
        FilterMachineByUnit('drUnits', 'drMachines');
    });
    function Err()
    {
        if ($('#txtreq_name').val() == '') {
            $('#txtreq_name').addClass('form-controlError');
            setTimeout(function () { $('#txtreq_name').removeClass('form-controlError'); }, 4000);
            $.notify("!!لطفا نام درخواست کننده را وارد نمایید", { globalPosition: 'top left' });
        }
    }
    $('#dr_tools').change(function() {
        $('#tools_value').val($('#dr_tools :selected').val());
    });
    $('#drMachines').change(function () {
        completeinputs();
    });

    function completeinputs() {
        FilterSubsystemByMachine('drMachines', 'dr_tools');
        AjaxData({
            url: 'Reports.asmx/SubsystemFazLine',
            param: { unit: $('#drMachines :selected').val() },
            func: fillitems
        });
        function fillitems(e) {
            var d = JSON.parse(e.d);
            $('#txtmachin_code').val(d.SubSystemCode);
            $('#machine_value').val($('#drMachines :selected').val());
            $('#drFaz').val(d.FazName);
            $('#drLine').val(d.LineName);
        }
    }
</script>
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="machine_value"/>
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="tools_value"/>
</asp:Content>
  