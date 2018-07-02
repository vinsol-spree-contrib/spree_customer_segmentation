function CustomerSegmentation(options) {
  this.$categories       = options.$categories;
  this.$modal            = options.$modal;
  this.$modalTitle       = options.$modalTitle;
  this.$filterButton     = options.$filterButton;
  this.$filterButtonText = options.$filterButtonText;
  this.$filters          = options.$filters;
  this.$filterTemplate   = options.$filterTemplate;
  this.metric            = options.metric;
  this.operator          = options.operator;
  this.values            = options.values;
  this.$filterArea       = options.$filterArea;
  this.removeFilterButton = options.removeFilterButton;
  this.availableFilters  = options.$availableFilters.data('value');
  this.$betweenValue     = options.$betweenValue;
  this.$textValue        = options.$textValue;
  this.$selectValue      = options.$selectValue;
}

CustomerSegmentation.prototype.initialize = function() {
  this.filterOperatorList = $('[data-name="filter_operator_list"]').data('value');

  this.bindEvents();
  this.selectInitialCategory();
}

CustomerSegmentation.prototype.bindEvents = function() {
  this.$categories.on('mouseenter', this.handleCategorySelection()); // RENAME
  this.$filters.on('click', this.addFilter());
  this.$filterArea.on('click', this.removeFilterButton, this.removeFilter());
}

CustomerSegmentation.prototype.selectInitialCategory = function() {
  this.$categories.first().trigger('mouseenter'); // select initial option.
}

CustomerSegmentation.prototype.changeValueInput = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.$categories.not($this).removeClass('active');
    $this.addClass('active');

    _this.updateMetricOptions($this);
    _this.updateModalTitle($this);
  }
}

CustomerSegmentation.prototype.updateMetricOptions = function($category) {
  var categorySelected = $category.data('category'),
      $selectedCategoryMetrics = $('[data-category="' + categorySelected + '"]');

  this.$filters.not($selectedCategoryMetrics).addClass('hidden');
  $selectedCategoryMetrics.removeClass('hidden');
}

CustomerSegmentation.prototype.createValue = function() {
  var $value = $('<input>', { type: 'text', name: 'value' });

  this.$row.find('[data-hook="value"]').append($value);
}

CustomerSegmentation.prototype.addFilter = function() {
  var _this = this;

  return function() {
    var $selectedFilter = $(this);
    _this.$newFilter    = _this.$filterTemplate.clone();

    _this.$modal.modal('hide');

    _this.addFilterMetric($selectedFilter);
    _this.addFilterOperators($selectedFilter);
    _this.addFilterValues($selectedFilter);

    _this.$newFilter.insertBefore(_this.$filterButton);

    _this.animateFilterButton();
  }
}

CustomerSegmentation.prototype.addFilterMetric = function($selectedFilter) {
  this.$newFilter.find(this.metric).text($selectedFilter.text());
}

CustomerSegmentation.prototype.addFilterOperators = function($selectedFilter) {
  var selectedFilterOperators = this.availableFilters[$selectedFilter.data('metric')]['operators'],
      $operators              = this.$newFilter.find(this.operator),
      documentFragment        = document.createDocumentFragment(),
      $option;

  $.each(selectedFilterOperators, function(key, value) {
    $option = $('<option>', { value: key }).text(value);
    documentFragment.append($option[0]);
  });

  $operators.append(documentFragment);

  $operators.selectmenu().selectmenu( "menuWidget" ).addClass("overflow");
}

CustomerSegmentation.prototype.addFilterValues = function($selectedFilter) {
  var selectedOperator = this.$newFilter.find(this.operator).val(),
      metricType       = this.availableFilters[$selectedFilter.data('metric')]['metric_type'];

  // CHANGE
  // For now
  if(selectedOperator == "between") {
    this.$newFilter.find(this.values).append(this.$betweenValue.clone());
  } else {
    this.$newFilter.find(this.values).append(this.$textValue.clone());
  }

}

CustomerSegmentation.prototype.animateFilterButton = function() {
  this.$filterButton.removeClass('only-row');
  this.$filterButtonText.addClass('add_filter_text');
}

CustomerSegmentation.prototype.removeFilter = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    $this.closest('[data-name="filter_row"]').remove();

    if(_this.filtersPresent()) {
      _this.removeFilterButtonAnimation();
    }
  }
}

CustomerSegmentation.prototype.filtersPresent = function() {
  return this.$filterArea.find('[data-name="filter_row"]').length == 0
}

CustomerSegmentation.prototype.removeFilterButtonAnimation = function() {
  this.$filterButton.addClass('only-row');
  this.$filterButtonText.removeClass('add_filter_text');
}

$(function() {
  var options = {
    $categories:       $('[data-name="category"]'),
    $modal:            $('[data-name="filter_modal"]'),
    $modalTitle:       $('[data-name="category_selected"]'),
    $filterButton:     $('[data-name="filter_button"]'),
    $filterButtonText: $('[data-name="filter_button_text"]'),
    $filters:          $('[data-name="filter"]'),
    $filterTemplate:   $('[data-name="filter_row"]'),
    $availableFilters: $('[data-name="filter_operator_list"]'),
    $betweenValue:     $('[data-name="between"]'),   // RENAME
    $textValue:        $('[data-name="text"]'), // RENAME
    $selectValue:      $('[data-name="select"]'), // RENAME
    $filterArea:       $('[data-name="filters_area"]'),
    removeFilterButton: '[data-name="remove_filter"]',
    metric:            '[data-name="metric"]',
    operator:          '[data-name="operator"]',
    values:            '[data-name="values"]'
  },
    customer_segmentation = new CustomerSegmentation(options);

  customer_segmentation.initialize();
})
