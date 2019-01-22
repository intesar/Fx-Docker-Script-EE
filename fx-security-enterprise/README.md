# Fx-Docker-Script-EE
# 2019-01-22

      On-Premises-Enterprise Installation 

1.	VM requirements 

      i. Ubuntu Server 18.04 LTS
     ii. vCPUs: 4
    iii. RAM: 16GB
     iv. Storage: 30GB (minimum),  Maximum(As per client requirement)
      v. SSH Port: 22 Enabled(OPEN)
     vi. HTTP, HTTPS Ports: 80,443 Enabled
    vii. InstanceType: t2.xlarge (for aws cloud) 
   viii. Ssh username & password, or ssh username & pem/ppk files

2.	Installation Steps
     
       i. sudo git clone https://github.com/intesar/Fx-Docker-Script-EE.git
      ii. cd  /Fx-Docker-Script-EE/fx-security-enterprise/
     iii. sudo su
      iv. chmod 744 fx-security-enterprise-installer.sh
       v. ./fx-security-enterprise-installer.sh
      vi. Enter image tag: latest 
     vii. Enter Passphrase for private key: example ( or something appropriate)
    viii. Enter Common Name/DomainName:  www.company.com ( or something appropriate)
      ix. Enter Country (Use the two-letter code without punctuation for country, for example: US or CA): US ( or something appropriate)
       x. Enter City or Locality (The Locality field is the city or town name, for example: Berkeley): Berkeley ( or something appropriate)
      xi. Enter State or Province (Spell out the state completely; do not abbreviate the state or province name, for example: California): California ( or something appropriate)
     xii. Enter Organization: company ( or something appropriate)
    xiii. Enter Organizational Unit (This field is the name of the department or organization unit making the request): Telecom ( or something appropriate) 
     xiv. Copy & Paste “THIS  FX-IAM KEY “j9CREJyf0upRLsrD” IN SYSTEM-SETTING OF WEB_URL AFTER LOGIN” (Its randomly generated & will be different for each fresh setup, use that one of setup time)
      xv. Enter stack name tag: UAT (or something appropriate)
    
Result: FxLabs Services were successfully deployed.
         
         
3.	First-time login credentials

      i. Go to browser with VM public ip
     ii. Give default username: admin@fxlabs.local
    iii. Give password as: fxadmin123 & click on login
    
Result:  First-Time login credentials were successful     
        
4.	Update Settings changes 
    
      i. After login with username: admin@fxlabs.local & password: fxadmin123 ,  click on Administrator(Default) -> Setting 
     ii. On "System Setting" page copy & paste VM public ip (FX_HOST field) and also copy & paste FX_IAM key  ( FX_IAM field, which we copied from console terminal during deployment of services) & then click on "Save"
    iii. Now click Home icon (left side of System Settings) 
     iv. Click on "Vault"
      v. Click on New Credentials
     vi. Give a name for Account like admin and select Self_Hosted from drop-down list for the account type & then  click on "Create"
     
Result:  Update settings changes were successful.

5.	Install Steps for Scanners

      i. After login with username: admin@fxlabs.local & password: fxadmin123 , Under Services, click on Scanner Network 
     ii. On Scanner Page click on Private Scanners
    iii. Click on New Scanner
     iv. Give some name for scanner like EAST_US & Click on “Create Self Hosted Scanner & Complete” 
      v. When a pop-up comes up “Run the below command on any Linux/Windows/Mac system with Docker installed” click on “copy” to copy the command to create a scanner & then click  on “Ok"
     vi. Scroll down and click on check status 
    vii. A pop-up will come with a message saying "Not reachable!", click on “ok”
   viii. Now copy the command to create a scanner and paste it in the VM’s console terminal and hit Enter (Where Fxlabs services are running)
     ix. Type “docker ps” to check whether container got created or not 
      x. Now go to browser & again click on “Check status”, this time pop-up will come up with a message Status: Ok! & then click on Ok
     xi. click on Save
   
Result: Self_Hosted scanner for running jobs successfully created.

6.	How to Register a sample API and run tests  
      
      i. After login with username: admin@fxlabs.local & password: fxadmin123 ,	Under APIs click on NEW API (  + icon)
     ii. Give a Name for APP/porject name like "test" and copy & paste this http://54.215.136.217/v2/api-docs OpenAPISpec url in the second field   
    iii. Click on "Save & Complete" to create Test API Project.
     iv. Click on Test project 
      v. Then on proejct page, click on “Auto Coverage”
     vi. On next page, click on “RBAC” , ABAC (Level1),ABAC (Level2),ABAC(Level3) and to activate, click on  check boxes to uncheck them & to generate scripts.  or to activate all categories, click on “Activate ALL Categories” to generate all scripts for running jobs.
         a pop-up comes up to “create credentials for userA, uesrB & userC” in environment section for ABAC(Level 1,2,3), click on "ok"
    vii. Scroll down and click on “Save configuration”
   viii. An AutoCode pop-up will come, click on "ok' to generate scripts for all selected categories
     ix. Click on “Scripts” Tab to view all generated scripts for selected categories
      x. Click on project “Test” and then click on “Run” for Default job
     xi. A run pop-up will come, select required categories from drop-down list of “Test Categories”  and a scanner for running job
    xii. Click on run, it will take us to job running page
   xiii. Click on running job number to see progress of running job
   
Result: Job completed successfully   
      