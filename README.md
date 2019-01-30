# Fx-Docker-Script-EE
# 2019-01-30

      On-Premises-Enterprise Installation
----------------------------------------------------------------------------------------------------

#### How to run "fx-security-enterprise-installer.sh" script & deploy FXLABS Services  ############# 


     
       i. sudo git clone https://github.com/intesar/Fx-Docker-Script-EE.git

      ii. cd  Fx-Docker-Script-EE/fx-security-enterprise/

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
                                                   
     xiv. Copy & Paste “THIS  FX-IAM KEY <FX-IAM KEY > in HOMEPAGE->Administrator(Default)->Settings-><FX_IAM* > field OF WEB_URL AFTER LOGIN” 
          (Its randomly generated & will be different for each fresh setup, use the one of the setup time)
                 
      xv. Enter stack name tag: UAT (or something appropriate)
         
### Once script execution gets completed run below commands to check whether services got deployed successfully or not ( In total 12 services and 12 containers running) ######### 
     xvi. docker service ls (to check all running services In total 12 services)
    xvii. docker ps         (to cehck all running containers In total 12 containers)
         
Result: FxLabs Services were successfully deployed.
                          
                    
                   
                    
################# How to run "fx-security-enterprise-update.sh" script for updating FXLABS services ############
          
       i. cd  Fx-Docker-Script-EE/fx-security-enterprise/

      ii. sudo su

     iii. chmod 744 fx-security-enterprise-update.sh

      iv. docker service ls 
###  (copy & paste appropriate <StackName> as second parameter in below command, it will be initial prefix of all services, like in this service "UAT_fx-control-plane",  stack name is "UAT" ) ####
 
       v. ./fx-security-enterprise-update.sh latest <StackName> env

### Once script execution gets completed run below commands to check whether services got refreshed & deployed successfully or not ( In total 12 services and 12 containers running) ######### 
      vi. docker service ls (to check all running services, In total 12 services should be running)
     vii. docker ps         (to cehck all running containers, In total 12 containers in synchronization with 12 Fxlabs services should be running excluding Scanners bots containers )
         
Result: FxLabs Services were successfully updated.
  
       
