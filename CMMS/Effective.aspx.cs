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
  
    public partial class Effective : System.Web.UI.Page
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

        protected void btninsert_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var cmdEffect = new SqlCommand("insert into m_effect (main_mid,sub_mid) values (" + drmain.SelectedValue + "," + drsub.Text + ")", cnn);
            cmdEffect.ExecuteNonQuery();
           
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            grideffect.DataBind();
        }

        protected void grideffect_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "del")
            {

                var index = int.Parse(e.CommandArgument.ToString());
                var grideffectDataKey = grideffect.DataKeys[index];
                if (grideffectDataKey != null) ViewState["id"] = grideffectDataKey["id"];
                cnn.Open();
                var delrowEffect =
                    new SqlCommand("delete from m_effect where id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                delrowEffect.ExecuteNonQuery();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
                grideffect.DataBind();

            }
        }

        protected void drunit_SelectedIndexChanged(object sender, EventArgs e)
        {
           drmain.Items.Clear();
           drmain.Items.Insert(0, new ListItem("دستگاه را انتخاب نمایید", "-1"));
        }

        protected void drunitsub_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            drsub.Items.Clear();
            drsub.Items.Insert(0, new ListItem("دستگاه را انتخاب نمایید", "-1"));
        }
    }
}