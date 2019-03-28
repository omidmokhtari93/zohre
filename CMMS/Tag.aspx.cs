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
    public partial class Tag : System.Web.UI.Page
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
        }
      
        protected void btnSearchTag_OnClick(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSearchTag.Value))
            {
                SqlTags.FilterExpression = "chartag = " + txtSearchTag.Value + " ";
                gridTags.DataBind();
            }
            
        }

        protected void btnSearchCode_OnClick(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSearchCode.Value))
            {
                SqlTags.FilterExpression = "charcode = " + txtSearchCode.Value + " ";
                gridTags.DataBind();
            }
        }
        protected void btnSearchName_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtSearchName.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtSearchName.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlTags.FilterExpression = "subname like '%" + txtSearchName.Value + "%' OR subname like '%" + sub1 + "%' OR subname like '%" + sub2 + "%'";
            gridTags.DataBind();
        }

       

        protected void gridTags_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "sabt")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var tagId = (int) gridTags.DataKeys[index]["id"];
                var repairNumber = GetRepairNumber();
                var selectTagDetails = new SqlCommand(" SELECT ROW_NUMBER() OVER(ORDER BY dbo.m_subsystem.code) as row, m_subsystem.id, dbo.m_subsystem.code," +
                                                      " dbo.m_machine.name, dbo.subsystem.name AS subname " +
                                                      " FROM dbo.m_subsystem INNER JOIN " +
                                                      " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                                      " dbo.m_machine ON dbo.m_subsystem.Mid = dbo.m_machine.id " +
                                                      " WHERE(dbo.m_subsystem.code IS NOT NULL) AND  m_subsystem.id = " + tagId + " " +
                                                      " ORDER BY dbo.m_subsystem.code  ",cnn);
                var rd = selectTagDetails.ExecuteReader();
                if (rd.Read())
                {
                    txtRepairNumber.Value = repairNumber.ToString();
                    TagID.Value = tagId.ToString();
                    txtRepairedSub.Value = rd["subname"].ToString();
                    txtTagNumber.Value = rd["code"].ToString();
                    pnlMachineTag.Visible = false;
                    pnlRepairRecord.Visible = true;
                }
            }
            if (e.CommandName == "show")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                Session["subtagId"] = (int)gridTags.DataKeys[index]["id"];
                cnn.Open();
                var subInfo = new SqlCommand("SELECT ROW_NUMBER() OVER(ORDER BY dbo.m_subsystem.code) as row, m_subsystem.id, dbo.m_subsystem.code," +
                                             " dbo.m_machine.name, dbo.subsystem.name AS subname " +
                                             " FROM dbo.m_subsystem INNER JOIN " +
                                             " dbo.subsystem ON dbo.m_subsystem.subId = dbo.subsystem.id INNER JOIN " +
                                             " dbo.m_machine ON dbo.m_subsystem.Mid = dbo.m_machine.id " +
                                             " WHERE(dbo.m_subsystem.code IS NOT NULL) AND  m_subsystem.id=" + Session["subtagId"] + " " +
                                             " ORDER BY dbo.m_subsystem.code", cnn);
                var rd = subInfo.ExecuteReader();
                if (rd.Read())
                {
                    lblSubtagName.InnerText = rd["subname"].ToString();
                    lblSubtagPelak.InnerText = rd["code"].ToString();
                } 
                gridRepairRecords.DataBind();
                pnlMachineTag.Visible = false;
                pnlShowRepairRecord.Visible = true;
            }
        }

        private int GetRepairNumber()
        {
            cnn.Open();
            var selectRepNum = new SqlCommand("SELECT case when COUNT(rep_num)= 0 then  100  else MAX(rep_num)+1 end as id FROM s_subhistory",cnn);
            return Convert.ToInt32(selectRepNum.ExecuteScalar());
        }
        protected void btnBack_OnClick(object sender, EventArgs e)
        {
            pnlMachineTag.Visible = true;
            pnlRepairRecord.Visible = false;
        }

        protected void btnBackToSubtag_OnClick(object sender, EventArgs e)
        {
            pnlMachineTag.Visible = true;
            pnlShowRepairRecord.Visible = false;
        }

        protected void gridRepairRecords_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "show")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var subtagId = (int)gridRepairRecords.DataKeys[index]["subid"];
                Response.Write("<script>window.open ('RepairRecordReview.aspx?subtagid=" + subtagId + "','_blank');</script>");
            }
        }
    }
}