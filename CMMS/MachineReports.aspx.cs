﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Globalization;
using System.Configuration;
using System.Data;
using System.IO;

namespace CMMS
{
    public partial class MachineReports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            switch (UserAccess.CheckAccess())
            {
                case 0:
                case 1:
                    break;
                default:
                    Response.Redirect("login.aspx");
                    break;

            }
        }


    }
}