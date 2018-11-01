using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class DailyCM : System.Web.UI.Page
    {
        SqlConnection cnn = new SqlConnection(ConfigurationManager.ConnectionStrings["CMMS"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
            TodayDateTime.Value = ShamsiCalendar.ShamsiDateTime();
        }

        protected void drUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            if (drUnits.SelectedValue == "-1")
            {
                SqlDailyCM.FilterExpression = "";
                SqlDailyCM.DataBind();
                gridDailyCM.DataBind();
                return;
            }
            SqlDailyCM.FilterExpression = "unitt = " + drUnits.SelectedValue + "  ";
            SqlDailyCM.DataBind();
            gridDailyCM.DataBind();
        }

        protected void btnSearchMachine_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtMachineName.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtMachineName.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlDailyCM.FilterExpression = " name like '%" + txtMachineName.Value + "%' OR name like '%" + sub1 + "%' OR name like '%" + sub2 + "%'";
            SqlDailyCM.DataBind();
            gridDailyCM.DataBind();
        }

        protected void gridDailyCM_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            //e.Row.Cells[0].Visible = false;
        }

        protected void btnChangeDate_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var updateTarikh = new SqlCommand("UPDATE [dbo].[p_forecast] SET [tarikh] = '"+txtChangeDate.Value+"'  WHERE id ="+ForecastId.Value+" ",cnn);
            updateTarikh.ExecuteNonQuery();
            gridDailyCM.DataBind();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }

        protected void btnChangePart_OnServerClick(object sender, EventArgs e)
        {
            cnn.Open();
            var insertForeCast = new SqlCommand("UPDATE [dbo].[p_forecast] SET [act] = 1 where id = "+ForecastId.Value+" " +
                                                "INSERT INTO [dbo].[p_forecast]([m_partId],[tarikh],[PartId],[act])VALUES" +
                                                "("+M_PartId.Value+",'"+txtPartchangeDate.Value+"',"+Part_Id.Value+",0)",cnn);
            insertForeCast.ExecuteNonQuery();
            gridDailyCM.DataBind();
            Response.Redirect("repairRequest.aspx?mid=" + Crypto.Crypt(M_id.Value) + "&ucode=" + Crypto.Crypt(Unit_Code.Value));
        }
    }
}