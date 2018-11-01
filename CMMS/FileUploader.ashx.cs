using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace CMMS
{
    /// <summary>
    /// Summary description for FileUploader
    /// </summary>
    public class FileUploader : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            var fileName = Guid.NewGuid();
            var filePath = "";
            if (context.Request.Files.Count > 0)
            {
                var files = context.Request.Files;
                if (files.Count != 0)
                {
                    var file = files[0];
                    var fileExtension = Path.GetExtension(file.FileName);
                    var fname = Path.Combine(context.Server.MapPath("~/files/"), fileName + fileExtension);
                    filePath = "~/files/" + fileName + fileExtension;
                    file.SaveAs(fname);
                }
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(filePath);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}