*Three-Fold Cross Validation - Fundamentals Model

*Load dataset nj_va_historical_governor_data
import excel "C:\Users\jnikolovski\OneDrive - The University of Chicago\PPHA 31720 - Science of Elections and Campaigns\Prediction Assignment\Data\nj_va_historical_governor_data.xlsx", sheet("nj_va_historical_governor_data") cellrange(A1:K23) firstrow

*Randomly assign observations into three groups
gen random = runiform()
sort random
gen partition = mod(_n, 3)
sort partition

gen test_error = .

*Calculate errors for all three partitions using loop
forval i=0/2 {
  reg incvoteshare same_inc_pres oct_unemployment inc_cash_share if partition!=`i'
  predict train_error`i', res
  replace test_error = train_error`i' if partition==`i'
  }

*Calculate the mean absolute error
gen abs_test_error = abs(test_error)
sum abs_test_error

*Regression for prediction
reg incvoteshare same_inc_pres oct_unemployment inc_cash_share

*Graphical representation of model performance
predict predict1
label variable incvoteshare "Incumbent Vote Share"
label variable predict1 "Predicted Incumbent Vote Share"
scatter incvoteshare predict1 || lfit incvoteshare predict1 

