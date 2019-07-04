<%@ Page Title="" Language="C#" MasterPageFile="~/MainDesign.Master" AutoEventWireup="true" CodeBehind="MachineBase.aspx.cs" Inherits="CMMS.MachineBase" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
            color: white;
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
            top: 10px;
            display: none;
        }

        #btnCopy {
            position: absolute;
            left: 8px;
            top: 8px;
            width: 25px;
            height: 25px;
            border: none;
            background-color: transparent;
            background-image: url(assets/Images/copy.png);
            background-size: 25px;
            outline: none;
        }

        .chkbox {
            width: 25px;
            height: 25px;
        }
    </style>
    <link href="assets/css/MachineStyles.css" rel="stylesheet" />
    <asp:HiddenField runat="server" ClientIDMode="Static" ID="Mid" />
    <div id="machineform">
        <div class="card sans" id="pnlNewMachine">
            <div class="card-header bg-primary text-white" style="position: relative;">
                ثبت اطلاعات اولیه دستگاه
            </div>
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="catalog" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="ahamiyat" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="vaziatTajhiz" />
            <div class="card-body">
                <div class="row rtl">
                    <div class="col-md-6" style="direction: rtl;">
                        درجه اهمیت :
                <div class="switch-field">
                    <input type="radio" id="kelidi" name="switch_2" value="1" checked tabindex="2" />
                    <label for="kelidi">کلیدی</label>
                    <input type="radio" id="gheyrkelidi" name="switch_2" value="0" />
                    <label for="gheyrkelidi">غیرکلیدی</label>
                </div>
                    </div>
                    <div class="col-md-6">
                        نام دستگاه :
                <input id="txtmachineName" clientidmode="Static" runat="server" tabindex="1" disabled class="form-control" />
                    </div>
                </div>
                <div class="row rtl mt-3">
                    <div class="col-md-6">
                        سازنده :
                <input id="txtMachineManufacturer" tabindex="4" class="form-control" />
                    </div>
                    <div class="col-md-6">
                        مدل دستگاه :
                    <input id="txtMachineModel" tabindex="3" class="form-control" />
                    </div>
                </div>
                <hr />
                <div class="row rtl">
                    <div class="col-md-6">
                        وضعیت تجهیز :
                <div class="switch-field">
                    <input type="radio" id="act" name="switch_21" value="1" checked tabindex="6" />
                    <label for="act">فعال</label>
                    <input type="radio" id="deact" name="switch_21" value="0" />
                    <label for="deact">غیر فعال</label>
                    <input type="radio" id="fail" name="switch_21" value="2" />
                    <label for="fail">معیوب </label>
                </div>
                    </div>
                    <div class="col-md-6">
                        گروه تجهیز :
                <asp:DropDownList runat="server" TabIndex="5" ClientIDMode="Static" ID="drCatGroup" CssClass="form-control">
                    <asp:ListItem Value="1">ماشین آلات</asp:ListItem>
                    <asp:ListItem Value="2">سیستم تاسیسات و برق</asp:ListItem>
                    <asp:ListItem Value="3">ساختمان</asp:ListItem>
                    <asp:ListItem Value="4">حمل و نقل</asp:ListItem>
                </asp:DropDownList>
                    </div>
                </div>
                <div class="row rtl mt-3">
                    <div class="col-md-6">
                        هزینه توقف بر ساعت :
                <input class="form-control text-center" id="txtstopperhour" />
                    </div>
                    <div class="col-md-6">
                        توان / ظرفیت :
                <input class="form-control text-center" tabindex="9" id="txtMachinePower" />
                    </div>
                </div>
                <hr />
                <p>MTBF</p>
                <div class="row rtl">
                    <div class="col-md-6">
                        <label style="display: block;">دوره پذیرش :</label>
                        <input class="form-control text-center w-75 d-inline-block" value="3" tabindex="12" id="txtAdmissionperiodMTBF"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                <label>ماه</label>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">هدف :</label>
                        <input id="txttargetMTBF" value="365" tabindex="11" class="form-control text-center  w-75 d-inline-block" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                <label>روز</label>
                    </div>
                </div>
                <hr />
                <p>MTTR</p>
                <div class="row rtl">
                    <div class="col-md-6">
                        <label style="display: block;">دوره پذیرش :</label>
                        <input class="form-control text-center w-75 d-inline-block" value="3" tabindex="14" id="txtAdmissionperiodMTTR" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                <label>ماه</label>
                    </div>
                    <div class="col-md-6">
                        <label style="display: block;">هدف :</label>
                        <input id="txttargetMTTR" tabindex="13" value="1" class="form-control text-center w-75 d-inline-block" />
                        &nbsp;&nbsp;&nbsp;&nbsp;
                <label>ساعت</label>
                    </div>
                </div>
                <hr />
                <div class="row rtl">
                    <div class="col-md-6">
                        مشخصات مراکز خدمات پس از فروش :
                <input class="form-control" tabindex="8" id="txtSupInfo" />
                    </div>
                    <div class="col-md-6">
                        مشخصات فروشنده/سازنده :
                <input class="form-control" tabindex="7" id="txtSelInfo" />
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" id="btnNewMachineFor" title="صفحه بعد" tabindex="9" class="button fa fa-arrow-left"></button>
            </div>
        </div>

        <%--موارد مصرفی دستگاه--%>

        <div class="card sans" id="pnlMavaredMasrafi" style="display: none;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chbargh" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chgas" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chhava" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chsookht" />
            <div class="card-header bg-primary text-white">موارد مصرفی دستگاه</div>
            <div class="card-body">
                <div class="row ltr">
                    <div class="col-md-3 rtl">
                        <label>وزن :</label>
                        <input type="text" id="txtMavaredVazn" tabindex="13" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>ارتفاع :</label>
                        <input type="text" id="txtMavaredErtefa" tabindex="12" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>عرض :</label>
                        <input type="text" id="txtMavaredArz" tabindex="11" class="form-control" />
                    </div>
                    <div class="col-md-3 rtl">
                        <label>طول :</label>
                        <input type="text" id="txtMavaredTool" tabindex="10" class="form-control" />
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="padding-right: 15px;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="14" id="chkbargh" />
                            برق
                        </label>
                    </div>
                    <div id="pnlBargh" style="display: none;">
                        <div class="row ltr">
                            <div class="col-md-3 rtl">
                                <label>سیکل :</label>
                                <input type="text" id="txtMavaredCycle" tabindex="18" class="form-control" />
                            </div>
                            <div class="col-md-3 rtl">
                                <label>فاز :</label>
                                <input type="text" id="txtMavaredPhaze" tabindex="17" class="form-control" />
                            </div>
                            <div class="col-md-3 rtl">
                                <label>ولتاژ :</label>
                                <input type="text" id="txtMavaredVoltage" tabindex="16" class="form-control" />
                            </div>
                            <div class="col-md-3 rtl">
                                <label>مصرف :</label>
                                <input type="text" id="txtMavaredMasraf" tabindex="15" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="padding-right: 15px;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="19" id="chkgaz" />
                            گاز
                        </label>
                    </div>
                    <div id="pnlGaz" style="display: none;">
                        <div class="row  ltr">
                            <div class="col-md-9"></div>
                            <div class="col-md-3 rtl">
                                <label>فشار :</label>
                                <input type="text" id="txtMavaredGazPressure" tabindex="20" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="padding-right: 15px;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="21" id="chkhava" />
                            هوا
                        </label>
                    </div>
                    <div id="pnlHava" style="display: none;">
                        <div class="row  ltr">
                            <div class="col-md-9 rtl"></div>
                            <div class="col-md-3">
                                <label>فشار :</label>
                                <input type="text" id="txtMavaredAirPressure" tabindex="22" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <hr />
                <div class="rtl">
                    <div style="padding-right: 15px;">
                        <label class="checklabel">
                            <input type="checkbox" tabindex="23" id="chksokht" />
                            سوخت مایع
                        </label>
                    </div>
                    <div id="pnlSookht" style="display: none;">
                        <div class="row ltr">
                            <div class="col-md-6"></div>
                            <div class="col-md-3 rtl">
                                <label>میزان مصرف :</label>
                                <input type="text" id="txtMavaredSookhtMasraf" tabindex="25" class="form-control" />
                            </div>
                            <div class="col-md-3 rtl">
                                <label>نوع سوخت :</label>
                                <input type="text" id="txtMavaredSookhtType" tabindex="24" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="26" id="btnMavaredeMasrafiFor"></button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredeMasrafiBack"></button>
            </div>
        </div>
    

        <%--موارد کلیدی دستگاه --%>
        <div class="card sans" id="pnlMavaredKey" style="display: none;">
            <div class="card-header bg-primary text-white">موارد و توضیحات کلیدی دستگاه</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12 rtl">
                        <label>توضیحات کلیدی :</label>
                        <textarea rows="2" id="txtCommentKey" tabindex="35" class="form-control"></textarea>
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
                <div class="row">
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
                <div class="row">

                    <div class="col-md-6">
                    </div>
                    <div class="col-md-6 rtl">
                        <label>ملاحضات:</label>
                        <input type="text" id="txtcomment" tabindex="42" class="form-control" />
                    </div>

                </div>

                <hr />

            </div>
            <div class="card-footer rtl">
                <button class="button" style="display: none;" type="button" id="btnEditKey" onclick="EditKeyItems();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditKey" onclick="EmptyKey();">انصراف</button>
                <button type="button" tabindex="39" id="btnAddKey" class="button" onclick="addKey();">
                    <span class="fa fa-plus" style="vertical-align: middle; margin-left: 5px;"></span>ثبت
                </button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredeKeyBack"></button>
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="43" id="btnMavaredeKeyFor"></button>
            </div>
            <div class="card-footer">
                <table class="table" id="gridMavaredKey">
                </table>
            </div>
        </div>
        <%--موارد کنترلی دستگاه--%>


        <div class="card sans" id="pnlMavaredControli" style="display: block;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chMDcontrol" />
            <div class="card-header bg-primary text-white">موارد کنترلی دستگاه</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12 rtl">
                        <label>مورد کنترلی :</label>
                        <input id="txtControliMoredControl" tabindex="27" class="form-control" />
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-md-6 rtl">
                        <label style="margin-bottom: 5px;">&nbsp;</label>
                        <div style="line-height: 40px;">
                            اعمال تغییرات برای همه
                            <input type="checkbox" id="chkbroadcast" class="chkbox" />
                        </div>
                    </div>
                    <div class="col-md-6 rtl">
                        <label>عملیات</label>
                        <select class="form-control" id="drcontroliOpr">
                            <option value="1" tabindex="28">برق</option>
                            <option value="2">چک و بازدید</option>
                            <option value="3">روانکاری</option>
                        </select>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-lg-12 rtl">
                        <label>توضیحات :</label>
                        <input class="form-control" tabindex="30" id="txtMavaredComment" />
                    </div>
                </div>
            </div>
            <div class="card-footer rtl">
                <button class="button" style="display: none;" type="button" id="btnEditControls" onclick="EditControliItems();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditCotntrols" onclick="EmptyControls();">انصراف</button>
                <button type="button" tabindex="31" id="btnAddControli" class="button" onclick="addControli();">
                    <span class="fa fa-plus" style="vertical-align: middle; margin-left: 5px;"></span>ثبت
                </button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnMavaredControlBack"></button>
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="31" id="btnMavaredControlFor"></button>
            </div>
            <div class="card-footer">
                <table class="table" id="gridMavaredControli">
                </table>
            </div>
        </div>


        <div class="card" id="pnlSubSytem" style="display: none;">
            <div class="card-header bg-primary text-white">ثبت اجزا ماشین</div>
            <div class="card-body" id="subSearchArea">
                <div style="padding: 5px 15px;">
                    <div style="width: 100%; display: inline-block; direction: rtl; position: relative;">
                        <div id="badgeArea" style="min-height: 24px;"></div>
                        <input id="txtSearchSubsystem" autocomplete="off" class="form-control" placeholder="جستجو" />
                        <img src="assets/Images/loading.png" id="subsystemLoading" style="width: 20px; height: 20px; position: absolute; top: 31px; left: 7px; display: none;" />
                        <div style="display: none; position: absolute; width: 100%;" id="subSystemSearchRes">
                            <div class="searchscroll">
                                <table id="gridSubsystem" class="SubSystemTable">
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer">
                <button type="button" id="btnAddSubsystem" class="button" onclick="CreateSubTable();">
                    <span class="fa fa-plus" style="vertical-align: middle; margin-left: 5px;"></span>ثبت  
                </button>
                <button type="button" id="btnAddNewSubSystem" class="button" style="direction: rtl;">
                    مشاهده اجزای ثبت شده 
                </button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnSubsystemBack"></button>
                <button type="button" class="button fa fa-arrow-left" title="صفحه بعد" tabindex="40" id="btnSubsystemFor"></button>
            </div>
            <div class="card-footer">
                <table id="subSystemTable" style="width: 60%; margin: auto; direction: rtl;" class="table">
                </table>
            </div>
        </div>


        <div class="card" id="pnlGhatatMasrafi" style="display: none;">
            <div class="card-header bg-primary text-white">ثبت قطعات مصرفی</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <label>مصرف در سال :</label>
                        <input id="txtGhatatPerYear" tabindex="42" class="form-control" />
                    </div>
                    <div class="col-md-6" style="position: relative;">
                        <label>نام قطعه پر مصرف :</label>
                        <div id="PartBadgeArea" style="position: relative;">
                            <input type="text" autocomplete="off" tabindex="41" class="form-control" id="txtPartsSearch" placeholder="جستجوی قطعه ..." />
                            <img src="assets/Images/loading.png" id="partsLoading" style="width: 20px; height: 20px; position: absolute; top: 7px; left: 7px; display: none;" />
                        </div>
                        <div id="PartsSearchResulat">
                            <div style="padding: 5px 28px 5px 5px; background-color: #dfecfe">
                                <input type="text" id="txtSubSearchPart" autocomplete="off" />
                                <img src="assets/Images/funnel.png" class="imgfilter" />
                            </div>
                            <div style="overflow: auto; width: 422px; max-height: 200px;">
                                <table id="gridParts" class="PartsTable">
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label>حداکثر :</label>
                        <input id="txtGhatatMax" tabindex="44" class="form-control" />
                    </div>
                    <div class="col-md-6">
                        <label>حداقل :</label>
                        <input id="txtGhatatMin" tabindex="43" class="form-control" />
                    </div>
                </div>

            </div>
            <div class="card-footer">
                <button class="button" style="display: none;" type="button" id="btnEditPart" onclick="editParts();">ویرایش</button>
                <button class="button" style="display: none;" type="button" id="btnCancelEditPart" onclick="ClearFields('pnlGhatatMasrafi');CancelDeletePart();">انصراف</button>
                <button type="button" id="btnAddMasrafi" class="button" onclick="addParts();" tabindex="47">
                    <span class="fa fa-plus" style="vertical-align: middle; margin-left: 5px;"></span>ثبت
                </button>
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnGhatatBack"></button>
                <button type="button" tabindex="48" title="صفحه بعد" class="button fa fa-arrow-left" id="btnGhatatFor"></button>
            </div>
            <div class="card-footer">
                <table class="table" id="gridGhataatMasrafi">
                </table>
            </div>
        </div>

        <div class="card" id="pnlDastoor" style="display: none;">
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="chEnergy" />
            <div class="card-header bg-primary text-white">دستورالعمل ایمنی و محیط زیستی</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <textarea class="form-control" tabindex="49" style="resize: none; min-height: 500px;" id="txtInstruc">
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
18-دقت کنید که دستگاه روغنریزی نداشته و هنگام کار درب دستگاه بسته باشد.</textarea>
                    </div>
                </div>
                <br />

            </div>
            <div class="card-footer">
                <button type="button" class="button fa fa-arrow-right" title="صفحه قبل" id="btnDastoorBack"></button>
                <label style="display: inline-block; color: red; margin-left: 20px; display: none;" id="lblwarn">** لطفا فیلد خالی را پر کنید **</label>
                <button id="btnFinalSave" style="outline: none;" type="button" class="button" onclick="SendTablesToDB();" tabindex="61">
                    ثبت نهایی
            <img id="btnFinalLoading" style="position: absolute; left: 50px; bottom: 28px; display: inline; width: 20px; display: none;" src="Images/loading.png" />
                </button>
            </div>
        </div>
    </div>

    <div id="addSubSystem" class="modal">
        <div class="modal-content">
            <span class="fa fa-remove" id="btncloseSubSystem"
                style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="card">
                <div class="card-header bg-primary text-white">ثبت اجزا جدید ماشین آلات</div>
                <div class="card-body">
                    <p>.لطفا در ثبت اجزا ماشین دقت فرمایید و از ثبت اجزا تکراری خوداری فرمایید <span class="fa fa-circle" style="color: red;"></span></p>
                    <div class="row" style="margin: 0;">
                        <div class="col-lg-2">
                            <button class="button" type="button" onclick="AddSubSystems();">+</button>
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

    <div id="ModalDeleteControl" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <span class="fa fa-remove" id="CloseDeleteControl" onclick="$(this).parent().parent().hide();"
                style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="card bg-danger text-white" style="margin-bottom: 0;">
                <div class="card-header bg-primary text-white" style="font-weight: 800;">حذف مورد کنترلی</div>
                <div class="card-body" style="text-align: center;">
                    <strong style="color: red;">** کاربر گرامی **</strong>
                    <p style="font-weight: 800;">
                        آیا مایل به حذف این مورد کنترلی هستید؟
                    </p>
                    <div style="text-align: center;">
                        <button class="button" type="button" onclick="DeleteControls();">حذف</button>
                        <button class="button" type="button" onclick="$('#ModalDeleteControl').hide();">انصراف</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="ModalDeletePart" class="modal" style="direction: rtl;">
        <div class="modal-content">
            <span class="fa fa-remove" id="CloseDeletePart" onclick="$(this).parent().parent().hide();"
                style="position: absolute; top: 10px; left: 10px; color: black; cursor: pointer; font-size: 15pt;"></span>
            <div class="card bg-danger text-white" style="margin-bottom: 0;">
                <div class="card-header bg-primary text-white" style="font-weight: 800;">حذف قطعه</div>
                <div class="card-body" style="text-align: center;">
                    <p style="font-weight: 800;">آیا مایل به حذف هستید؟</p>
                    <div style="text-align: center;">
                        <button class="button" type="button" onclick="DeletePart();">حذف</button>
                        <button class="button" type="button" onclick="$('#ModalDeletePart').hide();">انصراف</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/SubSystemBaseJS .js"></script>
    <script src="assets/js/SearchParts.js"></script>
    <script src="assets/js/MachineCode.js"></script>
    <script src="assets/js/copyMachineData.js"></script>
    <script src="assets/js/MachineBaseJS.js"></script>

</asp:Content>



