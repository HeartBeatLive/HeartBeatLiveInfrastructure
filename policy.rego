package infracost

deny[out] {
	maxDiff = 50.0

	msg := sprintf(
		"Total monthly cost diff must be less than $%.2f (actual diff is $%.2f).",
		[maxDiff, to_number(input.diffTotalMonthlyCost)],
	)

  	out := {
    	"msg": msg,
    	"failed": to_number(input.diffTotalMonthlyCost) >= maxDiff
  	}
}

deny[out] {
	budget = 200.0

	msg := sprintf(
		"Total monthly cost must be less than $%.2f (actual cost is $%.2f).",
		[budget, to_number(input.totalMonthlyCost)],
	)

  	out := {
    	"msg": msg,
    	"failed": to_number(input.totalMonthlyCost) >= budget
  	}
}