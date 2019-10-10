<%@ Page Title="ثبت تجهیزات جدید" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="newMachine.aspx.cs" Inherits="CMMS.newMachine" %>

<asp:Content ClientIDMode="Static" ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .fa-arrow-left {
            padding-top: 10px;
            padding-bottom: 10px;
        }

        .fa-arrow-right {
            padding-top: 10px;
            padding-bottom: 10px;
        }

        .table td a {
            padding: 0 4px;
            background-color: #5389db;
            color: white !important;
            font-weight: 500;
            border-radius: 2px;
        }

            .table td a:hover {
                color: white;
                text-decoration: none;
                background-color: #1b498e;
            }

        #txtPartsSearch {
            width: 100%;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        #txtSubSearchPart {
            width: 100%;
            outline: none;
            padding: 0px 3px 0 0;
            font-weight: 800;
            border: none;
            border-radius: 3px;
        }

        .imgfilter {
            position: absolute;
            top: 7px;
            right: 6px;
            width: 17px;
            height: 17px;
        }

        .loadingSend {
            position: absolute;
            left: 42px !important;
            top: 11px;
            display: none;
            width: 25px;
            height: auto;
        }

        #btnCopy {
            position: absolute;
            left: 8px;
            top: 10px;
            width: 25px;
            height: 25px;
            border: none;
            background-color: transparent;
            background-image: url(assets/Images/copy.png);
            background-size: 25px;
            outline: none;
        }
    </style>
    <link href="assets/css/MachineStyles.css" rel="stylesheet" />
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="Mid" />
    <div id="machineform" class="sans">
        <div class="card" id="pnlNewMachine" style="display: block;">
            <div class="card-header bg-primary text-white" style="position: relative;">
                <img id="loadingPage" class="loadingSend" src="assets/Images/loading.png" />
                <button type="button" title="کپی اطلاعات دستگاه" id="btnCopy" onclick="$('#copyModal').modal('show');"></button>
                ثبت دستگاه جدید
            </div>
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="catalog" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="ahamiyat" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="vaziatTajhiz" />
            <div class="card-body">
                <div class="row ltr text-right">
                    <div class="col-md-3 pr-0 rtl bold-sans">
                        کدگذاری : 
                        <div class="switch-field">
                            <input type="radio" name="switchCode" id="bavahed" value="1" checked />
                            <label for="bavahed" style="width: 100px!important; padding: 6px 6px !important;">با واحد</label>
                            <input type="radio" name="switchCode" id="bivahed" value="0" />
                            <label for="bivahed" style="width: 100px!important; padding: 6px 6px !important;">بدون واحد</label>
                        </div>
                    </div>
                    <div class="col-md-5 rtl">
                        <label style="display: block; direction: rtl;" class="bold-sans">کد دستگاه :</label>
                        <input class="form-control text-center" dir="ltr" style="width: 70%; display: inline-block; margin-left: 5px;" tabindex="2" id="txtmachineCode" />
                        <div id="machine" class="MachineCodeButtons">
                            <div class="mytooltip">
                                <div id="machineTooltip" class="tooltiptext">
                                    <table class="table" id="gridMachines" dir="rtl">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <button class="btnMachine" title="تجهیزات" id="btnMachine" type="button"></button>
                        </div>
                        &nbsp;
                        <div id="vahed" class="MachineCodeButtons">
                            <div class="mytooltip">
                                <div id="vahedTooltip" class="tooltiptext">
                                    <table class="table" id="gridUnits" dir="rtl">
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <button class="btnVahed" title="واحدها" id="btnVahed" type="button"></button>
                        </div>

                    </div>

                    <div class="col-md-4 rtl bold-sans">
                        نام دستگاه :
                    <input id="txtmachineName" tabindex="1" class="form-control" />
                    </div>
                </div>
                <div class="row mt-3 bold-sans">
                    <div class="col-md-4 rtl">
                        تاریخ نصب :
                    <input class="form-control" tabindex="4" id="txtMachineNasbDate" />
                    </div>
                    <div class="col-md-4 rtl">
                        سازنده :
                    <input id="txtMachineManufacturer" tabindex="3" class="form-control" />
                    </div>
                    <div class="col-md-4 rtl">
                        درجه اهمیت :
                    <div class="switch-field">
                        <input type="radio" id="kelidi" name="switch_2" value="1" checked />
                        <label for="kelidi">کلیدی</label>
                        <input type="radio" id="gheyrkelidi" name="switch_2" value="0" />
                        <label for="gheyrkelidi">غیرکلیدی</label>
                    </div>
                    </div>
                </div>
                <div class="row mt-3 bold-sans">
                    <div class="col-md-6 rtl">
                        تاریخ بهره برداری :
                    <input class="form-control" tabindex="7" id="txtmachineTarikh" />
                    </div>
                    <div class="col-md-6 rtl">
                        مدل دستگاه :
                    <input id="txtMachineModel" tabindex="6" class="form-control" />
                    </div>
                </div>
                <div class="row mt-3 bold-sans">
                    <div class="col-md-4 rtl">
                        فاز :
                    <asp:DropDownList runat="server" CssClass="form-control" AppendDataBoundItems="True" ID="drFaz" ClientIDMode="Static" DataSourceID="SqlFaz" DataTextField="faz_name" DataValueField="id">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlFaz" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, faz_name FROM i_faz"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-4 rtl">
                        خط :
                    <asp:DropDownList runat="server" CssClass="form-control" ID="drLine" ClientIDMode="Static" AppendDataBoundItems="True" DataSourceID="Sqlline" DataTextField="line_name" DataValueField="id">
                        <asp:ListItem Value="0">انتخاب کنید</asp:ListItem>
                    </asp:DropDownList>
                        <asp:SqlDataSource ID="Sqlline" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT line_name, id FROM i_lines"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-4 rtl">
                        محل استقرار :
                    <asp:DropDownList runat="server" TabIndex="8" ClientIDMode="Static" ID="drMAchineLocateion" CssClass="form-control" DataSourceID="sqlUnits" DataTextField="unit_name" DataValueField="unit_code">
                    </asp:DropDownList>
                        <asp:SqlDataSource ID="sqlUnits" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT unit_name, unit_code FROM i_units"></asp:SqlDataSource>
                    </div>
                </div>
                <div class="row mt-3 bold-sans">
                    <div class="col-md-6 rtl">
                        هزینه توقف بر ساعت :
                    <input class="form-control text-center" id="txtstopperhour" />
                    </div>
                    <div class="col-md-6 rtl">
                        توان / ظرفیت :
                    <input class="form-control text-center" tabindex="9" id="txtMachinePower" />
                    </div>
                </div>
                <hr />
                <div class="row mt-3 bold-sans">
                    <div class="col-md-6 rtl">
                        وضعیت تجهیز :
                    <div class="switch-field">
                        <input type="radio" id="act" name="switch_21" value="1" checked />
                        <label for="act">فعال</label>
                        <input type="radio" id="deact" name="switch_21" value="0" />
                        <label for="deact">غیر فعال</label>
                        <input type="radio" id="fail" name="switch_21" value="2" />
                        <label for="fail">معیوب </label>
                    </div>
                    </div>
                    <div class="col-md-6 rtl">
                        گروه تجهیز :
                    <asp:DropDownList runat="server" TabIndex="10" ClientIDMode="Static" ID="drCatGroup" CssClass="form-control">
                        <asp:ListItem Value="1">ماشین آلات</asp:ListItem>
                        <asp:ListItem Value="2">سیستم تاسیسات و برق</asp:ListItem>
                        <asp:ListItem Value="3">ساختمان</asp:ListItem>
                        <asp:ListItem Value="4">حمل و نقل</asp:ListItem>
                    </asp:DropDownList>
                    </div>
                </div>
                <hr />
                <label style="display: block; padding: 0 15px;">MTBF</label>
                <div class="row mt-3">
                    <div class="col-md-6 rtl">
                        <label style="display: block;" class="bold-sans">دوره پذیرش :</label>
                        <input class="form-control text-center" tabindex="12" id="txtAdmissionperiodMTBF" style="width: 70%; display: inline-block;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <label>ماه</label>
                    </div>
                    <div class="col-md-6 rtl">
                        <label style="display: block;" class="bold-sans">هدف :</label>
                        <input id="txttargetMTBF" tabindex="11" style="width: 70%; display: inline-block;" class="form-control text-center" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <label>روز</label>
                    </div>
                </div>
                <hr />
                <label style="display: block; padding: 0 15px;" class="bold-sans">MTTR</label>
                <div class="row mt-3">
                    <div class="col-md-6 rtl">
                        <label style="display: block;" class="bold-sans">دوره پذیرش :</label>
                        <input class="form-control text-center" tabindex="14" id="txtAdmissionperiodMTTR" style="width: 70%; display: inline-block;" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <label>ماه</label>
                    </div>
                    <div class="col-md-6 rtl">
                        <label style="display: block;" class="bold-sans">هدف :</label>
                        <input id="txttargetMTTR" tabindex="13" style="width: 70%; display: inline-block;" class="form-control text-center" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                    <label class="bold-sans">ساعت</label>
                    </div>
                </div>
                <hr />
                <div class="row mt-3 bold-sans">
                    <div class="col-md-6 rtl">
                        مشخصات مراکز خدمات پس از فروش :
                    <input class="form-control" tabindex="16" id="txtSupInfo" />
                    </div>
                    <div class="col-md-6 rtl">
                        مشخصات فروشنده/سازنده :
                    <input class="form-control" tabindex="15" id="txtSelInfo" />
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" id="btnNewMachineFor" title="صفحه بعد" tabindex="17" class="button fa fa-arrow-left"></button>
            </div>
        </div>

        <%--موارد مصرفی دستگاه--%>

        <div class="card" id="pnlMavaredMasrafi" style="display: none;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chbargh" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chgas" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chhava" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chsookht" />
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <span class="float-right">موارد مصرفی دستگاه</span>
            </div>
            <div class="card-body">
                <div class="row ltr text-right">
                    <div class="col-md-3 rtl">
                        <label>وزن :</label>
                        <input type="text" id="txtMavaredVazn" tabindex="21" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>ارتفاع :</label>
                        <input type="text" id="txtMavaredErtefa" tabindex="20" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>عرض :</label>
                        <input type="text" id="txtMavaredArz" tabindex="19" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>طول :</label>
                        <input type="text" id="txtMavaredTool" tabindex="18" class="form-control" />
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="display: block;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="22" id="chkbargh" />
                            برق
                        </label>
                    </div>
                    <div id="pnlBargh" class="row ltr" style="display: none;">
                        <div class="col-md-3 rtl">
                            <label>سیکل :</label>
                            <input type="text" id="txtMavaredCycle" tabindex="26" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>فاز :</label>
                            <input type="text" id="txtMavaredPhaze" tabindex="25" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>ولتاژ :</label>
                            <input type="text" id="txtMavaredVoltage" tabindex="24" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>مصرف :</label>
                            <input type="text" id="txtMavaredMasraf" tabindex="23" class="form-control" />
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="display: block;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="27" id="chkgaz" />
                            گاز
                        </label>
                    </div>
                    <div id="pnlGaz" class="row ltr" style="display: none;">
                        <div class="col-md-9"></div>
                        <div class="col-md-3 rtl">
                            <label>فشار :</label>
                            <input type="text" id="txtMavaredGazPressure" tabindex="28" class="form-control" />
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="display: block;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="29" id="chkhava" />
                            هوا
                        </label>
                    </div>
                    <div id="pnlHava" class="row ltr" style="display: none;">
                        <div class="col-md-9"></div>
                        <div class="col-md-3 rtl">
                            <label>فشار :</label>
                            <input type="text" id="txtMavaredAirPressure" tabindex="30" class="form-control" />
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="display: block;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="31" id="chksokht" />
                            سوخت مایع
                        </label>
                    </div>
                    <div id="pnlSookht" class="row ltr" style="display: none;">
                        <div class="col-md-6 rtl"></div>
                        <div class="col-md-3 rtl">
                            <label>میزان مصرف :</label>
                            <input type="text" id="txtMavaredSookhtMasraf" tabindex="33" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>نوع سوخت :</label>
                            <input type="text" id="txtMavaredSookhtType" tabindex="32" class="form-control" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="34" id="btnMavaredeMasrafiFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredeMasrafiBack"></button>
            </div>
        </div>
        <%--موارد کلیدی دستگاه --%>
        <div class="card" id="pnlMavaredKey" style="display: none;">
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <label class="float-right">موارد و توضیحات کلیدی دستگاه</label>&nbsp;
            </div>
            <div class="card-body">
                <div class="row rtl">
                    <div class="col-md-12">
                        <label>توضیحات کلیدی :</label>
                        <textarea rows="2" id="txtCommentKey" tabindex="35" class="form-control" style="resize: none;"></textarea>
                    </div>
                </div>
                <hr />
                <div class="row">
                    <div class="col-md-3 rtl">
                        <label>RPM :</label>
                        <input type="text" id="txtrpm" tabindex="38" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>KW :</label>
                        <input type="text" id="txtKw" tabindex="37" class="form-control" />
                    </div>
                    <div class="col-md-6 rtl">
                        <label>نام/شرح قطعه :</label>
                        <input type="text" id="txtKeyName" tabindex="36" class="form-control" />
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-md-3 rtl">
                        <label>جریان :</label>
                        <input type="text" id="txtFlow" tabindex="41" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>ولتاژ :</label>
                        <input type="text" id="txtvolt" tabindex="40" class="form-control" />
                    </div>
                    <div class="col-md-6 rtl">
                        <label>سازنده :</label>
                        <input type="text" id="txtcountry" tabindex="39" class="form-control" />
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-md-6 rtl">
                    </div>
                    <div class="col-md-6 rtl">
                        <label>ملاحضات:</label>
                        <input type="text" id="txtcomment" tabindex="42" class="form-control" />
                    </div>
                </div>
                <hr />
            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="43" id="btnMavaredeKeyFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredeKeyBack"></button>
                <button type="button" tabindex="39" id="btnAddKey" class="button" onclick="addKey();">
                    <span class="fa fa-plus mr-1 align-middle"></span>ثبت
                </button>
                <button class="button" style="display: none;" type="button" id="btnEditKey" onclick="EditKeyItems();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditKey" onclick="EmptyKey();">انصراف</button>
            </div>
            <div class="card-footer">
                <table class="table" id="gridMavaredKey">
                </table>
            </div>
        </div>
        <%--موارد کنترلی دستگاه--%>
        <div class="card" id="pnlMavaredControli" style="display: none;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chMDcontrol" />
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <div class="float-right">موارد کنترلی دستگاه</div>
                &nbsp;
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8 rtl">
                        <label>مورد کنترلی :</label>
                        <input id="txtControliMoredControl" tabindex="28" class="form-control" />
                    </div>
                    <div class="col-md-4 rtl">
                        <label>بخش کنترلی :</label>
                        <select class="form-control" id="Drpartcontrol"></select>
                    </div>
                </div>
                <hr />
                <div class="row">
                    <div class="col-md-4 rtl">
                        <label>تاریخ شروع سرویسکاری :</label>
                        <input class="form-control text-center" id="txtStartPMDate" readonly style="cursor: pointer;" />
                    </div>
                    <div class="col-sm-4 rtl">
                        <div id="pnlcontroliRooz" style="display: none;">
                            <label>روزپیش بینی شده در ماه :</label>
                            <input id="txtControliRooz" tabindex="37" type="number" min="1" max="31" class="form-control text-center" />
                        </div>
                        <div id="pnlControliWeek" style="display: none;">
                            <label>روز هفته :</label>
                            <select id="drControlWeek" tabindex="37" class="form-control">
                                <option value="0">شنبه</option>
                                <option value="1">یکشنبه</option>
                                <option value="2">دوشنبه</option>
                                <option value="3">سه شنبه</option>
                                <option value="4">چهارشنبه</option>
                                <option value="5">پنجشنبه</option>
                                <option value="6">جمعه</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-4 rtl">
                        <label>مدت زمان پیش بینی شده :</label>
                        <asp:DropDownList runat="server" TabIndex="36" ID="drControliZaman" ClientIDMode="Static" CssClass="form-control">
                            <asp:ListItem Value="0">روزانه</asp:ListItem>
                            <asp:ListItem Value="6">هفتگی</asp:ListItem>
                            <asp:ListItem Value="1">ماهیانه</asp:ListItem>
                            <asp:ListItem Value="2">سه ماهه</asp:ListItem>
                            <asp:ListItem Value="3">شش ماهه</asp:ListItem>
                            <asp:ListItem Value="4">یکساله</asp:ListItem>
                            <asp:ListItem Value="5">غیره</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <hr />
                <div class="row">
                    <div class="col-md-6 rtl">
                        <label style="margin-bottom: 5px;">عملیات</label>
                        <select class="form-control" id="drcontroliOpr">
                            <option value="1">برق</option>
                            <option value="2">چک و بازدید</option>
                            <option value="3">روانکاری</option>
                        </select>
                    </div>
                    <div class="col-md-6 rtl">
                        <label class="sans-small" style="margin-bottom: 5px;">آیا این دستگاه برای سرویس کاری روزانه یا ماهانه نمایش داده شود ؟</label>
                        <div class="switch-field">
                            <input type="radio" id="servicebale" name="switch_3" checked />
                            <label for="servicebale">بله</label>
                            <input type="radio" id="servicekheyr" name="switch_3" />
                            <label for="servicekheyr">خیر</label>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6 rtl">
                    </div>
                    <div class="col-md-3 rtl">
                        <label>میزان مصرفی :</label>
                        <input id="txtmizanmasraf" tabindex="28" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>ماده مصرفی/روانکار</label>
                        <div class="row">
                            <div class="col-sm-12 bold-sans">
                                <asp:DropDownList data-placeholder="انتخاب کنید" class="chosen-select" ClientIDMode="Static" AppendDataBoundItems="True" ID="drMatrial" runat="server" DataSourceID="Sqlmatrial" DataTextField="matrial" DataValueField="id">
                                    <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="Sqlmatrial" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, matrial FROM i_matrial"></asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-lg-12">
                        <label>: توضیحات </label>
                        <input class="form-control" tabindex="38" id="txtMavaredComment" />
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="40" id="btnMavaredControlFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredControlBack"></button>
                <button type="button" tabindex="39" id="btnAddControli" class="button" onclick="addControli();">
                    <span class="fa fa-plus mr-2 align-middle"></span>ثبت
                </button>
                <button class="button" style="display: none;" type="button" id="btnEditControls" onclick="EditControliItems();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditCotntrols" onclick="EmptyControls();">انصراف</button>
            </div>
            <div class="card-footer">
                <table class="table" id="gridMavaredControli">
                </table>
            </div>
        </div>

        <%--ثبت اجزا ماشین--%>
        <div class="card" id="pnlSubSytem" style="display: none;">
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <div class="float-right">ثبت اجزا ماشین</div>
                &nbsp;
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <label>شماره پلاک </label>
                        <input class="form-control ltr text-left" tabindex="39" id="txtSubPelak" />
                    </div>
                    <div class="col-md-9">
                        <label>&nbsp;</label>
                        <div id="searchSubsystem"></div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="40" id="btnSubsystemFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnSubsystemBack"></button>
                <button type="button" id="btnAddSubsystem" class="button" onclick="CreateSubTable();">
                    <span class="fa fa-plus mr-2 align-middle"></span>ثبت  
                </button>
                <button type="button" id="btnAddNewSubSystem" class="button" style="direction: rtl;" data-toggle="modal" data-target="#addSubSystem">
                    مشاهده اجزای ثبت شده 
                </button>
            </div>
            <div class="card-footer">
                <style>
                    #subSystemTable tr td:nth-child(4) input {
                        direction: ltr;
                        text-align: left;
                    }
                </style>
                <table id="subSystemTable" style="width: 60%; margin: auto; direction: rtl;" class="table">
                </table>
            </div>
        </div>

        <%--ثبت قطعات مصرفی--%>
        <div class="card" id="pnlGhatatMasrafi" style="display: none;">
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <div class="float-right">ثبت قطعات مصرفی</div>
                &nbsp;
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3 rtl">
                        <label>مصرف در سال :</label>
                        <input id="txtGhatatPerYear" tabindex="42" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>واحد :</label>
                        <asp:DropDownList Dir="rtl" class="form-control" ClientIDMode="Static" ID="Drmeasurement" runat="server" Style="display: inline-block; padding: 0;" DataSourceID="SqlMeasurement" DataTextField="measurement" DataValueField="id">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlMeasurement" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT id, measurement FROM i_measurement"></asp:SqlDataSource>
                    </div>
                    <div class="col-md-6">
                        <label>نام قطعه پر مصرف :</label>
                        <div id="partSearchDiv"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 rtl">
                        <label>حداکثر :</label>
                        <input id="txtGhatatMax" tabindex="44" class="form-control" />
                    </div>
                    <div class="col-md-6 rtl">
                        <label>حداقل :</label>
                        <input id="txtGhatatMin" tabindex="43" class="form-control" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 rtl">
                        <label>ملاحضات :</label>
                        <input class="form-control" id="txtGhatatCom" tabindex="46" />
                    </div>
                    <div class="col-md-6 rtl">
                        <label>تاریخ تقریبی تعویض بعدی :</label>
                        <input type="text" id="txtGhatatChangePeriod" tabindex="45" class="form-control text-center" readonly style="cursor: pointer;" />
                        <span class="fa fa-remove" title="این مقدار را حذف کن" onclick="$('#txtGhatatChangePeriod').val('');"
                            style="position: absolute; top: 25px; left: 25px; color: darkgray; cursor: pointer; font-size: 15pt;"></span>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" tabindex="48" title="صفحه بعد" class="button fa fa-arrow-left" id="btnGhatatFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnGhatatBack"></button>
                <button type="button" id="btnAddMasrafi" class="button" onclick="addParts();" tabindex="47">
                    <span class="fa fa-plus mr-2 align-middle"></span>ثبت
                </button>
                <button class="button" style="display: none;" type="button" id="btnEditPart" onclick="editParts();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditPart" onclick="ClearFields('pnlGhatatMasrafi');CancelDeletePart();">انصراف</button>

            </div>
            <div class="card-footer">
                <table class="table" id="gridGhataatMasrafi">
                </table>
            </div>
        </div>

        <%--دستورالعمل ایمنی و محیط زیستی--%>
        <div class="card" id="pnlDastoor" style="display: none;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chEnergy" />
            <div class="card-header bg-primary text-white">
                <label class="float-left" lblmcode></label>
                <div class="float-right">دستورالعمل ایمنی و محیط زیستی</div>
                &nbsp;
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <textarea class="form-control sans-small" tabindex="49" style="resize: none; min-height: 400px;" id="txtInstruc">
1-استفاده از لوازم حفاظت فردی متناسب با نوع کار الزامی می باشد.
2-ایمنی را همواره سرلوحه کار خود قرار دهید و درهنگام کار با ابزار برنده از شوخی کردن پرهیز کنید،یادتان باشد اول ایمنی،دوم ایمنی،سوم ایمنی...وبعد از برقراری شرایط ایمن انجام هرکاری صحیح و مجاز می باشد.
3-حتما از خوب و مناسب بسته شدن قطعات و گیره به میز و به همدیگر مطمئن شوید.
4-هنگام جابجایی محورها دقت بفرمائید بر خوردی بین ابزار و دیگر متعلقات دستگاه به وجود نیاید.
5-از انباشتن هر وسیله غیر ضروری در محدوده کار جلوگیری کنید.
6-از ابزار مناسب و ترجیحا استاندارد استفاده کنید.
7-دستگاه روشن را هرگز با دست لمس نکنید و هنگام نظافت و گریس کاری حتما دستگاه خاموش باشد.
8-سعی کنید دمای محیط کار همواره حدود بیست درجه سانتی گراد باشد.
9-از ولتاژ مناسب برق دستگاه هنگام کار مطمئن باشید.
10-سیستم اتصال برق بایستی مناسب باشد.
11-هنگام کار حتما دقت کافی را هم به مانیتور و هم به ابزار و قطعه داشته باشید.
12-هنگام کار حتما دستهایتان نزدیک به کلیدهای  سلکتور و خاموش اضطراری باشد و در صورت بروز حادثه در عین خونسردی سریع العمل باشید.
13-ترجیحا از باد خصوصا در جهت ریل های دستگاه استفاده نکنید.
14-وارد منوهای تخصصی و پارامترهای ثابت دستگاه و درایوها و متعلقات الکترونیکی بردهای دستگاه نشوید چون علاوه بر احتمال خرابی بخش های گران قیمت احتمال برق گرفتگی نیز وجود دارد.
15-دقت کنید فن های خنک کننده در حال کار باشند.
16-اپراتور باید فردی آموزش دیده ، دارای حکم کارگزینی به همراه شرح وظایف ، و ملزم به رعایت آن باشد.
17-اپراتور باید از پوشیدن لباسهای گشاد خودداری کند.
18-دقت کنید که دستگاه روغنریزی نداشته و هنگام کار درب دستگاه بسته باشد.
                    </textarea>
                    </div>
                </div>
                <br />
                <div id="pnlModiriatEnergy" class="border pt-2 rounded">
                    <div class="row pr-3 pl-3">
                        <div class="col-md-6 rtl"></div>
                        <div class="col-md-6 rtl">
                            <label style="display: block;">تاریخ مراجعه : </label>
                            <input type="text" tabindex="50" id="txtDastoorTarikh" class="form-control text-center" />
                        </div>
                    </div>
                    <div class="row pr-3 pl-3 mt-2">
                        <div class="col-md-6 rtl"></div>
                        <div class="col-md-6 rtl">
                            <label>نوع دستگاه :</label>
                            <input id="txtDastoorMachineType" tabindex="51" class="form-control" />
                        </div>
                    </div>
                    <hr />
                    <div style="display: block; padding: 5px 15px;">
                        <label>ارزیابی عملکرد موتور</label>
                        <hr class="mt-1 mb-1"/>
                    </div>
                    <div class="row pr-3 pl-3">
                        <div class="col-md-3"></div>
                        <div class="col-md-3 rtl">
                            <label>آمپرفاز3 :</label>
                            <input id="txtDastoorAmper3" tabindex="54" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>آمپرفاز2 :</label>
                            <input id="txtDastoorAmper2" tabindex="53" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>آمپرفاز1 :</label>
                            <input id="txtDastoorAmper1" tabindex="52" class="form-control" />
                        </div>
                    </div>
                    <div class="row pr-3 pl-3 mt-2">
                        <div class="col-md-3 rtl">
                            <label>PF :</label>
                            <input id="txtDastoorPF" tabindex="58" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>ولتاژفاز3 :</label>
                            <input id="txtDastoorVP3" tabindex="57" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>ولتاژفاز2 :</label>
                            <input id="txtDastoorVP2" tabindex="56" class="form-control" />
                        </div>
                        <div class="col-md-3 rtl">
                            <label>ولتاژفاز1 :</label>
                            <input id="txtDastoorVP1" tabindex="55" class="form-control" />
                        </div>
                    </div>
                    <div class="card-footer" style="margin-top: 15px;">
                        <button type="button" class="button" onclick="insertEnergy();">ثبت مورد</button>
                    </div>
                    <div class="card-footer">
                        <table class="table" id="gridEnergy"></table>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button id="btnFinalSave" style="outline: none;" type="button" class="button" onclick="SendTablesToDB();" tabindex="61">
                    ثبت نهایی
                    <img id="btnFinalLoading" style="position: absolute; left: 30px; bottom: 21px; display: inline; width: 20px; display: none;" src="assets/Images/loading.png" />
                </button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnDastoorBack"></button>
                <label style="display: inline-block; color: red; margin-left: 20px; display: none;" id="lblwarn">** لطفا فیلد خالی را پر کنید **</label>
            </div>
        </div>
    </div>

    <div id="addSubSystem" class="modal fade rtl" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="card sans">
                    <div class="card-header bg-primary text-white">ثبت اجزا جدید ماشین آلات</div>
                    <div class="card-body">
                        <p class="ltr sans-small">.لطفا در ثبت اجزا ماشین دقت فرمایید و از ثبت اجزا تکراری خوداری فرمایید <span class="fa fa-circle text-danger"></span></p>
                        <div class="row">
                            <div class="col-lg-2">
                                <button class="button btn-block align-middle" type="button" onclick="AddSubSystems();">+</button>
                            </div>
                            <div class="col-lg-5">
                                <input type="number" tabindex="2" autocomplete="off" id="txtToolCode" class="form-control" style="display: inline-block; direction: rtl;" placeholder="کد تجهیز" />
                                <div id="codeTooltip" class="tooltipp" style="width: 140px;">
                                    .این کد قبلا ثبت شده است
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <input type="text" autocomplete="off" tabindex="1" id="txtToolName" class="form-control" style="display: inline-block; direction: rtl;" placeholder="نام تجهیز" />
                                <div id="nameTooltip" class="tooltipp">
                                </div>
                            </div>
                        </div>
                        <div style="width: 100%; height: 250px; margin: 10px 0 0px 0; overflow: auto;">
                            <table id="gridPopupSubsystem" class="table" style="direction: rtl;">
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="ModalDeleteControl" class="modal fade" style="direction: rtl;" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content sans">
                <div class="card" style="margin-bottom: 0;">
                    <div class="card-header bg-danger text-white" style="font-weight: 800;">حذف مورد کنترلی</div>
                    <div class="card-body" style="text-align: center;">
                        <strong style="color: red;">** کاربر گرامی **</strong>
                        <p class="sans-small text-center">
                            در صورت حذف مورد کنترلی کلیه سوابق ثبت شده سرویسکاری مربوط به آن نیز حذف خواهد شد!<br>
                            آیا مایل به حذف هستید؟
                        </p>
                        <div style="text-align: center;">
                            <button class="button" type="button" onclick="DeleteControls();">حذف</button>
                            <button class="button" type="button" onclick="$('#ModalDeleteControl').modal('hide');">انصراف</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="ModalDeletePart" class="modal fade" style="direction: rtl;" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="card sans">
                    <div class="card-header bg-danger text-white">حذف قطعه</div>
                    <div class="card-body">
                        <p class="text-center">آیا مایل به حذف هستید؟</p>
                        <div style="text-align: center;">
                            <button class="button" type="button" onclick="DeletePart();">حذف</button>
                            <button class="button" type="button" onclick="$('#ModalDeletePart').modal('hide');">انصراف</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="copyModal" class="modal fade" style="direction: rtl;" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="card sans">
                    <div class="card-header bg-primary text-white">کپی اطلاعات دستگاه ها</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-4">
                                <label>&nbsp;</label>
                                <button type="button" class="button" style="display: block; width: 100%;" onclick="CopyData();">کپی</button>
                            </div>
                            <div class="col-lg-8">
                                نام ماشین
                                <asp:DropDownList ID="drMachinesCopy" AppendDataBoundItems="True" CssClass="form-control" runat="server" ClientIDMode="Static" DataSourceID="SqlMAchineBase" DataTextField="name" DataValueField="code">
                                    <asp:ListItem Value="0">نام ماشین / دستگاه را انتخاب نمایید</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlMAchineBase" runat="server" ConnectionString="<%$ ConnectionStrings:CMMS %>" SelectCommand="SELECT code, name FROM b_machine"></asp:SqlDataSource>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/machineJS.js"></script>
    <script src="assets/js/SubSystemJS.js"></script>
    <script src="assets/js/SearchParts.js"></script>
    <script src="assets/js/MachineCode.js"></script>
    <script src="assets/js/copyMachineData.js"></script>
</asp:Content>



