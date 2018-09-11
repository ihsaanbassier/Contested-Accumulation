*Simulations regressions

set more off
est clear
/*
import delimited using "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulationsPrivate.txt", clear
gen simulation= 1
save "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulations.dta", replace

import delimited using "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulationsPublic.txt", clear
gen simulation= 2
append using "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulations.dta"
destring bourgies, replace
save "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulations.dta", replace
*/

use "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulations.dta", clear
label define sims 1 "Private" 2 "Public"
label values simulation sims

gen pmean= id1perc*aveid1 + (1-id1perc)*aveid2
gen coeffvar= sd/pmean

gen lnaveid1= ln(aveid1)
gen lnaveid2= ln(aveid2)
gen lnavebourgies= ln(avebourgies)
gen lnaveworkers= ln(aveworkers)

*Don't know how to best subset select with interactions :/
*xi: stepwise, pr(.2): regress growth profitrate##taxrate ///
*		bourgies id1perc i.initial_adv democracy i.sim
*tab initial_adv, gen(initial_adv)
*chaidforest growth, unordered(profitrate taxrate bourgies ///
*		id1perc initial_adv* democracy sim) ntree(500)

*Main results
reg growth profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(Growth)
reg coeffvar profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(Inequality)
reg lnaveid1 profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(lnID1_wealth)
reg lnaveid2 profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(lnID2_wealth)
reg lnavebourgies profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(lnBourgie_wealth)
reg lnaveworkers profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(lnWorker_wealth)
*Would be better to do lasso on these

*Interesting: When interact sim with wealth, tax rate changes sign
gen publictaxrate= sim*taxrate
reg growth taxrate publictaxrate


esttab using "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\simulations.rtf", replace

table initial_adv if sim==2, c(m aveid1 m aveid2)
table sim, c(m growth m coeffvar)
table initial_adv if sim==1, c(m aveid1 m aveid2)
*id1 benefits much more from initial adv

*Domination matters: workers unlikely to get coalition
*Complicates, because more likely when id1 and bourgie are close

*Dominance
est clear
reg domid1 profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(ID1)
reg domid2 profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(ID2)
reg dombourgie profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(Bourgies)
reg domworker profitrate taxrate bourgies id1perc i.initial_adv democracy i.sim
eststo, title(Workers)
esttab using "C:\Users\ihsaa\Documents\UMass notes\PE2 - Folbre and Moose\Term paper\dominance.rtf", replace

summ domid1
summ domid2
summ dombourgie
summ domworkers
