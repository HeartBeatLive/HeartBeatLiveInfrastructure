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
		"Total monthly cost is too big! It is $%.2f, but the budget is $%.2f.",
		[to_number(input.totalMonthlyCost), budget],
	)

  	out := {
    	"msg": msg,
    	"failed": to_number(input.totalMonthlyCost) >= budget
  	}
}