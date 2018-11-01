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
    public partial class Lines : System.Web.UI.Page
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

        protected void gridLines_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {

                var index = int.Parse(e.CommandArgument.ToString());
                var gridLinesDataKey = gridLines.DataKeys[index];
                if (gridLinesDataKey != null) ViewState["id"] = gridLinesDataKey["id"];
                cnn.Open();
                var getrequest =
                    new SqlCommand(
                        "SELECT i_lines.id, i_lines.line_name FROM i_lines  where i_lines.id = " +
                        Convert.ToInt32(ViewState["id"]) + " ", cnn);

                var rd = getrequest.ExecuteReader();

                if (rd.Read())
                {
                   
                        txtline.Text = rd["line_name"].ToString();
                        btninsert.Visible = false;
                        btncancel.Visible = true;
                        btnedit.Visible = true; 
                }
                cnn.Close();
            }
        }

        protected void btninsert_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtline.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var cmdline=new SqlCommand("insert into i_lines (line_name) values ('"+txtline.Text+"')", cnn);
            cmdline.ExecuteNonQuery();
            txtline.Text = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            gridLines.DataBind();

        }

        protected void btnedit_OnClick(object sender, EventArgs e)
        {
            cnn.Open();
            var cmdline = new SqlCommand("update i_lines set  line_name='" + txtline.Text + "' where id="+ Convert.ToInt32(ViewState["id"]) + " ", cnn);
            cmdline.ExecuteNonQuery();
            txtline.Text = "";
            
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            gridLines.DataBind();
            btncancel.Visible = false;
            btnedit.Visible = false;
            btninsert.Visible = true;
        }

        protected void btncancel_OnClick(object sender, EventArgs e)
        {
            txtline.Text = "";
            
            btncancel.Visible = false;
            btnedit.Visible = false;
            btninsert.Visible = true;
        }
    }
}