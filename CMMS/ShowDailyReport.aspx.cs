using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class ShowDailyReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                case 1:
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
        }

        protected void btnSearchTarikh_OnClick(object sender, EventArgs e)
        {
            SqlDailyReports.FilterExpression = "tarikh > '" + txtStartDate.Value + "' and tarikh < '" + txtEndDate.Value + "' ";
            SqlDailyReports.DataBind();
        }

        protected void btnSearchExplain_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtReport.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtReport.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlDailyReports.FilterExpression = "reportexp  like '%" + txtReport.Value + "%' OR reportexp  like '%" + sub1 + "%'" +
                                               " OR reportexp  like '%" + sub2 + "%'";
            SqlDailyReports.DataBind();
        }

        protected void btnSearchProducer_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtProducer.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtProducer.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlDailyReports.FilterExpression = "rp like '%" + txtProducer.Value + "%' or rp like '%" + sub1 + "%' or rp like '%" + sub2 + "%'";
            SqlDailyReports.DataBind();
        }

        protected void gridDailyReport_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Print")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var dailyId = (int)gridDailyReport.DataKeys[index]["id"];
                var hashedMid = Crypto.Crypt(dailyId.ToString());
                Response.Write("<script>window.open ('DailyReportPrint.aspx?id=" + hashedMid + "','_blank');</script>");
            }
        }
    }
}