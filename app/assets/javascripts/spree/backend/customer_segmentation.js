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
  this.selectedMetric    = options.selectedMetric;
}

CustomerSegmentation.prototype.initialize = function() {
  this.bindEvents();
  this.selectInitialCategory();
}

CustomerSegmentation.prototype.bindEvents = function() {
  this.$categories.on('mouseenter', this.handleCategorySelection()); // RENAME
  this.$filters.on('click', this.addFilter());
  this.$filterArea.on('click', this.removeFilterButton, this.removeFilter());
  this.$filterArea.on('selectmenuchange', this.operator, this.handleOperatorChange()); // operator changed
}

CustomerSegmentation.prototype.selectInitialCategory = function() {
  this.$categories.first().trigger('mouseenter'); // select initial option.
}

CustomerSegmentation.prototype.handleCategorySelection = function() {
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

CustomerSegmentation.prototype.updateModalTitle = function($category) {
  this.$modalTitle.html($category.data('value'));
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
  this.updateNameParameter($selectedFilter);
  this.$newFilter.find(this.metric).text($selectedFilter.text());
}

CustomerSegmentation.prototype.updateNameParameter = function($selectedFilter) {
  this.$newFilter.find(this.selectedMetric).val($selectedFilter.data('metric'));
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

  $operators.selectmenu().selectmenu("menuWidget").addClass("overflow");
}

CustomerSegmentation.prototype.addFilterValues = function($selectedFilter) {
  var selectedOperator = this.$newFilter.find(this.operator).val(),
      metricType       = this.availableFilters[$selectedFilter.data('metric')]['metric_type'];

  this.updateFilterValueInput(selectedOperator);
}

CustomerSegmentation.prototype.handleOperatorChange = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.updateFilterValueInput($this.val());
  }
}

CustomerSegmentation.prototype.updateFilterValueInput = function(operator) {
  if(operator == "between") {
    this.$newFilter.find(this.values).html(this.$betweenValue.clone());
  } else if(operator == "eq" || operator == "blank" ) {
    var $selectValue = this.$selectValue.clone(),
        $option1 = $('<option>', { value: true, text: 'true' }),
        $option2 = $('<option>', { value: false, text: 'false' });

    $selectValue.append($option1, $option2);
    this.$newFilter.find(this.values).html($selectValue);
    $selectValue.selectmenu().selectmenu("menuWidget").addClass("overflow");
  } else {
    this.$newFilter.find(this.values).html(this.$textValue.clone());
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
    $betweenValue:     $('[data-value="between"]'),   // RENAME
    $textValue:        $('[data-value="text"]'), // RENAME
    $selectValue:      $('[data-value="select"]'), // RENAME
    $filterArea:       $('[data-name="filters_area"]'),
    removeFilterButton: '[data-name="remove_filter"]',
    metric:            '[data-name="metric"]',
    operator:          '[data-name="operator"]',
    values:            '[data-name="values"]',
    selectedMetric:    '[data-name="metric_selected"]'
  },
    customer_segmentation = new CustomerSegmentation(options);

  customer_segmentation.initialize();
})
