package cardswitch

// Representational payments-boundary file. ANY change here is denied by the
// policy gate (path matches "card-switch" + "settlement") and routed to a human.
func SettlementBatchSize() int { return 500 }
