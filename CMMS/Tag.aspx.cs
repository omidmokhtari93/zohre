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

        protected void btnSabt_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var insert = new SqlCommand("INSERT INTO [dbo].[s_subtag]([subid],[tag])VALUES("+hdSubId.Value+" , "+txtsubCode.Value+")", cnn);
            insert.ExecuteNonQuery();
            gridTags.DataBind();
            txtsubCode.Value = "";
            ScriptManager.RegisterStartupScript(Page, GetType(), "script", "save();", true);
        }

        protected void gridTags_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "sabt")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var tagId = (int) gridTags.DataKeys[index]["id"];
                var repairNumber = GetRepairNumber();
                var selectTagDetails = new SqlCommand("SELECT dbo.s_subtag.id, dbo.subsystem.name, dbo.s_subtag.tag "+
                                                      "FROM dbo.s_subtag INNER JOIN dbo.subsystem ON dbo.s_subtag.subid = dbo.subsystem.id" +
                                                      " where s_subtag.id = "+ tagId+ " ",cnn);
                var rd = selectTagDetails.ExecuteReader();
                if (rd.Read())
                {
                    txtRepairNumber.Value = repairNumber.ToString();
                    TagID.Value = tagId.ToString();
                    txtRepairedSub.Value = rd["name"].ToString();
                    txtTagNumber.Value = rd["tag"].ToString();
                    pnlMachineTag.Visible = false;
                    pnlRepairRecord.Visible = true;
                }
            }
            if (e.CommandName == "show")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                Session["subtagId"] = (int)gridTags.DataKeys[index]["id"];
                cnn.Open();
                var subInfo = new SqlCommand("SELECT dbo.subsystem.name, dbo.s_subtag.tag FROM dbo.s_subtag" +
                                             " INNER JOIN dbo.subsystem ON dbo.s_subtag.subid = dbo.subsystem.id where s_subtag.id ="+ Session["subtagId"] + " ",cnn);
                var rd = subInfo.ExecuteReader();
                if (rd.Read())
                {
                    lblSubtagName.InnerText = rd["name"].ToString();
                    lblSubtagPelak.InnerText = rd["tag"].ToString();
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