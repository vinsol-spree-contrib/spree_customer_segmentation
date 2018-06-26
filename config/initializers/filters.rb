alphanumeric = { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
alphanumeric2 = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes' }
alphanumeric3 = { contains: 'contains', does_not_contain: 'does not contain' }

NUMERIC_OPERATORS = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }
NUMERIC_OPERATORS_WITH_BLANK = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=', blank: 'blank' }


FILTERS= {
  user: {
    email: { metric_type: 'alphanumeric', operators: alphanumeric },
    name: { metric_type: 'alphanumeric', operators: alphanumeric2 },
    contact_number: { metric_type: 'alphanumeric', operators: alphanumeric3 }
  },

  order: {
    revenue: { metric_type: 'numeric', operators: NUMERIC_OPERATORS },
    days_from_first_order: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK },
    days_from_last_order: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK }
  },

  session: {
    count: { metric_type: 'numberic', operators: NUMERIC_OPERATORS }
  }
}
