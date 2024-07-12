program define stym

syntax varlist [if] [in]  [, stdi stdr a(real 0) b(real 1) stni stnr nom(real 0) gen(string) max]

if "`gen'"==""	{
di "Podaj nazwe nowej zmiennej stymulanty przy pomocy opcji gen()"
di error
}



tempname aa ab ac n spec

local `aa'=0

if "`stdi'"!=""	{
	local ++`aa'
		}
if "`stdr'"!=""	{
	local ++`aa'
		}
if "`stnr'"!=""	{
	local ++`aa'
		}
if "`stni'"!=""	{
	local ++`aa'
		}

if ``aa''==0	{
di "Nie podano sposobu stymulacji; użyj jednej z opcji stdi, stdr, stni, stnr"
di error
		}
if ``aa''>1	{
di "Podano więcej niż jedną metodę stymulacji; użyj jednej z opcji stdi, stdr, stni, stnr"
di error
		}

local `aa'=0
local `ab'=0
local `ac'="`gen'"

foreach i of varlist `varlist'	{
	local ++`aa'
				}
foreach i of local `ac'	{
	local ++`ab'
				}	

if ``aa''!=``ab''	{
di "Podana liczba nazw nowych zmiennych jest różna od liczby zmiennych poddanych normalizacji"
di error
		}

local `spec' = "`if'" + "`in'"
local `aa'=0
tokenize `gen'

foreach i of varlist `varlist'	{

if "`stdi'"!=""	{
local ++`aa'
qui gen ```aa'''= `b'*(`i')^(-1) ``spec''
label variable ```aa''' "Wartości zmiennej `i' po stymulacji ilorazowej"
		}

if "`stdr'"!=""	{
local ++`aa'
if "`max'"!=""	{
	qui sum `i' ``spec''
	tempname a1
	local `a1'=r(max)
	qui gen ```aa'''=``a1''-`b'*`i' ``spec''
		}
else	{
qui gen ```aa'''=`a'-`b'*`i' ``spec''
	}
label variable ```aa''' "Wartości zmiennej `i' po stymulacji roznicowej"


		}

if "`stni'"!=""	{
local ++`aa'
qui gen ```aa'''=min(`i',`nom')/max(`i',`nom') ``spec''
label variable ```aa''' "Wartości zmiennej `i' po stymulacji ilorazowej"


		}

if "`stnr'"!=""	{
local ++`aa'
qui gen ```aa'''=-abs(`i'-`nom') ``spec''
label variable ```aa''' "Wartości zmiennej `i' po stymulacji roznicowej"


		}



}
end
//end
