using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class RepairRecordReview : System.Web.UI.Page
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
            var subtagId = Request.Params.Get("subtagId");
            if (string.IsNullOrEmpty(subtagId)) return;
            try
            {
                cnn.Open();
                var selectData = new SqlCommand("SELECT dbo.m_subsystem.id, dbo.subsystem.name, dbo.m_subsystem.code, dbo.s_subhistory.tarikh, dbo.s_subhistory.rep_num," +
                                                " dbo.s_subhistory.comment, dbo.s_subhistory.info_rep, dbo.s_subhistory.CR,  " +
                                                " dbo.i_lines.line_name AS nline, dbo.i_units.unit_name AS nunit, i_lines_1.line_name AS rline, i_units_1.unit_name AS runit " +
                                                " FROM dbo.m_subsystem INNER JOIN " +
                                                " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                                " dbo.s_subhistory ON dbo.m_subsystem.id = dbo.s_subhistory.tagid INNER JOIN " +
                                                " dbo.i_units ON dbo.s_subhistory.new_unit = dbo.i_units.id INNER JOIN " +
                                                " dbo.i_lines ON dbo.s_subhistory.new_line = dbo.i_lines.id INNER JOIN " +
                                                " dbo.i_units AS i_units_1 ON dbo.s_subhistory.rec_unit = i_units_1.id INNER JOIN " +
                                                " dbo.i_lines AS i_lines_1 ON dbo.s_subhistory.rec_line = i_lines_1.id " +
                                                " WHERE(dbo.s_subhistory.id = "+subtagId+") ", cnn);
                var rd = selectData.ExecuteReader();
                if (rd.Read())
                {
                    lblRepNumber.InnerText = rd["rep_num"].ToString();
                    lblRepairDate.InnerText = rd["tarikh"].ToString();
                    lblToolName.InnerText = rd["name"].ToString();
                    lblTagNumber.InnerText = rd["code"].ToString();
                    if (Convert.ToInt32(rd["CR"]) == 1)
                    {
                        chkrepiar.Checked = true;
                    }
                    else
                    {
                        chkchange.Checked = true;
                    }
                    repairExplain.InnerText = rd["info_rep"].ToString();
                    lblComment.InnerText = rd["comment"].ToString();
                    runit.InnerText = rd["runit"].ToString();
                    rline.InnerText = rd["rline"].ToString();
                    nline.InnerText = rd["nline"].ToString();
                    nunit.InnerText = rd["nunit"].ToString();
                }
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "cancel();", true);
            }
        }
    }
}