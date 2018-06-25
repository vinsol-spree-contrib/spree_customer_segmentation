alphanumeric = ['includes', 'not includes', 'contains', 'does not contains']
alphanumeric2 = ['starts with', 'includes', 'not includes']
alphanumeric3 = ['contains', 'does not contains']

FILTERS= {
  user: {
    email: { metric_type: 'alphanumeric', operators: alphanumeric },
    name: { metric_type: 'alphanumeric', operators: alphanumeric2 },
    contact_number: { metric_type: 'alphanumeric', operators: alphanumeric3 }
  }
}
