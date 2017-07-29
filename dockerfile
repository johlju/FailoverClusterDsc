FROM microsoft/windowsservercore

LABEL Description="FCINode1" Vendor="Microsoft" Version="10"

RUN ["powershell", "Add-WindowsFeature", "Failover-clustering"]
RUN ["powershell", "Add-WindowsFeature", "RSAT-Clustering-Mgmt"]
RUN ["powershell", "Add-WindowsFeature", "RSAT-Clustering-PowerShell"]
RUN ["powershell", "Add-WindowsFeature", "RSAT-Clustering-CmdInterface"]

#RUN powershell -Command \
#    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'));

#CMD [ "ping", "localhost", "-t" ]
