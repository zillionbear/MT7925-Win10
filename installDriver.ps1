#Requires -RunAsAdministrator

cd ".\Workspace"

#Make our certificate
$cert = New-SelfSignedCertificate -Subject "CN=MTKDriverCert" -Type CodeSigning `
        -CertStoreLocation "Cert:\LocalMachine\My" -HashAlgorithm SHA256

#Make a catalog, move into output folder, and sign it with our certificate
New-FileCatalog -CatalogFilePath ".\CatTemp\mtkwl6ex.cat" -Path ".\Output" -CatalogVersion 2.0
Copy-Item -Path ".\CatTemp\mtkwl6ex.cat" -Destination ".\Output"
Set-AuthenticodeSignature -FilePath ".\Output\mtkwl6ex.cat" -Certificate $cert -HashAlgorithm SHA256

#Install the driver
pnputil /add-driver ".\Output\mtkwl6ex.inf" /install
pnputil /scan-devices