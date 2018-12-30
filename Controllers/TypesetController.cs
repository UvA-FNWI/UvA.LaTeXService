using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace UvA.LaTeXService.Controllers
{
    [Route("typeset")]
    [ApiController]
    public class TypesetController : ControllerBase
    {
        static string Folder = "/tmp";

        [HttpPost]
        public ActionResult Post(IList<IFormFile> files)
        {
            foreach (var f in files)
            {
                using (var stream = System.IO.File.OpenWrite(Path.Combine(Folder, f.FileName))) {
                    f.CopyTo(stream);
                }
            }
            var tex = files.First(f => f.FileName.EndsWith(".tex"));
            Process.Start(new ProcessStartInfo("xelatex", "-interaction=nonstopmode " + tex.FileName) { WorkingDirectory = Folder }).WaitForExit();
            Process.Start(new ProcessStartInfo("xelatex", "-interaction=nonstopmode " + tex.FileName) { WorkingDirectory = Folder }).WaitForExit();
            return PhysicalFile(Path.Combine(Folder, Path.GetFileNameWithoutExtension(tex.FileName) + ".pdf"), "application/pdf");
        }
    }
}
