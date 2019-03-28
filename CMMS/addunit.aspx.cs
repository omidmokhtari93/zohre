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
                gridUnits.DataBind();
            }
            
            else
            {
                txtUnitCode.Text = "";
                txtUnitCode.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "CodeError();", true);
            }
        }

        protected void gridUnits_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var index = int.Parse(e.CommandArgument.ToString());
            ViewState["uid"] = gridUnits.DataKeys[index]["id"];
            ViewState["Ucode"] = gridUnits.DataKeys[index]["unit_code"];
            if (e.CommandName == "del")
            {
               
                cnn.Open();
                var getUnitName = new SqlCommand("select max(id) from m_machine where loc=(select unit_code from i_units where id = "+Convert.ToInt32(ViewState["uid"])+") ",cnn);
                object idd = getUnitName.ExecuteScalar();
                if (idd.Equals(DBNull.Value))
                {
                    var delunit=new SqlCommand("delete from i_units where id =" + Convert.ToInt32(ViewState["uid"]) + "", cnn);
                    delunit.ExecuteNonQuery();
                    gridUnits.DataBind();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "DellError();", true);
                }
            }
            else if (e.CommandName == "edt")
            {
                cnn.Open();
                var getUnit =
                    new SqlCommand(
                        "SELECT unit_name,unit_manager,unit_code FROM [dbo].[i_units] where id = " +
                        Convert.ToInt32(ViewState["uid"]) + " ", cnn);
                var rd = getUnit.ExecuteReader();
                if (!rd.Read()) return;
                txtunitName.Text = rd["unit_name"].ToString();
                txtUnitCode.Text = rd["unit_code"].ToString();
                txtunitmanager.Text = rd["unit_manager"].ToString();
                btnEdit.Visible = true;
                btnCancel.Visible = true;
                btnSave.Visible = false;
                cnn.Close();
            }
        }

        protected void btnEdit_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtunitName.Text) || string.IsNullOrEmpty(txtUnitCode.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var cmdrepeatitive =new SqlCommand("select id from i_units where unit_code='"+ViewState["Ucode"].ToString() + "' and id <> "+Convert.ToInt32(ViewState["uid"])+" ", cnn);
            object idU = cmdrepeatitive.ExecuteScalar();
            if (idU == null)
            {
                var unitEdit = new SqlCommand("UPDATE [dbo].[i_units] " +
                                                "SET[unit_name] = '" + txtunitName.Text + "' " +
                                                ",[unit_code] = '" + txtUnitCode.Text + "' " +
                                                ",[unit_manager] ='" + txtunitmanager.Text + "' " +                                               
                                                "WHERE id = " + ViewState["uid"] + "" +
                                              "Update m_machine Set code='" + txtUnitCode.Text + "'+SUBSTRING(code,3,6), loc='" + txtUnitCode.Text+"' where loc='"+ViewState["Ucode"].ToString()+"'" +
                                              "Update r_request Set unit_id='" + txtUnitCode.Text + "' where unit_id='" + ViewState["Ucode"].ToString() + "'", cnn);
                unitEdit.ExecuteNonQuery();
                gridUnits.DataBind();

                btnSave.Visible = true;
                btnCancel.Visible = false;
                btnEdit.Visible = false;
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
                txtunitName.Text = "";
                txtUnitCode.Text = "";
                txtunitmanager.Text = "";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "DellError();", true);
            }
           
           
        }

        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            txtunitName.Text = "";
            txtUnitCode.Text = "";
            txtunitmanager.Text = "";
            btnEdit.Visible = false;
            btnCancel.Visible = false;
            btnSave.Visible = true;
        }
    }
}