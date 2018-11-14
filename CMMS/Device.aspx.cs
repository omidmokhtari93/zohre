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
            pnlDelete.Visible = false;
            if (string.IsNullOrEmpty(txtDeviceName.Text) || string.IsNullOrEmpty(txtDeviceCode.Text))
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var insertDevice = new SqlCommand("if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "' " +
                                              "or DeviceName='" + txtDeviceName.Text + "')= 0" +
                                              " begin select 0 as ret insert into i_devices (DeviceName,DeviceCode)values" +
                                              "('" + txtDeviceName.Text + "','" + txtDeviceCode.Text + "') end" +
                                              " else if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "')= 1" +
                                              " begin select 1 as ret end " +
                                              " else if(select count(id) from i_devices where DeviceName = '" + txtDeviceName.Text + "')= 1" +
                                              " begin select 2 as ret end ", cnn);

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
                pnlDelete.Visible = false;
                var index = int.Parse(e.CommandArgument.ToString());
                ViewState["id"] = gridDevice.DataKeys[index]["id"];
                cnn.Open();
                var getUser = new SqlCommand("SELECT [DeviceName],[DeviceCode] FROM [dbo].[i_devices] where id = " + Convert.ToInt32(ViewState["id"]) + " ", cnn);
                var rd = getUser.ExecuteReader();
                if (rd.Read())
                {
                    txtDeviceName.Text = rd["DeviceName"].ToString();
                    txtDeviceCode.Text = rd["DeviceCode"].ToString();
                    ViewState["code"] = rd["DeviceCode"].ToString();
                    btnSave.Visible = false;
                    btncancel.Visible = true;
                    btnedit.Visible = true;
                }
            }

            if (e.CommandName == "del")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                Session["deviceid"] = gridDevice.DataKeys[index]["DeviceCode"];
                pnlDelete.Visible = true;
            }
        }

        protected void btnedit_OnClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtDeviceName.Text) || string.IsNullOrEmpty(txtDeviceCode.Text) || txtDeviceCode.Text.Length != 3)
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "Err();", true);
                return;
            }
            cnn.Open();
            var UpdatetDevice = new SqlCommand("if(select count(id) from i_devices where (DeviceCode = '" + txtDeviceCode.Text + "' " +
                                               "and id<>" + Convert.ToInt32(ViewState["id"]) + ") or (DeviceName='" + txtDeviceName.Text + "' " +
                                               "and id<>" + Convert.ToInt32(ViewState["id"]) + ")) = 0 begin select 0 as ret UPDATE i_devices " +
                                               "SET DeviceName = '" + txtDeviceName.Text+"', DeviceCode = '"+txtDeviceCode.Text+"' WHERE " +
                                               "(id = "+Convert.ToInt32(ViewState["id"])+") " +
                                               " update m_machine set code = SUBSTRING(CAST(code AS nvarchar),1,2)+'"+txtDeviceCode.Text.Trim()+"'" +
                                               "+SUBSTRING(CAST(code AS nvarchar),6,3) " +
                                               " where SUBSTRING(CAST(code AS nvarchar), 3, 3) = " + ViewState["code"] + " " +
                                               "end" +
                                              " else if(select count(id) from i_devices where DeviceCode = '" + txtDeviceCode.Text + "' " +
                                               "and id<>" + Convert.ToInt32(ViewState["id"]) + ")= 1 begin select 1 as ret end " +
                                              " else if(select count(id) from i_devices where DeviceName = '" + txtDeviceName.Text + "' " +
                                               "and id<>" + Convert.ToInt32(ViewState["id"]) + ")= 1 begin select 2 as ret end ", cnn);

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
                cnn.Close();
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

        private void DeleteDevice()
        {
            cnn.Open();
            var dellsubsyestem = new SqlCommand("DELETE FROM m_fuel where Mid in(select id from m_machine where id in (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))) " +
                                               " DELETE FROM m_inst where Mid in (select id from m_machine where id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))  " +
                                               " DELETE FROM m_subsystem where Mid in (select id from m_machine where id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))  " +
                                               " DELETE FROM m_energy where Mid in (select id from m_machine where id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))  " +
                                               " DELETE FROM p_pmcontrols where idmcontrol in (SELECT dbo.m_control.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.m_control ON dbo.m_machine.id = dbo.m_control.Mid  " +
                                               " WHERE(dbo.m_machine.id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))) " +
                                               " DELETE FROM m_control where Mid in (select id from m_machine where id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))) " +
                                               " DELETE FROM p_forecast where m_partId in (SELECT dbo.m_parts.id AS id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.m_parts ON dbo.m_machine.id = dbo.m_parts.Mid  " +
                                               " WHERE(dbo.m_machine.id in  (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))  " +
                                               " DELETE FROM m_parts where Mid in (select id from m_machine where id in  (SELECT distinct(id) FROM dbo.m_machine WHERE  (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))  " +
                                               " DELETE FROM r_action where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in  (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_contract where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_personel where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in  (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_rdelay where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_rfail where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in  (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_tools where id_rep in(SELECT dbo.r_reply.id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code INNER JOIN  " +
                                               " dbo.r_reply ON dbo.r_request.req_id = dbo.r_reply.idreq  " +
                                               " WHERE(dbo.m_machine.id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))   " +
                                               " DELETE FROM r_reply WHERE idreq in(SELECT dbo.r_request.req_id  " +
                                               " FROM dbo.m_machine INNER JOIN  " +
                                               " dbo.r_request ON dbo.m_machine.id = dbo.r_request.machine_code  " +
                                               " WHERE(dbo.m_machine.id in   (SELECT distinct(id) FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))))  " +
                                               " DELETE FROM r_request WHERE machine_code in(select id from m_machine where id in   (SELECT id FROM dbo.m_machine WHERE (SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+")))  " +
                                               " delete from m_machine where id in (SELECT distinct(id) FROM dbo.m_machine WHERE(SUBSTRING(CAST(code AS nvarchar), 3, 3) = "+Session["deviceid"]+"))" +
                                               " DELETE FROM [dbo].[i_devices] where DeviceCode = " + Session["deviceid"] + "", cnn);
            dellsubsyestem.ExecuteNonQuery();
            cnn.Close();
        }

        protected void btnno_OnClick(object sender, EventArgs e)
        {
            pnlDelete.Visible = false;
        }

        protected void btnyes_OnClick(object sender, EventArgs e)
        {
            DeleteDevice();
            gridDevice.DataBind();
            pnlDelete.Visible = false;
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "save();", true);
        }
    }
}