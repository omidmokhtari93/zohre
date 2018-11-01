using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class MainDesign : System.Web.UI.MasterPage
    {
        private readonly SqlConnection _cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();
            try
            {
                var identity = (FormsIdentity)Context.User.Identity;
                var i = identity.Ticket.UserData;
                var data = i.Split(",".ToCharArray());
                if (data[0].Trim() == "administrator")
                {
                    return;
                }
                CheckUserLevel(data);
                GetTimeDate(data);
            }
            catch (Exception)
            {
                Response.Redirect("login.aspx");
            }
        }

        private void CheckUserLevel(string[] data)
        {
           
            switch (data[1])
            {
                case "0":
                    break;
                case "1":
                    arshiv.Visible = false;
                    machine.Visible = false;
                    reprequest.Visible = false;
                    DReport.Visible = false;
                    services.Visible = false;
                    manager.Visible = false;
                    break;
                case "2":
                    arshiv.Visible = false;
                    reports.Visible = false;
                    requests.Visible = false;//زیر منوی درخواست تعمیر
                    repairdo.Visible = false;//زیر منوی تعمیرات انجام شده
                    machine.Visible = false;
                    dailyreports.Visible = false;
                    services.Visible = false;
                    manager.Visible = false;
                    break;
            }
        }
        private void GetTimeDate(string[] data)
        {
            lblDate.Text = TodayShamsiDateTime();
            _cnn.Open();
            var userName = new SqlCommand("select name from users where id = " + Convert.ToInt32(data[0]) + " ", _cnn);
            var user_name = userName.ExecuteScalar().ToString();
            lbl_userName.Text = user_name + " عزیز خوش آمدید.";
            _cnn.Close();
        }
        public static string TodayShamsiDateTime()
        {
            ShamsiCalendar.ChangCulter(ShamsiCalendar.CulterType.Fa);
            var today = DateTime.Now.ToString("dddd d MMMM yyyy");
            return $"{today}";
        }
        protected void btn_contractor_Click(object sender, EventArgs e)
        {
            Response.Redirect("Contractor.aspx");
        }

        protected void btn_stops_Click(object sender, EventArgs e)
        {
            Response.Redirect("intrupt.aspx");
        }

        protected void btn_personel_OnClick(object sender, EventArgs e)
        {
           Response.Redirect("personel.aspx");
        }

        protected void btn_addunit_Click(object sender, EventArgs e)
        {
            Response.Redirect("addunit.aspx");
        }

        protected void btnexit_Onclick(object sender, EventArgs e)
        {
            var limit = Request.Cookies.Count;
            for (var i = 0; i < limit; i++)
            {
                var cookieName = Request.Cookies[i].Name;
                var aCookie = new HttpCookie(cookieName) { Expires = DateTime.Now.AddDays(-1) };
                Response.Cookies.Add(aCookie);
            }
            Response.Redirect("login.aspx");
        }

        protected void btnother_repair_Click(object sender, EventArgs e)
        {
            Response.Redirect("otherRepairRequest.aspx");
        }

        protected void btn_reqrepair_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("repairRequest.aspx");
        }

        protected void btn_repairs_Click(object sender, EventArgs e)
        {
            Response.Redirect("repairs.aspx");
        }

        protected void btn_newdevice_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("newMachine.aspx");
        }

        protected void btnRepairRequest_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("repairRequest.aspx");
        }

        protected void btnUserManagment_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("userManagment.aspx");
        }
        protected void btnHazine_Click(object sender, EventArgs e)
        {
            Response.Redirect("primryCost.aspx");
        }

        protected void btn_editMachine_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("editMachine.aspx");
        }

        protected void show_repairRequests_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("ShowRequests.aspx");
        }

        protected void btn_subsystem_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("SubSystem.aspx");
        }

        protected void btn_device_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("Device.aspx");
        }

        protected void btn_tag_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("Tag.aspx");
        }

        protected void show_allRepairs_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("RepairHistory.aspx");
        }

        protected void btnDailyPM_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("DailyPm.aspx");
        }

        protected void btnDailyCM_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("DailyCM.aspx");
        }

        protected void btnProgram_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("Program.aspx");
        }

        protected void btn_DailyReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("DailyReport.aspx");
        }

        protected void btn_showDailyReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("ShowDailyReport.aspx");
        }

        protected void btn_machineReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("MachineReports.aspx");
        }

        protected void btn_PartReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("PartsReport.aspx");
        }

        protected void btn_RepairReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("RepairReport.aspx");
        }

        protected void btn_PersonelReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("PersonelReport.aspx");
        }

       
        protected void btn_FinancialReport_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("FinancialReport.aspx");
        }

        protected void btn_partsAcc_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("PartsAcc.aspx");
        }

      
        protected void btn_MttRep_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("MttReport.aspx");
        }

        protected void btnCheckedPM_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("PmChecked.aspx");
        }

        protected void btnCheckedCm_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("CmChecked.aspx");    
        }

        protected void btn_Lines_OnClick(object sender, EventArgs e)
        {
            Response.Redirect("Lines.aspx");
        }

        protected void btn_effect_OnClick(object sender, EventArgs e)
        {
           Response.Redirect("Effective.aspx");
        }

        
        protected void btn_StopReport_OnClick(object sender, EventArgs e)
        {
           Response.Redirect("StopReport.aspx");
        }

        protected void btn_dailyWorkTime_OnClick(object sender, EventArgs e)
        {
           Response.Redirect("DailyWork.aspx");
        }
    }
}