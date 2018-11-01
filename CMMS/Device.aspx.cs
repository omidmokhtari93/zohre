using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;

using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class Device : System.Web.UI.Page
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
            if (string.IsNullOrEmpty(txtDeviceName.Text) || string.IsNullOrEmpty(txtDeviceCode.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertDevice = new SqlCommand("if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "' or DeviceName='" + txtDeviceName.Text + "')= 0 begin select 0 as ret insert into i_devices (DeviceName,DeviceCode)values('" + txtDeviceName.Text + "','" + txtDeviceCode.Text + "') end" +
                                              " else if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "')= 1 begin select 1 as ret end " +
                                              " else if(select count(id) from i_devices where DeviceName = '" + txtDeviceName.Text + "')= 1 begin select 2 as ret end ", cnn);

            if (insertDevice.ExecuteScalar().ToString() == "0")
            {
                insertDevice.ExecuteNonQuery();
                gridDevice.DataBind();
                txtDeviceName.Text = "";
                txtDeviceCode.Text = "";
                
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            }

            else if (insertDevice.ExecuteScalar().ToString() == "1")
            {
                txtDeviceCode.Text = "";
                txtDeviceCode.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "CodeError();", true);
            }
            else if (insertDevice.ExecuteScalar().ToString() == "2")
            {
                txtDeviceName.Text = "";
                txtDeviceName.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "NameError();", true);
            }
        }

        protected void gridDevice_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ed")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridDevice.DataKeys[index]["id"];
                cnn.Open();
                var getUser = new SqlCommand("SELECT [DeviceName],[DeviceCode] FROM [dbo].[i_devices] where id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (rd.Read())
                {
                    txtDeviceName.Text = rd["DeviceName"].ToString();
                    txtDeviceCode.Text = rd["DeviceCode"].ToString();
                    
                    
                    btnSave.Visible = false;
                    btncancel.Visible = true;
                    btnedit.Visible = true;
                }
            }
        }

        protected void btnedit_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtDeviceName.Text) || string.IsNullOrEmpty(txtDeviceCode.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var UpdatetDevice = new SqlCommand("if(select count(id) from i_devices where (DeviceCode = '" + txtDeviceCode.Text + "' and id<>" + Convert.ToInt32(ViewState["id"]) + ") or (DeviceName='" + txtDeviceName.Text + "' and id<>" + Convert.ToInt32(ViewState["id"]) + ")) = 0 begin select 0 as ret UPDATE i_devices SET DeviceName = '" + txtDeviceName.Text+"', DeviceCode = '"+txtDeviceCode.Text+"' WHERE (id = "+Convert.ToInt32(ViewState["id"])+") end" +
                                              " else if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "' and id<>" + Convert.ToInt32(ViewState["id"]) + ")= 1 begin select 1 as ret end " +
                                              " else if(select count(id) from i_devices where DeviceName = '" + txtDeviceName.Text + "' and id<>" + Convert.ToInt32(ViewState["id"]) + ")= 1 begin select 2 as ret end ", cnn);

            if (UpdatetDevice.ExecuteScalar().ToString() == "0")
            {
                UpdatetDevice.ExecuteNonQuery();
                gridDevice.DataBind();
                txtDeviceName.Text = "";
                txtDeviceCode.Text = "";
                btnSave.Visible = true;
                btncancel.Visible = false;
                btnedit.Visible = false;
                txtDeviceName.Text = "";
                txtDeviceCode.Text = "";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
            }

            else if (UpdatetDevice.ExecuteScalar().ToString() == "1")
            {
                txtDeviceCode.Text = "";
                txtDeviceCode.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "CodeError();", true);
            }
            else if (UpdatetDevice.ExecuteScalar().ToString() == "2")
            {
                txtDeviceName.Text = "";
                txtDeviceName.Focus();
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "NameError();", true);
            }
        }

        protected void btncancel_OnClick(object sender, EventArgs e)
        {
            btnSave.Visible = true;
            btncancel.Visible = false;
            btnedit.Visible = false;
            txtDeviceName.Text = "";
            txtDeviceCode.Text = "";
        }

        
    }
}