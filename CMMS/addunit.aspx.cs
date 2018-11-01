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
    public partial class addunit : System.Web.UI.Page
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

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtunitName.Text) || string.IsNullOrEmpty(txtunitmanager.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertVahed = new SqlCommand("if(select count(id) from i_units where unit_code = '"+txtUnitCode.Text+"')= 0 begin select 0 as ret insert into i_units (unit_name,unit_manager,unit_code)values('"+txtunitName.Text+"','"+txtunitmanager.Text+"','"+txtUnitCode.Text+"') end else select 1 as ret",cnn);
            
            if(insertVahed.ExecuteScalar().ToString()=="0")
            {
                insertVahed.ExecuteNonQuery();
                gridUnits.DataBind();
                txtunitName.Text = "";
                txtunitmanager.Text = "";
                txtUnitCode.Text = "";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            }
            
            else
            {
                txtUnitCode.Text = "";
                txtUnitCode.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "CodeError();", true);
            }
        }
/*
        protected void gridUnits_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "del")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["uid"] = gridUnits.DataKeys[index]["id"];
                cnn.Open();
                var getUnitName = new SqlCommand("select unit_name from i_units where id = "+Convert.ToInt32(ViewState["uid"])+" ",cnn);
                var unitName = getUnitName.ExecuteScalar();
                lblWarning.InnerText = "آیا با حذف بخش " + unitName + " موافق هستید؟";
                pnlDelUnit.Visible = true;
                gridUnits.Visible = false;
            }
        }
        
        protected void btnYes_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var delUnit = new SqlCommand("delete from i_units where id ="+ViewState["uid"]+" ",cnn);
            delUnit.ExecuteNonQuery();
            pnlDelUnit.Visible = false;
            gridUnits.Visible = true;
            gridUnits.DataBind();
        }

        protected void btnNo_OnClick(object sender, EventArgs e)
        {
            gridUnits.Visible = true;
            pnlDelUnit.Visible = false;
        }
        */
    }
}