clear 
*====================================================================
*1-IMPORT
*====================================================================
use "C:\Users\cindy\Desktop\vam 20250223-OFS.dta" 





global   ind ind1 ind2 ind3 ind4 ind5 ind6 ind7 ind8 ind9 ind10 ind11 ind12 ind13 ind14 ind15 ind16 ind17 ind18 
global   year year1 year2 year3 year4 year5 year6 year7 year8 year9 year10 year11 year12 year13 year14 year15 year16 
global   control1  leverage0   liquidity roa  size pay_type trans_proportion trans_consideration  operating_cap 
global   control2  leverage0   liquidity roa  size cash_flow financial_distress 
global   control3  leverage0   liquidity roa  size cash_flow financial_distress 

*====================================================================




*====================================================================
*2- Descriptive statistics
*================Table 3  Descriptive statistics of continuous variables====================================================
asdoc sum  target_to acquirer_to trans_proportion trans_consideration size operating_cap leverage0  liquidity roa cash_flow financial_distress  innovation_perf_count  period   commitment_performance

asdoc sum  target_to acquirer_to trans_proportion trans_consideration size operating_cap leverage0  liquidity roa cash_flow financial_distress  innovation_perf_count  period  commitment_performance if pvam==1

asdoc sum  target_to acquirer_to trans_proportion trans_consideration size operating_cap leverage0  liquidity roa cash_flow financial_distress    innovation_perf_count if pvam==0
*================Table 3  Descriptive statistics of continuous variables====================================================






*================Table 4  The correlations (sample: acquistions of technology firms)====================================================
asdoc correlate  pvam target_to acquirer_to $control1
reg   pvam target_to acquirer_to $control1
estat vif
*================Table 4  The correlations (sample: acquistions of technology firms)====================================================


*================Table 5  The correlations (sample: acquistions of technology firms with PVAM)====================================================
asdoc correlate  innovation_perf_count    period commitment_performance $control2 if pvam==1
reg   innovation_perf_count    period commitment_performance $control2 if pvam==1
estat vif
*================Table 5  The correlations (sample: acquistions of technology firms with PVAM)====================================================






*====================================================================
*-3. REGRESSION
*====================================================================
*================Table 6  Regression results====================================================
asdoc probit pvam                                                                           $control1 $ind $year, nest replace
asdoc probit pvam  target_to   acquirer_to                                              $control1 $ind $year, nest append
asdoc reg innovation_perf_count                                                     $control2 $ind $year, nest append
asdoc reg innovation_perf_count  pvam                                               $control2 $ind $year, nest append
asdoc reg innovation_perf_count  period                                             $control2 $ind $year if pvam==1, nest append
asdoc reg innovation_perf_count  commitment_performance                             $control2 $ind $year if pvam==1,  nest append
asdoc reg innovation_perf_count  period commitment_performance                      $control2 $ind $year if pvam==1,  nest append
*================Table 6  Regression results====================================================







*====================================================================
*-4. ROBUSTNESS CHECK
*====================================================================
*-4.1 Study1-logit IN Table A1
*====================================================================
asdoc logit pvam                                                                           $control1 $ind $year, nest replace
asdoc logit pvam  target_to  acquirer_to                                                   $control1 $ind $year, nest append



*====================================================================
*-4.2 UNI/BILA PVAM IN Table A1
*====================================================================
asdoc probit bila                                                                           $control1 $ind $year, nest append
asdoc probit bila  target_to  acquirer_to                                                   $control1 $ind $year, nest append
asdoc probit uni                                                                            $control1 $ind $year, nest append
asdoc probit uni  target_to   acquirer_to                                                   $control1 $ind $year, nest append


*====================================================================
*-4.3 5-YEAR TIME WINDOW OF TECHNOLOGICAL BASE，IN Table A2
*====================================================================
asdoc probit pvam                                                                           $control1 $ind $year, nest replace
asdoc probit pvam  target_to5  acquirer_to5                                                 $control1 $ind $year, nest append
*====================================================================


*====================================================================
*-4.4 REGRESSION WITH CLUSTERED STANDARD ERRORS, IN Table A2
*====================================================================
egen investor_id = group(investor)
asdoc probit pvam                                               $control1 $ind $year, vce(cluster investor_id), nest replace
asdoc probit pvam  target_to   acquirer_to                      $control1 $ind $year, vce(cluster investor_id), nest append
*====================================================================


*====================
*-4.5 Heckman, IN Table A3
*====================
gen innovation_perf_count_dum=0
replace innovation_perf_count_dum=1 if innovation_perf_count>0
probit innovation_perf_count_dum  $control1 $ind $year
predict zg if e(sample), xb
gen lambda=normalden(zg)/normal(zg)

asdoc reg innovation_perf_count                                  lambda       $control2 $ind $year, nest replace
asdoc reg innovation_perf_count  pvam                            lambda       $control2 $ind $year, nest append
asdoc reg innovation_perf_count  period                          lambda       $control2 $ind $year if pvam==1, nest append
asdoc reg innovation_perf_count  commitment_performance          lambda       $control2 $ind $year if pvam==1, nest append
asdoc reg innovation_perf_count  period commitment_performance   lambda       $control2 $ind $year if pvam==1, nest append


*====================================================================
*-4.6 GRANTED INVENTIONS, IN Table A4
*====================================================================

asdoc reg innovation_perf_count_grant                                      $control2 $ind $year, nest replace
asdoc reg innovation_perf_count_grant  pvam                                $control2 $ind $year, nest append
asdoc reg innovation_perf_count_grant  period                              $control2 $ind $year if pvam==1, nest append
asdoc reg innovation_perf_count_grant  commitment_performance              $control2 $ind $year if pvam==1,  nest append
asdoc reg innovation_perf_count_grant  period commitment_performance       $control2 $ind $year if pvam==1,  nest append
*====================================================================


*====================================================================
*-4.7 SUBGROUP ANALYSIS, IN Table A5
*====================================================================
asdoc probit pvam                                                                      $control1 $ind $year if same==1, nest replace
asdoc probit pvam  target_to   acquirer_to                                             $control1 $ind $year if same==1, nest append
asdoc probit pvam                                                                      $control1 $ind $year if same==0, nest append
asdoc probit pvam  target_to   acquirer_to                                             $control1 $ind $year if same==0, nest append
*====================================================================




















