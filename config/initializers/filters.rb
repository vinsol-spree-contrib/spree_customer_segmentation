APLHANUMERIC_OPERATORS = { includes: 'includes', not_includes: 'not includes', contains: 'contains', does_not_contain: 'does not contain' }
APLHANUMERIC2_OPERATORS = { starts_with: 'starts with', includes: 'includes', not_includes: 'not includes' }
APLHANUMERIC3_OPERATORS = { contains: 'contains', does_not_contain: 'does not contain' }

NUMERIC_OPERATORS = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=' }
NUMERIC_OPERATORS_WITH_BLANK = { gt_eq: '>=', gt: '>', between: 'between', eq: '=', not_eq: '!=', lt: '<', lt_eq: '<=', blank: 'blank' }

LOGICAL_OPERATORS = { eq: 'equals' }
DATE_OPERATORS = { before: 'before', after: 'after', eq: 'equals', between: 'between', blank: 'blank' }

FILTERS= {
  user: {
    email: { metric_type: 'alphanumeric', operators: APLHANUMERIC_OPERATORS },
    name: { metric_type: 'alphanumeric', operators: APLHANUMERIC2_OPERATORS },
    contact_number: { metric_type: 'alphanumeric', operators: APLHANUMERIC3_OPERATORS }
  },

  order: {
    revenue: { metric_type: 'numeric', operators: NUMERIC_OPERATORS },
    days_from_first_order: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK },
    days_from_last_order: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK },
    quantity_total: { metric_type: 'numeric', operators: NUMERIC_OPERATORS },
    total_number_of_order: { metric_type: 'numeric', operators: NUMERIC_OPERATORS },
    quantity_average: { metric_type: 'numeric', operators: NUMERIC_OPERATORS },
    frequency: { metric_type: 'numeric', operators: NUMERIC_OPERATORS }
  },

  session: {
    count: { metric_type: 'numberic', operators: NUMERIC_OPERATORS }
  },

  cart: {
    number_of_items: { metric_type: 'numberic', operators: NUMERIC_OPERATORS },
    days_from_cart_created: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK },
    days_from_cart_modified: { metric_type: 'numeric', operators: NUMERIC_OPERATORS_WITH_BLANK }
  },

  purchase: {
    used_a_coupon: { metric_type: 'logical', operators: LOGICAL_OPERATORS },
    coupon_not_used_since: { metric_type: 'numeric', operators: DATE_OPERATORS }
  }
}
