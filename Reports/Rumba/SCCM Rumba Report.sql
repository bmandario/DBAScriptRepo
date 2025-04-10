/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT FROM [HIS].[dbo].[RCC_SCCM]

--Use query on USCHIZWSCCM1001 (You can directly connect on USCHWSQL1316)
--Datbase: CM_GP1





  WITH USERDATA AS (select
   User_Name0
  ,MIN(displayName0) AS displayName0
 

from V_R_USER
WHERE displayName0 Like '%,%'

GROUP BY User_Name0 )
				  

SELECT DISTINCT 
                  dbo.v_R_System.Name0,   dbo.v_R_System.Resource_Domain_OR_Workgr0, dbo.v_R_System.Full_Domain_Name0, dbo.v_R_System.AD_Site_Name0, dbo.v_R_System.Operating_System_Name_and0, 

				  dbo.v_R_System.User_Name0,
                 
					CASE WHEN dbo.v_R_System.User_Name0 IS NULL THEN Pri.User_Name0

					ELSE dbo.v_R_System.User_Name0  END AS 'User',
				
					Substring(USERDATA.displayName0, Charindex(',', USERDATA.displayName0)+1, LEN(USERDATA.displayName0))+' '+Substring(USERDATA.displayName0, 1,Charindex(',', USERDATA.displayName0)-1) AS 'Full Name'
					
					,
				  
				  dbo.v_Add_Remove_Programs.Version0 AS Version, dbo.v_Add_Remove_Programs.DisplayName0 AS Application, dbo.v_Add_Remove_Programs.installdate0 as 'Install Date',


                  CASE WHEN dbo.v_R_System.Name0 LIKE '00SH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'AEL1%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'AEL2%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'AEL3%' THEN 'UAE' WHEN dbo.v_R_System.Name0
                   LIKE 'AEW1%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'AEW2%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'AEW3%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'AMOR%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'APBD%' THEN 'Other'
                   WHEN dbo.v_R_System.Name0 LIKE 'APCP%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'APFN%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'APGE%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'APIA%' THEN 'Singapore' WHEN dbo.v_R_System.Name0
                   LIKE 'APIT%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'APLG%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'APRA%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'APTX%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'APVM%'
                   THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'ARBA%' THEN 'Argentina' WHEN dbo.v_R_System.Name0 LIKE 'AT17%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'AT31%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'AT40%' THEN 'US' WHEN dbo.v_R_System.Name0
                   LIKE 'AT42%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'ATVI%' THEN 'Austria' WHEN dbo.v_R_System.Name0 LIKE 'ATVW%' THEN 'Austria' WHEN dbo.v_R_System.Name0 LIKE 'AUBN%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUBR%' THEN
                   'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUEC%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUL0%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUMA%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUME%' THEN 'Australia'
                   WHEN dbo.v_R_System.Name0 LIKE 'AUPE%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUSY%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AUWI%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'AWE1%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'AYSY%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'BCC-%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'BDDH%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'BEDG%' THEN 'Belgium' WHEN dbo.v_R_System.Name0 LIKE 'BEML%' THEN
                   'Belgium' WHEN dbo.v_R_System.Name0 LIKE 'BEVV%' THEN 'Belgium' WHEN dbo.v_R_System.Name0 LIKE 'BGSO%' THEN 'Bulgaria' WHEN dbo.v_R_System.Name0 LIKE 'BJAD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJAI%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'BJAP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJCO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJCP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJCR%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'BJCS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJFI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJFN%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJHR%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'BJIE%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJIS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJKR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJNP%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'BJPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJPU%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJSO%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'BJSP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJSS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJSV%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJSW%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BJTS%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'BJWH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'BKAS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKBY%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKCC%' THEN 'Thailand' WHEN dbo.v_R_System.Name0
                   LIKE 'BKCD%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKCF%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKCR%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKCS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKDC%'
                   THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKFC%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKFN%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKGM%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKHR%' THEN 'Thailand'
                   WHEN dbo.v_R_System.Name0 LIKE 'BKIS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKIT%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKMB%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKMC%' THEN 'Thailand' WHEN dbo.v_R_System.Name0
                   LIKE 'BKMD%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKNP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKPS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKRS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKRT%'
                   THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKSB%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKSC%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKSM%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKSO%' THEN 'Thailand'
                   WHEN dbo.v_R_System.Name0 LIKE 'BKSS%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKTB%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'BKWH%' THEN 'Thailand' WHEN dbo.v_R_System.Name0
                   LIKE 'BMER%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'BP31%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'BRBA%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'BRSP%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'CAMI%' THEN 'Canada'
                   WHEN dbo.v_R_System.Name0 LIKE 'CAMO%' THEN 'Canada' WHEN dbo.v_R_System.Name0 LIKE 'CAOT%' THEN 'Canada' WHEN dbo.v_R_System.Name0 LIKE 'CATO%' THEN 'Canada' WHEN dbo.v_R_System.Name0 LIKE 'CAVA%' THEN 'Canada' WHEN dbo.v_R_System.Name0
                   LIKE 'CCOL%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CCRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDAD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDAI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDAP%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'CDAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDCP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDCS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDFI%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'CDIS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CDRS%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'CDSS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CHAL%' THEN 'Switzerland' WHEN dbo.v_R_System.Name0 LIKE 'CHCH%' THEN 'Switzerland' WHEN dbo.v_R_System.Name0 LIKE 'CHPC%' THEN 'Switzerland' WHEN
                   dbo.v_R_System.Name0 LIKE 'CHRO%' THEN 'Switzerland' WHEN dbo.v_R_System.Name0 LIKE 'CHTO%' THEN 'Switzerland' WHEN dbo.v_R_System.Name0 LIKE 'CLSG%' THEN 'Chile' WHEN dbo.v_R_System.Name0 LIKE 'CMUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0
                   LIKE 'CNHZ%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CNJN%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CNNJ%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CNSY%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CNWH%' THEN
                   'China' WHEN dbo.v_R_System.Name0 LIKE 'CNXA%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'COBO%' THEN 'Colombia' WHEN dbo.v_R_System.Name0 LIKE 'COBW%' THEN 'Colombia' WHEN dbo.v_R_System.Name0 LIKE 'CQBS%' THEN 'Other' WHEN
                   dbo.v_R_System.Name0 LIKE 'CQRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CQTS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CRRC%' THEN 'Costa Rica' WHEN dbo.v_R_System.Name0 LIKE 'CRRD%' THEN 'Costa Rica' WHEN dbo.v_R_System.Name0
                   LIKE 'CRSJ%' THEN 'Costa Rica' WHEN dbo.v_R_System.Name0 LIKE 'DEDO%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DEFL%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DESK%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DESR%'
                   THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DETR%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DEVI%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'DKBR%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'DKGL%' THEN 'Sweden'
                   WHEN dbo.v_R_System.Name0 LIKE 'DKKO%' THEN 'Denmark' WHEN dbo.v_R_System.Name0 LIKE 'DKL0%' THEN 'Denmark' WHEN dbo.v_R_System.Name0 LIKE 'DKL1%' THEN 'Denmark' WHEN dbo.v_R_System.Name0 LIKE 'DLRS%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'DYRS%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'ECQT%' THEN 'Ecuador' WHEN dbo.v_R_System.Name0 LIKE 'ENGI%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'ESAZ%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESBC%' THEN
                   'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESCB%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESL1%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESMA%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESTA%' THEN 'Spain'  WHEN dbo.v_R_System.Name0 LIKE 'FIL-%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FIL8%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FILD%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FIW-%' THEN
                   'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FIW1%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FIW2%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FIW3%' THEN 'Finland' WHEN dbo.v_R_System.Name0 LIKE 'FRKS%' THEN 'France' WHEN dbo.v_R_System.Name0
                   LIKE 'FRLO%' THEN 'France' WHEN dbo.v_R_System.Name0 LIKE 'FRLS%' THEN 'France' WHEN dbo.v_R_System.Name0 LIKE 'FRPA%' THEN 'France' WHEN dbo.v_R_System.Name0 LIKE 'FZRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GBVW%' THEN
                   'Other' WHEN dbo.v_R_System.Name0 LIKE 'GYRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZAD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZAI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZAS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'GZCC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZCP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZFI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZIS%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'GZLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZMO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZPP%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'GZRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZSP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZSS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZSW%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'GZTS%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'HCRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'HKBO%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKCF%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKCO%' THEN 'Hong Kong' WHEN
                   dbo.v_R_System.Name0 LIKE 'HKCS%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKFN%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKHR%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKIE%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0
                   LIKE 'HKIT%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKLO%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKMB%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKMD%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE
                   'HKML%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKSA%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKTM%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HKVS%' THEN 'Hong Kong' WHEN dbo.v_R_System.Name0 LIKE 'HUBP%'
                   THEN 'Hungary' WHEN dbo.v_R_System.Name0 LIKE 'HYRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'HYUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'HZAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'HZCC%' THEN 'China' WHEN
                   dbo.v_R_System.Name0 LIKE 'HZLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'HZNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'HZPP%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'HZRS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'IDMD%' THEN 'Indonesia' WHEN dbo.v_R_System.Name0 LIKE 'IDMK%' THEN 'Indonesia' WHEN dbo.v_R_System.Name0 LIKE 'IDSM%' THEN 'Indonesia' WHEN dbo.v_R_System.Name0 LIKE 'IMCL%' THEN 'Chile' WHEN dbo.v_R_System.Name0 LIKE 'IMM1%'
                   THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'IMM4%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'IM-T%' THEN 'Australia' WHEN dbo.v_R_System.Name0 LIKE 'INAH%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INBA%' THEN 'India' WHEN dbo.v_R_System.Name0
                   LIKE 'INBH%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INBL%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INBO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INCA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INCE%' THEN 'India' WHEN
                   dbo.v_R_System.Name0 LIKE 'INCH%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INCL%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INCS%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INCO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE
                   'INDH%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INDL%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INGO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INGR%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INGU%' THEN 'India' WHEN
                   dbo.v_R_System.Name0 LIKE 'INGZ%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INHD%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INHU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'ININ%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE
                   'INJA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INJM%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INKB%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INKO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INLD%' THEN 'India' WHEN
                   dbo.v_R_System.Name0 LIKE 'INLU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INMA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INMN%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INMU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE
                   'INMY%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INNA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INPA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INPO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INPR%' THEN 'India' WHEN
                   dbo.v_R_System.Name0 LIKE 'INPU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INRA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INRN%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INSG%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE
                   'INSU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INTR%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INVA%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INVI%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'INVJ%' THEN 'India' WHEN dbo.v_R_System.Name0
                   LIKE 'INVR%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'ITMI%' THEN 'Italy' WHEN dbo.v_R_System.Name0 LIKE 'JBIT%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'JBSD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'JBTS%' THEN
                   'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'JBWH%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'JKOF%' THEN 'Indonesia' WHEN dbo.v_R_System.Name0 LIKE 'JKWH%' THEN 'Indonesia' WHEN dbo.v_R_System.Name0 LIKE 'JNCC%' THEN 'Other'
                   WHEN dbo.v_R_System.Name0 LIKE 'JNFI%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'JNIP%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'JNNP%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'JNRS%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'JNSV%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'JNWH%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KCIT%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KCSD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KCTS%' THEN
                   'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KCWH%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLBD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KKIT%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KKSD%' THEN 'Malaysia' WHEN
                   dbo.v_R_System.Name0 LIKE 'KKUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'KKWH%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KLAD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLBO%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0
                   LIKE 'KLCD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLCS%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLEA%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLFN%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLGM%'
                   THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLHR%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLIT%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLHQ%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLJT%' THEN 'Malaysia'
                   WHEN dbo.v_R_System.Name0 LIKE 'KLMD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLMK%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLPD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLSC%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0
                   LIKE 'KLSD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLTS%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KLWH%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'KMLO%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KMPP%'
                   THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'KMRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'KNSD%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KRIS%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'KTIT%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'LAPT%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'LDC3%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'LKCO%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'MAN0%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'MINI%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'MISM%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'MKSD%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'MRSD%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'MXCC%' THEN 'Mexico' WHEN dbo.v_R_System.Name0
                   LIKE 'MXDC%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXGD%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXHR%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXLN%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXMC%'
                   THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXMD%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXMY%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXPB%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXQR%' THEN 'Mexico'
                   WHEN dbo.v_R_System.Name0 LIKE 'MXSD%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MXTJ%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'MYPJ%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'MZIL%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'NCCC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJAI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJAP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJCP%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'NJFI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJKR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJLO%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'NJNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJSC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'NJSS%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'NLTI%' THEN 'Netherlands' WHEN dbo.v_R_System.Name0 LIKE 'NLUT%' THEN 'Netherlands' WHEN dbo.v_R_System.Name0 LIKE 'NOL1%' THEN 'Norway' WHEN dbo.v_R_System.Name0 LIKE 'NOL2%' THEN 'Norway' WHEN
                   dbo.v_R_System.Name0 LIKE 'NOL9%' THEN 'Norway' WHEN dbo.v_R_System.Name0 LIKE 'NOOS%' THEN 'Norway' WHEN dbo.v_R_System.Name0 LIKE 'NOW9%' THEN 'Norway' WHEN dbo.v_R_System.Name0 LIKE 'NZAK%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0
                   LIKE 'NZBP%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'NZCH%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'NZCS%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'NZ-I%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0
                   LIKE 'NZMD%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'NZMK%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'NZWG%' THEN 'New Zealand' WHEN dbo.v_R_System.Name0 LIKE 'PCSM%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'PDC2%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'PDC4%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'PELI%' THEN 'Peru' WHEN dbo.v_R_System.Name0 LIKE 'PGBD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'PGIT%' THEN 'Malaysia'
                   WHEN dbo.v_R_System.Name0 LIKE 'PGMK%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'PGSD%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'PGTS%' THEN 'Malaysia' WHEN dbo.v_R_System.Name0 LIKE 'PGWH%' THEN 'Malaysia' WHEN
                   dbo.v_R_System.Name0 LIKE 'PHMA%' THEN 'Philippines' WHEN dbo.v_R_System.Name0 LIKE 'PHMN%' THEN 'Philippines' WHEN dbo.v_R_System.Name0 LIKE 'PHMW%' THEN 'Philippines' WHEN dbo.v_R_System.Name0 LIKE 'PHNM%' THEN 'Philippines' WHEN
                   dbo.v_R_System.Name0 LIKE 'PHNW%' THEN 'Philippines' WHEN dbo.v_R_System.Name0 LIKE 'PIMA%' THEN 'Philippines' WHEN dbo.v_R_System.Name0 LIKE 'PKUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'PLAT%' THEN 'US' WHEN dbo.v_R_System.Name0
                   LIKE 'PLL1%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'PLUP%' THEN 'Thailand' WHEN dbo.v_R_System.Name0 LIKE 'PMHN%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'PMNW%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'PTL1%' THEN 'Germany'
                   WHEN dbo.v_R_System.Name0 LIKE 'PTLI%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'PTPC%' THEN 'Germany' WHEN dbo.v_R_System.Name0 LIKE 'PTSI%' THEN 'Portugal' WHEN dbo.v_R_System.Name0 LIKE 'QJRS%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'SEBO%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEBV%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEGO%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEKU%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEL2%'
                   THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEL3%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SERO%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEST%' THEN 'Sweden' WHEN dbo.v_R_System.Name0 LIKE 'SEW2%' THEN 'Sweden'
                   WHEN dbo.v_R_System.Name0 LIKE 'SGAR%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGCG%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGFN%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGHR%' THEN 'Singapore' WHEN
                   dbo.v_R_System.Name0 LIKE 'SGKB%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGKH%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGMO%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGPH%' THEN 'Singapore' WHEN dbo.v_R_System.Name0
                   LIKE 'SGSG%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGSP%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SGVN%' THEN 'Singapore' WHEN dbo.v_R_System.Name0 LIKE 'SH3P%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHAA%'
                   THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHAD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHAI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHAP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHAS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SHBD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHBO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCD%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCO%' THEN
                   'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHCS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHDP%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SHFB%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHFI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHGM%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHHR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHIE%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'SHIM%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHIS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHKR%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SHLE%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHMA%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHMB%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHMK%' THEN
                   'China' WHEN dbo.v_R_System.Name0 LIKE 'SHNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHPS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHRS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SHSC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHSO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHSP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHSS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SHSW%' THEN
                   'China' WHEN dbo.v_R_System.Name0 LIKE 'SHTS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SKL1%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0 LIKE 'SKMO%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0 LIKE 'SKW1%' THEN 'Slovakia' WHEN
                   dbo.v_R_System.Name0 LIKE 'SKW2%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0 LIKE 'SKW7%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0 LIKE 'SKW8%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0 LIKE 'SKW9%' THEN 'Slovakia' WHEN dbo.v_R_System.Name0
                   LIKE 'SSCL%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'SSHE%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'SYAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYCP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYFI%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'SYIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYPS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SYRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SYWH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZAI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZFI%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'SZIP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZIS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZMO%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'SZNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZSP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZSW%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'SZ-V%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'TDCL%' THEN 'Chile' WHEN dbo.v_R_System.Name0 LIKE 'TDUS%' THEN 'Peru' WHEN dbo.v_R_System.Name0 LIKE 'TFAO%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'THBK%' THEN 'Thailand' WHEN dbo.v_R_System.Name0
                   LIKE 'UKDF%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'UKDV%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'UKEU%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'UKMH%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'UKMK%' THEN 'UK' WHEN
                   dbo.v_R_System.Name0 LIKE 'UKST%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'UKVW%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'URPL%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'USAN%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE
                   'USBD%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USBF%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USBW%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USCA%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USCH%' THEN 'US' WHEN dbo.v_R_System.Name0
                   LIKE 'USCM%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USCS%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USDA%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USFW%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USGV%' THEN 'US' WHEN
                   dbo.v_R_System.Name0 LIKE 'USHB%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USHE%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USID%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USIR%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USJC%'
                   THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USJD%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USJT%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USKL%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USLD%' THEN 'US' WHEN dbo.v_R_System.Name0
                   LIKE 'USLK%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USMI%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USML%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USMR%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USOF%' THEN 'US' WHEN
                   dbo.v_R_System.Name0 LIKE 'USPL%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USPM%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USPR%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USSA%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USSD%'
                   THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USST%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'USSU%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'UYMO%' THEN 'Uruguay' WHEN dbo.v_R_System.Name0 LIKE 'VM-O%' THEN 'Other' WHEN dbo.v_R_System.Name0
                   LIKE 'VM-W%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'WHAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHCC%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHCR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHFI%' THEN
                   'China' WHEN dbo.v_R_System.Name0 LIKE 'WHLO%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHNP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'WHRS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'WHSS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XAAS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XACR%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XAFI%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XAIP%' THEN 'China'
                   WHEN dbo.v_R_System.Name0 LIKE 'XANP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XAPP%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XARS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XATS%' THEN 'China' WHEN dbo.v_R_System.Name0
                   LIKE 'XAWH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XCRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'XJWH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'YBRS%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'CNSH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'ZAL0%' THEN 'Africa'
                   WHEN dbo.v_R_System.Name0 LIKE 'ZAL1%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAL3%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAL4%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAL5%' THEN 'Africa' WHEN dbo.v_R_System.Name0
                   LIKE 'ZALS%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAR0%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW0%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW1%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW2%' THEN 'Africa'
                   WHEN dbo.v_R_System.Name0 LIKE 'ZAW3%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW4%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW6%' THEN 'Africa' WHEN dbo.v_R_System.Name0 LIKE 'ZAW7%' THEN 'Africa' WHEN dbo.v_R_System.Name0
                   LIKE 'ZZRS%' THEN 'Other' WHEN dbo.v_R_System.Name0 LIKE 'ZZWH%' THEN 'China' WHEN dbo.v_R_System.Name0 LIKE 'AEDU%' THEN 'UAE' WHEN dbo.v_R_System.Name0 LIKE 'ARBW%' THEN 'Argentina'
				   WHEN dbo.v_R_System.Name0 LIKE 'BRBSW%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'BRPOW%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'BRRJW%' THEN 'Brazil' 
				   WHEN dbo.v_R_System.Name0 LIKE 'BRSEW%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'BRSW%' THEN 'Brazil' WHEN dbo.v_R_System.Name0 LIKE 'BRWL%' THEN 'Brazil' 
				   WHEN dbo.v_R_System.Name0 LIKE 'CZ-PC%' THEN 'Czech'  WHEN dbo.v_R_System.Name0 LIKE 'ESAL%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESAL%' THEN 'Spain'
				   WHEN dbo.v_R_System.Name0 LIKE 'ESGC%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'ESSA%' THEN 'Spain' WHEN dbo.v_R_System.Name0 LIKE 'FRLW%' THEN 'France'
				   WHEN dbo.v_R_System.Name0 LIKE 'HKKT%' THEN 'Hong Kong'  WHEN dbo.v_R_System.Name0 LIKE 'UKCR%' THEN 'UK' WHEN dbo.v_R_System.Name0 LIKE 'SGDC%' THEN 'Singapore'
				   WHEN dbo.v_R_System.Name0 LIKE 'VDI%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'IMBAW%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'IMBL%' THEN 'India'
				   WHEN dbo.v_R_System.Name0 LIKE 'IMMU%' THEN 'India' WHEN dbo.v_R_System.Name0 LIKE 'IMM-NB%' THEN 'Poland' WHEN dbo.v_R_System.Name0 LIKE 'IM-NB%' THEN 'Poland' 
				   WHEN dbo.v_R_System.Name0 LIKE 'RRC-NB%' THEN 'Poland' WHEN dbo.v_R_System.Name0 LIKE 'SSC-%' THEN 'Egypt' WHEN dbo.v_R_System.Name0 LIKE 'SAIT%' THEN 'Saudi Arabia' 
				   WHEN dbo.v_R_System.Name0 LIKE 'HMOHAMED-LT%' THEN 'Egypt' WHEN dbo.v_R_System.Name0 LIKE 'IST_T%' THEN 'Turkey' WHEN dbo.v_R_System.Name0 LIKE 'LPWI%' THEN 'France' 
				   WHEN dbo.v_R_System.Name0 LIKE 'MANE%' THEN 'Macedonia'   WHEN dbo.v_R_System.Name0 LIKE 'MSPI%' THEN 'Slovenia'  WHEN dbo.v_R_System.Name0 LIKE 'OSTOJ%' THEN 'Serbia'
				   WHEN dbo.v_R_System.Name0 LIKE 'USJO%' THEN 'US' WHEN dbo.v_R_System.Name0 LIKE 'MXLMW%' THEN 'Mexico' WHEN dbo.v_R_System.Name0 LIKE 'IRW%' THEN 'US'
WHEN dbo.v_R_System.Name0 LIKE 'FIESWLAP%' THEN 'Finland'
				   ELSE 'Other' END AS 'COUNTRY', 
				   
				   dbo.vWorkstationStatus.LastHardwareScan, dbo.v_Add_Remove_Programs.Publisher0,
				   IP.IPAddress as IPAddress, dbo.vWorkstationStatus.LastHardwareScan AS 'Last Inventory Timestamp',

				   CASE WHEN dbo.v_R_System.ResourceID IN (Select ResourceID from v_RA_System_SystemGroupName 
WHERE System_Group_Name0 = 'CORPORATE\SCCM-AppDeploy-MicroFocus-RumbaDesktop-10.1SP1-Computers') THEN 'Yes' ELSE 'No' END AS 'Member of Rumba AD Group?',
                   CASE WHEN dbo.v_R_System.ResourceID IN (select arpc.ResourceID
from dbo.vAppDeploymentResultsPerClient ARPC 
Where ARPC.AssignmentID IN ('16784255') 
AND (ARPC.EnforcementState >= 1000 and ARPC.EnforcementState < 2000)) THEN 'Yes' ELSE 'No' END AS 'Watermark Installed?',

                   CASE WHEN dbo.v_R_System.ResourceID IN (Select ResourceID from v_RA_System_SystemGroupName 
WHERE System_Group_Name0 = 'CORPORATE\SCCM-AppDeploy-MicroFocus-RumbaDesktop-10.1SP1-Computers') AND dbo.v_R_System.ResourceID IN (select arpc.ResourceID
from dbo.vAppDeploymentResultsPerClient ARPC 
Where ARPC.AssignmentID IN ('16784255') 
AND (ARPC.EnforcementState >= 1000 and ARPC.EnforcementState < 2000)) THEN 'Rumba Valid Package' ELSE 'Rumba Invalid package' END AS 'Validity Status'

FROM        dbo.v_FullCollectionMembership INNER JOIN
                  dbo.v_R_System ON dbo.v_FullCollectionMembership.ResourceID = dbo.v_R_System.ResourceID INNER JOIN
                  dbo.v_Add_Remove_Programs ON dbo.v_R_System.ResourceID = dbo.v_Add_Remove_Programs.ResourceID  INNER JOIN
                  dbo.vWorkstationStatus ON dbo.v_FullCollectionMembership.ResourceID = dbo.vWorkstationStatus.ResourceID
				   LEFT OUTER JOIN (
select DISTINCT 
SYS.ResourceID,  
SYS.Name0, 
SYS.Resource_Domain_OR_Workgr0, 
SYS.Client0, 
SYS.Full_Domain_Name0, 
SYS.Operating_System_Name_and0, 
MIN(v_GS_NETWORK_ADAPTER_CONFIGURATION.IPAddress0) as IPAddress
FROM v_R_System  SYS INNER JOIN v_GS_NETWORK_ADAPTER_CONFIGURATION  ON SYS.ResourceID = v_GS_NETWORK_ADAPTER_CONFIGURATION.ResourceID
WHERE SYS.Operating_System_Name_and0 LIKE '%WORKS%' AND v_GS_NETWORK_ADAPTER_CONFIGURATION.IPAddress0 IS NOT NULL 
GROUP BY SYS.ResourceID, SYS.Name0, 
SYS.Resource_Domain_OR_Workgr0, 
SYS.Client0, 
SYS.Full_Domain_Name0, 
SYS.Operating_System_Name_and0) AS IP on dbo.v_R_System.ResourceID = IP.ResourceID  LEFT OUTER JOIN


(select
vrs.ResourceID,
vru.User_Name0
 from
 v_UsersPrimaryMachines upm
 left join v_R_User vru
 on upm.UserResourceID = vru.ResourceID
 left join v_R_System vrs
 on upm.MachineID = vrs.ResourceID 
 WHERE vru.Name0 != 'Null'
 ) AS Pri ON dbo.v_R_System.ResourceID = Pri.ResourceID


 LEFT OUTER JOIN USERDATA on  dbo.v_R_System.User_Name0 = USERDATA.User_Name0



WHERE     
(dbo.v_FullCollectionMembership.CollectionID = N'GP10076F') AND 
(dbo.v_Add_Remove_Programs.DisplayName0 LIKE N'%RUMBA%') AND 
(dbo.v_Add_Remove_Programs.DisplayName0 NOT LIKE N'%SCRIPT ENGINE%') AND
(dbo.v_Add_Remove_Programs.DisplayName0 NOT LIKE N'%TP DIRECTOR%') AND
(dbo.v_Add_Remove_Programs.DisplayName0 NOT LIKE N'%VB ADDON%')
