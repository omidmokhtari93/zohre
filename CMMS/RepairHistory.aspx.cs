using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CMMS
{
    public partial class RepairHistory : System.Web.UI.Page
    {
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

        protected void gridRepiarHistory_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "show")
            {
                var index = int.Parse(e.CommandArgument.ToString());
                var reqid = (int)gridRepiarHistory.DataKeys[index]["idreq"];
                Response.Write("<script>window.open ('ReplyPrint.aspx?reqid=" + Crypto.Crypt(reqid.ToString()) + "','_blank');</script>");
            }
        }

        protected void btnSearchCode_OnClick(object sender, EventArgs e)
        {
            SqlRequests.FilterExpression = " vcode like '%" + txtCodeSearch.Value + "%' ";
            SqlRequests.DataBind();
            gridRepiarHistory.DataBind();
        }

        protected void btnSearch_OnClick(object sender, EventArgs e)
        {
            var sub1 = txtSearch.Value.Replace("ک", "ك").Replace("ی", "ي");
            var sub2 = txtSearch.Value.Replace("ك", "ک").Replace("ي", "ی").Replace("ﯼ", "ی").Replace("ى", "ی").Replace("ة", "ه");
            SqlRequests.FilterExpression = " name like '%" + txtSearch.Value + "%' OR name like '%" + sub1 + "%' OR name like '%" + sub2 + "%'";
            SqlRequests.DataBind();
            gridRepiarHistory.DataBind();
        }
    }
}