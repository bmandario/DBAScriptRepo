---Install SO
so install --IAcceptLicenseTerms --installmonitoringservice 0 -n 'Default Connection' -u 'corporate\sqlprdservice'
so installmp -n 'Default Connection' -s USCHIZWSEN1005.corporate.ingrammicro.com -u 'corporate\sqlprdservice' --IAcceptLicenseTerms

----Use this to open and configure SO network for webclient
so configmp - configure, SSL, ports