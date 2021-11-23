# Website on  Microsoft machine step by step
## step 1 
On my local pc i installed visual studio 2019 with ASP.NET core web Application
## step 2
Create new asp.net web app project, give the project a name and the path of the new  proj 
## step 3
A folder was created with basic templates, no binary files 
## step 4
After pressing on play (IIS express) binary files were created in \bin\Debug\net5.0. <br /> the template was compiled in debug configuration and a basic web app is running now on localhost:44321
## step 5 
In order to compile the projec in release configuration i choase from the  bar of visual studio the option release
and right click on project folder -> rebeald.<br />
a new folder binary folder named "release" was created with binary files configured as relese.
## step 6
In order to get access to nuget libraries i hade to configure : tools -> package sources -> add new source -> source :https://www.nuget.org/api/v2 -> give name and update . 
## step 7
Install packege  “Newtonsoft.Json” by tools -> noogetPackegeManger -> <br /> manege nuGet Packeges for selution -> browse and search for “Newtonsoft.Json” -> check box name of project ->.<br />
in order to see in the files that packege was added i did rebaled. <br />
in the file "name_of_project.csproj" new line was aded that indicates that packes was installed it looks like this:<br />
```html
 <PackageReference Include="Newtonsoft.Json" Version="13.0.1" />
 ```
## step 8 
In order to have binary files wich can run in a diferent platfrom than visual stuio (iis my case) i have to right click on proj folder and select poblish. i select  a path  to keep those files wich afterwards will be used on my windows machine with iis .
## step 9
configuer windows server
in server maneger -> mange -> add roles and feater -> server roles -> check web iis -> next and install
because in my local pc i installed .net core5 i had to install same version on windows server.
## step 10 
start application pool :
open iis -> right click on application pool -> add aplication pool -> give name ->select not intgrated
on sites folder right click -> add new site -> give site name -> path very importend to have a path in root in order for the site to work propaly  : C:\inetpub\wwwroot\name_of_folder -> give port number
## step 11 
stop application and web site (pause button) -> get pulished files that was created on my local pc to windows server (i used mount to send files from local pc to server) - > past those files in C:\inetpub\wwwroot\name_of_folder -> play on name of aplliaction pool and  name of web site -> browse web site on localhost:5100

![](IIS_APPLICATION_POOL/Pages/microsoft.jpg)

