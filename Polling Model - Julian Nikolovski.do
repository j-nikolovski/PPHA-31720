*Three-Fold Cross Validation - Polling Model

*Load dataset pres_gov_historical_polling_data
import excel "C:\Users\jnikolovski\OneDrive - The University of Chicago\PPHA 31720 - Science of Elections and Campaigns\Prediction Assignment\Data\pres_gov_historical_polling_data.xlsx", sheet("pres_gov_historical_polling_dat") cellrange(A1:R57) firstrow


*Randomly assign observations into three groups
gen random = runiform()
sort random
gen partition = mod(_n, 3)
sort partition

gen test_error = .

*Calculate errors for all three partitions using loop
forval i=0/2 {
  reg incvoteshare incpoll_Oct_Nov if partition!=`i'
  predict train_error`i', res
  replace test_error = train_error`i' if partition==`i'
  }

*Calculate the mean absolute error
gen abs_test_error = abs(test_error)
sum abs_test_error

*Regression for prediction
reg incvoteshare incpoll_Oct_Nov

*Graphical representation of model performance
predict incvoteshare_polls
label variable incvoteshare_polls "Predicted Incumbent Vote Share"
label variable incvoteshare "Incumbent Vote Share"
scatter incvoteshare incvoteshare_polls || lfit incvoteshare incvoteshare_polls

