alphanumeric = { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
alphanumeric2 = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes' }
alphanumeric3 = { contains: 'contains', does_not_contain: 'does not contain' }

NUMERIC_OPERATORS = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }

FILTERS= {
  user: {
    email: { metric_type: 'alphanumeric', operators: alphanumeric },
    name: { metric_type: 'alphanumeric', operators: alphanumeric2 },
    contact_number: { metric_type: 'alphanumeric', operators: alphanumeric3 }
  },

  order: {
    revenue: { metric_type: 'numeric', operators: NUMERIC_OPERATORS }
  },

  session: {
    count: { metric_type: 'numberic', operators: NUMERIC_OPERATORS }
  }
}
