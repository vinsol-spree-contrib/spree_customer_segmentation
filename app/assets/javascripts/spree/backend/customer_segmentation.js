function CustomerSegmentation(options) {
  this.$filterRow = options.$filterRow;
  this.$filters = options.$filters;
}

CustomerSegmentation.prototype.initialize = function() {
  this.filterOperatorList = $('[data-name="filter_operator_list"]').data('value');

  this.bindEvents();
}

CustomerSegmentation.prototype.bindEvents = function() {
  this.$filters.on('click', this.buildFilter());
}

CustomerSegmentation.prototype.buildFilter = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.$row = _this.$filterRow.clone();

    _this.createMetric($this);
    _this.createOperator($this);
    _this.createValue();

    $('[data-hook="filters"]').append(_this.$row);
  }
}

CustomerSegmentation.prototype.createMetric = function($filter) {
  var $metric = $('<input>', { type: 'hidden', name: 'metric' }).val($filter.data('metric'));

  this.$row.find('[data-name="metric-value"]').text($filter.data('text'));
  this.$row.find('[data-hook="metric"]').append($metric);
}

CustomerSegmentation.prototype.createOperator = function($filter) {
  var $operator = $('<select>', { name: 'operator' }),
      availableOperators = this.filterOperatorList[$filter.data('category')][$filter.data('value')]['operators'],
      documentFragment = document.createDocumentFragment(),
      $option;

  $operator.attr('name', 'operator');

  $.each(availableOperators, function(key, value) {
    $option = $('<option>', { value: key }).text(value);
    documentFragment.append($option[0]);
  });

  $operator.append(documentFragment);
  this.$row.find('[data-hook="operator"]').append($operator);
}

CustomerSegmentation.prototype.createValue = function() {
  var $value = $('<input>', { type: 'text', name: 'value' });

  this.$row.find('[data-hook="value"]').append($value);
}

$(function() {
  var options = {
      $filterRow: $('[data-name="filter-row"]'),
      $filters: $('[data-name="filter"]'),
    },
    customer_segmentation = new CustomerSegmentation(options);

  customer_segmentation.initialize();
})
