use "C:\Users\Admin\OneDrive\Documents\ECON231W\project.dta", clear

*** Table no.1

// For the Model Sample
drop if hrs1 == .i 
drop if hrs1 == .n
drop if numpets == .i
drop if numpets == .n 
drop if realrinc == .i
drop if numpets == .d 

count

// Experience
gen exp = age - 20
replace exp = 0 if exp < 0

// Have Pets
gen havepets = 0 if numpets == 0
replace havepets = 1 if numpets !=0

// Male
gen male = 1 if sex == 1
replace male = 0 if sex !=1

// Female
drop female
generate female = 1 if sex == 2
replace female = 0 if sex == 1

// White
gen white =1 if racecen1 == 1
replace white = 0 if racecen1 != 1

// Black 
gen black = 1 if racecen1 == 2
replace black = 0 if racecen1 != 2 

// Other Race
gen otherrace = 1 if racecen1 > 2
replace otherrace = 0 if racecen1 <= 2

// Own home
drop ownhome
gen ownhome = 1 if dwelown == 1
replace ownhome = 0 if dwelown != 1

// Rent home 
drop renthome
gen renthome = 1 if dwelown == 2
replace renthome = 0 if dwelown != 2

// Married
gen married = 1 if marital == 1
replace married = 0 if marital != 1

// Widowed
gen widowed = 1 if marital == 2
replace widowed = 0 if marital != 2

// Divorced
gen divorced = 1 if marital == 3
replace divorced = 0 if marital != 3

// Separated
gen separated = 1 if marital == 4
replace separated = 0 if marital != 4

// Never married 
gen nevermarried = 1 if marital > 4
replace nevermarried = 0 if marital <= 4

// Trailer
gen trailer = 1 if dwelling == 1
replace trailer = 0 if dwelling != 1

// One family house
gen onefamilyhouse = 1 if dwelling == 2
replace onefamilyhouse = 0 if dwelling != 2

// Unit
gen unit = 1 if dwelling == 3
replace unit = 0 if dwelling != 3

// Three-four family house
gen threefourfamilyhouse = 1 if dwelling == 4
replace threefourfamilyhouse = 0 if dwelling != 4

// Row House
gen rowhouse = 1 if dwelling == 5
replace rowhouse = 0 if dwelling != 5

// Apartment
gen apartment = 1 if dwelling > 5
replace apartment = 0 if dwelling <= 5

tabstat (realrinc numpets havepets educ exp childs hrs1 male female black white otherrace ownhome renthome married widowed divorced separated nevermarried trailer onefamilyhouse unit threefourfamilyhouse rowhouse apartment), s(mean sd)

// For the Tenure Sample 
preserve 
drop if dwelown == .i 
count 

tabstat (realrinc numpets havepets educ exp childs hrs1 male female black white otherrace ownhome renthome married widowed divorced separated nevermarried trailer onefamilyhouse unit threefourfamilyhouse rowhouse apartment), stat(mean sd)

*** Table 2
restore
count

// Create ln variable for realrinc 
gen ln_realrinc = ln(realrinc)

// Create experience^2 variable
gen exp_sqr = abs(exp)^2

// Column 1
reg ln_realrinc havepets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs i.region [pweight = wtssall], robust
estimates store model1

// Column 2
reg ln_realrinc havepets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs i.havepets##c.educ i.region [pweight = wtssall], robust
estimates store model2

// Column 3
reg ln_realrinc havepets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs renthome i.havepets##i.renthome trailer onefamilyhouse unit rowhouse threefourfamilyhouse i.region [pweight = wtssall], robust
estimates store model3

// Column 4
reg ln_realrinc havepets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs i.havepets##i.black i.havepets##i.otherrace i.region [pweight = wtssall], robust
estimates store model4

// Excel table
etable, estimates(model1 model2 model3 model4) stars(0.1 "*" 0.05 "**" 0.01 "***") showstars showstarsnote title("Table 2. OLS regression results for regressions of real income on pet ownership") export(Table2.xlsx)

*** Table 3

// Column 1 
reg ln_realrinc numpets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs i.region [pweight = wtssall], robust
estimates store model5

// Column 2 
reg ln_realrinc numpets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs c.numpets##c.educ i.region [pweight = wtssall], robust
estimates store model6

// Column 3
reg ln_realrinc numpets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs rent c.numpets##i.rent trailer onefamilyhouse unit rowhouse threefourfamilyhouse i.region [pweight = wtssall], robust
estimates store model7

// Column 4
reg ln_realrinc numpets educ black otherrace female exp exp_sqr widowed divorced separated nevermarried mntlhlth childs c.numpets##i.black i.havepets##c.otherrace i.region [pweight = wtssall], robust
estimates store model8

// Excel table
etable, estimates(model5 model6 model7 model8) stars(0.1 "*" 0.05 "**" 0.01 "***") showstars showstarsnote title("Table 3. OLS regression results for regressions of real income on number of pets") export(Table3.xlsx)

