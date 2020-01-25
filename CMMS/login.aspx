<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="CMMS.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link href="assets/css/mdbootstrap.css" rel="stylesheet" />
    <script src="assets/js/jquery-3.3.1.min.js"></script>
    <script src="assets/js/jquery.easing.1.3.js"></script>
    <script src="assets/js/jquery.easing.compatibility.js"></script>
    <link href="assets/css/loginStyles.css" rel="stylesheet" />
    <link href="assets/css/font-awesome.min.css" rel="stylesheet" />
    <script src="assets/js/notify.min.js"></script>
    <link href="assets/Images/icon.ico" rel="shortcut icon"/>    
    <title>سامانه نگهداری و تعمیر تجهیزات برنا</title>
    <style>
    </style>
</head>
<body class="backgroundpattern">
    <form id="form1" runat="server">
        <div class="unselectable headerArea">
            <img src="assets/Images/1.png" class="headerLogo"/>
        </div>
        <div id="pnl_login">
            <div class="loginstyle">
                <div class="card" style="width: 350px; position: relative;">
                    <div class="card-header bg-primary text-white"><label>ورود به سیستم</label></div>
                    <div class="card-body">
                        <br/>
                        <div class="input-container">
                            <input type="text" tabindex="1" id="UserName" />
                            <label class="unselectable userNameLabel">نام کاربری</label>
                        </div>
                        <br/>
                        <div class="input-container">
                            <button class="fa fa-eye" title="نمایش رمز عبور" type="button" id="showPassword" ></button>
                            <input type="password" tabindex="2" id="Password"/>
                            <label class="unselectable PassLabel">رمز عبور</label>
                        </div>
                        <div style=" width: 100%;">
                            <div class="forgetPassButton">
                                <a id="btnForgetPasword" onclick="RememberPassword();">رمز عبورم را فراموش کرده ام</a>
                                <div class="fa fa-lock"></div>
                            </div>
                        </div>
                        <br/><br/><br/><br/>
                        <button type="button" class="EnterButton" tabindex="3" onclick="auth($('.loginstyle'));" id="btnLogin">ورود</button>
                    </div>
                    <div id="loginloading">
                        <img class="loading-image" src="assets/Images/loading.gif"/>
                    </div>
                </div>
            </div>
        </div> 
        
        <div class="card forgetstyle" id="pnlForgetPassword">
            <div class="card-header bg-primary text-white">بازیابی رمز عبور</div>
            <div class="card-body text-right">
                <p class="sans-xsmall">.لطفا شماره تلفن همراه و آدرس ایمیل خود را وارد نمایید</p>
                <p class="sans-xsmall">.شماره تلفن همراه و ایمیل وارد شده می بایست شماره و ایمیل ثبت شده در سامانه باشد</p>
                <p class="sans-xsmall">.درصورتی که هر یک از فیلدهای زیر را فراموش کرده اید با پشتیبان برنامه تماس بگیرید</p>
                <div class="linesep"></div>
                <h6>تلفن همراه</h6>
                <div class="forget_pass mb-2">
                    <label id="phoneValidation"></label>
                    <input type="text" tabindex="1" id="txtPhoneNumber"/>
                </div>
                <h6>آدرس ایمیل</h6>
                <div class="forget_pass">
                    <label id="emailValidation"></label>
                    <input type="text" tabindex="2" id="txtEmailAddress" autocomplete="off"/>
                </div>
                <div class="row mt-2">
                    <div class="col-md-6">
                        <button type="button" class="btn btn-light btn-block" id="btn_cancel" onclick="login();">برگشت</button>    
                    </div>
                    <div class="col-md-6">
                        <button type="button" class="btn btn-success btn-block" id="btn_sendEmail" onclick="SendMail($('#pnlForgetPassword'));">ارسال ایمیل</button>    
                    </div>
                </div>
            </div>
            <div id="Emailloading">
                <img class="loading-image" src="assets/Images/loading.gif"/>
            </div>
        </div>

        <div class="unselectable footerArea">
            <label class="footerCompany">طراحی و اجرا توسط شرکت برنا گستر طوس</label>
        </div>
    </form>
<script src="assets/js/loginJS.js"></script>
</body>
</html>
