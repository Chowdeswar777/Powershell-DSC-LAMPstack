configuration LAMPServer {
   Import-DSCResource -module "nx"

   Node localhost {

        $requiredPackages = @("apache2","mariadb-server","mariadb-client","php","php-mysql")
        $enabledServices = @("apache2","mysql")

        #Ensure packages are installed
        ForEach ($package in $requiredPackages){
            nxPackage $Package{
                Ensure = "Present"
                Name = $Package
                PackageManager = "apt"
            }
        }

		#Ensure php info files there
		    nxFile phpinfophp{ 
                DestinationPath = "/var/www/html/phpinfo.php"
				Contents="<?php phpinfo(); ?>"
				Type = "file"          
                Ensure = "Present"
            }

        #Ensure daemons are enabled
        ForEach ($service in $enabledServices){
            nxService $service{
                Name = $service
                Controller = "systemd"
                State = "running"
            }
        }
   }
}
