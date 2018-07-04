function CustomerSegmentation(options) {
  this.$categories        = options.$categories;
  this.$modal             = options.$modal;
  this.$modalTitle        = options.$modalTitle;
  this.$filterButton      = options.$filterButton;
  this.$filterButtonText  = options.$filterButtonText;
  this.$filters           = options.$filters;
  this.$filterArea        = options.$filterArea;
  this.$betweenValue      = options.$betweenValue;
  this.$textValue         = options.$textValue;
  this.$selectValue       = options.$selectValue;
  this.$logicalValue      = options.$logicalValue;
  this.$hiddenValue       = options.$hiddenValue;
  this.$appliedFilters    = options.$appliedFilters;
  this.$filterTemplate    = options.$filterTemplate;
  this.removeFilterButton = options.removeFilterButton;
  this.availableFilters   = options.$availableFilters.data('value');
  this.metric             = options.metric;
  this.operator           = options.operator;
  this.values             = options.values;
  this.selectedMetric     = options.selectedMetric;
  this.filterRow          = options.filterRow;
  this.input              = options.input;
}

CustomerSegmentation.prototype.initialize = function() {
  this.currentlyAppliedFilters = []; // store all applied filters
  this.bindEvents();

  this.$categories.first().trigger('mouseenter'); // Select the first category inside modal
  this.rebuildSelectedFilters(); // previous filters
}

CustomerSegmentation.prototype.bindEvents = function() {
  this.$categories.on('mouseenter', this.handleCategorySelection()); // When admin changes category inside modal
  this.$filters.on('click', this.addFilter()); // When filter is selected
  this.$filterArea.on('click', this.removeFilterButton, this.removeFilter()); // Delegate filter removal event
  this.$filterArea.on('change', this.operator, this.handleOperatorChange()); // Delegate operator change event
}

CustomerSegmentation.prototype.handleCategorySelection = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.$categories.not($this).removeClass('active');
    $this.addClass('active');

    _this.updateMetricOptions($this);
    _this.$modalTitle.html($this.data('value'));
  }
}

// Show metrics of selected category, hide all others
CustomerSegmentation.prototype.updateMetricOptions = function($category) {
  var categorySelected = $category.data('category'),
      $selectedCategoryMetrics = $('[data-category="' + categorySelected + '"]');

  this.$filters.not($selectedCategoryMetrics).addClass('hidden');
  $selectedCategoryMetrics.removeClass('hidden');
}

CustomerSegmentation.prototype.addFilter = function() {
  var _this = this;

  return function() {
    var $selectedFilter = $(this),
        metric = $selectedFilter.data('metric');

    _this.$modal.modal('hide');

    // If filter is not applied already
    if (_this.currentlyAppliedFilters.indexOf(metric) == -1) {
      _this.buildFilter($selectedFilter);
      _this.animateFilterButton();

      _this.currentlyAppliedFilters.push(metric);
    } else {
      alert('This filter is already applied.')
    }
  }
}

CustomerSegmentation.prototype.buildFilter = function($selectedFilter) {
  this.$currentFilter = this.$filterTemplate.clone();
  this.addFilterElements($selectedFilter);
  this.$currentFilter.insertBefore(this.$filterButton);
}

CustomerSegmentation.prototype.addFilterElements = function($selectedFilter) {
  this.$currentFilter.find(this.metric).text($selectedFilter.text());
  this.addFilterOperators($selectedFilter);
  this.addFilterValues($selectedFilter);
}

CustomerSegmentation.prototype.initializeCurrentFilterVariables = function($selectedFilter) {
  this.selectedOperator       = this.$currentFilter.find(this.operator).val(),
  this.selectedMetricType     = $selectedFilter.data('metric');
  this.selectedMetricDataType = this.availableFilters[this.selectedMetricType]['metric_type'];
}

CustomerSegmentation.prototype.addFilterOperators = function($selectedFilter) {
  var selectedFilterOperators = this.availableFilters[$selectedFilter.data('metric')]['operators'],
      $operators              = this.$currentFilter.find(this.operator),
      documentFragment        = document.createDocumentFragment(),
      $option;

  $.each(selectedFilterOperators, function(key, value) {
    $option = $('<option>', { value: key }).text(value);
    documentFragment.append($option[0]);
  });

  $operators.append(documentFragment).select2({
    containerCssClass: 'custom_select'
  });
}

CustomerSegmentation.prototype.addFilterValues = function($selectedFilter) {
  this.initializeCurrentFilterVariables($selectedFilter);
  this.updateFilterValueInput();
}

CustomerSegmentation.prototype.handleOperatorChange = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.$currentFilter = $this.closest(_this.filterRow);
    _this.selectedOperator = $this.val();
    _this.updateFilterValueInput();
  }
}

CustomerSegmentation.prototype.updateFilterValueInput = function() {
  var operator = this.selectedOperator,
      $input = this.$currentFilter.find(this.values);

  if(operator == "between") {
    $input.html(this.$betweenValue.clone());
  } else if(operator == "equals" || operator == "blank" ) {
     this.createLogicalOperators();
  } else if(operator == "includes" || operator == "not_includes" || operator == "includes_all") {
    this.enableTagInputs();
  } else {
    $input.html(this.$textValue.clone());
  }

  this.addNameToValueInput();
}

CustomerSegmentation.prototype.addNameToValueInput = function() {
  $values = this.$currentFilter.find(this.input);

  $values.attr('name', $values.attr('name').replace('metric', this.selectedMetricType));
  $values.attr('name', $values.attr('name').replace('operator', this.selectedOperator));
}

CustomerSegmentation.prototype.createLogicalOperators = function() {
  var $logicalValues = this.$logicalValue.clone();
  this.$currentFilter.find(this.values).html($logicalValues);
  $logicalValues.select2();
}

CustomerSegmentation.prototype.enableTagInputs = function() {
  var $input = this.$hiddenValue.clone();
  this.$currentFilter.find(this.values).html($input);
  this.enableTagging($input);
}

CustomerSegmentation.prototype.enableTagging = function($input) {
  $input.select2({
    tags: [],
    formatNoMatches: function() {
        return '';
    },
    placeholder: 'Please press enter for multiple inputs'
  })
}

CustomerSegmentation.prototype.animateFilterButton = function() {
  this.$filterButton.removeClass('only-row');
  this.$filterButtonText.addClass('add_filter_text');
}

CustomerSegmentation.prototype.removeFilter = function() {
  var _this = this;
  return function() {
    var $this = $(this),
        metric = $this.find(this.metric).data('metric');

    $this.closest(_this.filterRow).remove();
    _this.removeFilterFromCurrentlyAppliedFilters(metric);

    if(_this.$filterArea.find(_this.filterRow).length == 0) {
      _this.removeFilterButtonAnimation();
    }
  }
}

CustomerSegmentation.prototype.removeFilterFromCurrentlyAppliedFilters = function(metric) {
  var index = this.currentlyAppliedFilters.indexOf(metric);
  this.currentlyAppliedFilters.splice(index, 1);
}

CustomerSegmentation.prototype.removeFilterButtonAnimation = function() {
  this.$filterButton.addClass('only-row');
  this.$filterButtonText.removeClass('add_filter_text');
}

// Rebuild params logic
CustomerSegmentation.prototype.rebuildSelectedFilters = function() {
  var appliedFilters = this.$appliedFilters.data('value'),
      _this = this;

  $.each(appliedFilters, function() {
    $('[data-metric="' + this['metric'] + '"]').click();
    _this.$currentFilter.find(_this.operator).val(this['operator']).trigger('change');
    _this.reEnterInputValue(this['operator'], this['value']);
  })
}

CustomerSegmentation.prototype.reEnterInputValue = function(operator, value) {
  var $input = this.$currentFilter.find(this.input);

  if(operator == "between") {
    $input.first().val(value[0]);
    $input.last().val(value[1]);
  } else if(operator == "equals" || operator == "blank") {
    $input.val(value);
  } else if (operator == "includes" || operator == "includes_all" || operator == "includes_all") {
    this.enableTagging($input);
    $input.val(value).trigger('change');
  } else {
    $input.val(value);
  }
}

$(function() {
  var options = {
    $categories:        $('[data-name="category"]'),
    $modal:             $('[data-name="filter_modal"]'),
    $modalTitle:        $('[data-name="category_selected"]'),
    $filterButton:      $('[data-name="filter_button"]'),
    $filterButtonText:  $('[data-name="filter_button_text"]'),
    $filters:           $('[data-name="filter"]'),
    $filterTemplate:    $('[data-name="filter_row"]'),
    $availableFilters:  $('[data-name="filter_operator_list"]'),
    $betweenValue:      $('[data-value="between"]'),
    $textValue:         $('[data-value="text"]'),
    $selectValue:       $('[data-value="select"]'),
    $logicalValue:      $('[data-value="logical"]'),
    $hiddenValue:       $('[data-value="hidden"]'),
    $filterArea:        $('[data-name="filters_area"]'),
    $appliedFilters:    $('[data-name="applied_filters"]'),
    removeFilterButton: '[data-name="remove_filter"]',
    metric:             '[data-name="metric"]',
    operator:           '[data-name="operator"]',
    values:             '[data-name="values"]',
    selectedMetric:     '[data-name="metric_selected"]',
    filterRow:          '[data-name="filter_row"]',
    input:              '[data-name="input"]'
  },
    customer_segmentation = new CustomerSegmentation(options);

  customer_segmentation.initialize();
})
