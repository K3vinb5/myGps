print("Creating myGps folder")
fs.makeDir("myGps")
shell.run("cd myGps")
--main
shell.run("mkdir main")
shell.run("cd main")
shell.run("wget https://raw.githubusercontent.com/K3vinb5/myGps/main/main/myGps.lua")
shell.run("wget https://raw.githubusercontent.com/K3vinb5/myGps/main/main/setup.lua")
shell.run("cd ..")
