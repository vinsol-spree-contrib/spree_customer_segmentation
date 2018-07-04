function CustomerSegmentation(options) {
  this.$categories        = options.$categories;
  this.$modal             = options.$modal;
  this.$modalTitle        = options.$modalTitle;
  this.$filterButton      = options.$filterButton;
  this.$filterButtonText  = options.$filterButtonText;
  this.$filters           = options.$filters;
  this.$filterTemplate    = options.$filterTemplate;
  this.metric             = options.metric;
  this.operator           = options.operator;
  this.values             = options.values;
  this.$filterArea        = options.$filterArea;
  this.removeFilterButton = options.removeFilterButton;
  this.availableFilters   = options.$availableFilters.data('value');
  this.$betweenValue      = options.$betweenValue;
  this.$textValue         = options.$textValue;
  this.$selectValue       = options.$selectValue;
  this.selectedMetric     = options.selectedMetric;
}

CustomerSegmentation.prototype.initialize = function() {
  this.currentlyAppliedFilters = []; // store all applied filters
  this.bindEvents();
  this.selectInitialCategory();
  this.rebuildSelectedFilters(); // previous filters
}

CustomerSegmentation.prototype.bindEvents = function() {
  this.$categories.on('mouseenter', this.handleCategorySelection());
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
    _this.$modalTitle.html($this.data('value'));
  }
}

CustomerSegmentation.prototype.updateMetricOptions = function($category) {
  var categorySelected = $category.data('category'),
      $selectedCategoryMetrics = $('[data-category="' + categorySelected + '"]');

  this.$filters.not($selectedCategoryMetrics).addClass('hidden');
  $selectedCategoryMetrics.removeClass('hidden');
}

CustomerSegmentation.prototype.addFilter = function() {
  var _this = this;

// OPTIMIZE
  return function() {
    var $selectedFilter  = $(this);

    if (_this.ensureFilterNotAppliedAlready($selectedFilter.data('metric'))) {
      _this.$currentFilter = _this.$filterTemplate.clone();

      _this.$modal.modal('hide');
      _this.addFilterMetric($selectedFilter);
      _this.addFilterOperators($selectedFilter);
      _this.addFilterValues($selectedFilter);

      _this.$currentFilter.insertBefore(_this.$filterButton);

      _this.animateFilterButton();

      _this.currentlyAppliedFilters.push($selectedFilter.data('metric'));
    } else {
      // _this.$modal.modal('hide');
      alert('Filter already applied');
    }
  }
}

CustomerSegmentation.prototype.ensureFilterNotAppliedAlready = function(metric) {
  var index = this.currentlyAppliedFilters.indexOf(metric);
  return (index == -1);
}

CustomerSegmentation.prototype.initializecurrentFilterVariables = function($selectedFilter) {
  this.selectedOperator       = this.$currentFilter.find(this.operator).val(),
  this.selectedMetricType     = $selectedFilter.data('metric');
  this.selectedMetricDataType = this.availableFilters[this.selectedMetricType]['metric_type'];
}

CustomerSegmentation.prototype.addFilterMetric = function($selectedFilter) {
  // this.$currentFilter.find(this.selectedMetric).val($selectedFilter.data('metric')); // add metric value to hidden input field
  this.$currentFilter.find(this.metric).text($selectedFilter.text());
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

  $operators.append(documentFragment);

  $operators.selectmenu().selectmenu("menuWidget").addClass("overflow");
}

CustomerSegmentation.prototype.addFilterValues = function($selectedFilter) {
  this.initializecurrentFilterVariables($selectedFilter);

  this.updateFilterValueInput();
}

CustomerSegmentation.prototype.handleOperatorChange = function() {
  var _this = this;

  return function() {
    var $this = $(this);
    _this.$currentFilter = $this.closest('[data-name="filter_row"]');
    _this.selectedOperator = $this.val();
    _this.updateFilterValueInput();
  }
}

CustomerSegmentation.prototype.updateFilterValueInput = function() {
  var operator = this.selectedOperator;

  if(operator == "between") {
    this.$currentFilter.find(this.values).html(this.$betweenValue.clone());
  } else if(operator == "equals" || operator == "blank" ) {
     this.createLogicalOperators();
  } else if(operator == "includes" || operator == "not_includes" || operator == "includes_all") {
    this.enableTagInputs();
  } else {
    this.$currentFilter.find(this.values).html(this.$textValue.clone());
  }

  this.addNameToValueInput();
}

CustomerSegmentation.prototype.addNameToValueInput = function() {
  $values = this.$currentFilter.find('[data-name="input"]');

  $values.attr('name', $values.attr('name').replace('metric', this.selectedMetricType));
  $values.attr('name', $values.attr('name').replace('operator', this.selectedOperator));
}

CustomerSegmentation.prototype.createLogicalOperators = function() {
  var $logicalValues = $('[data-value="logical"]').clone();
  this.$currentFilter.find(this.values).html($logicalValues);
  $logicalValues.selectmenu().selectmenu("menuWidget").addClass("overflow");
}

// ENABLE TAGS { SELECT2  }
CustomerSegmentation.prototype.enableTagInputs = function() {
  var $input = this.$textValue.clone();
  this.$currentFilter.find(this.values).html($input);
  //
  // $input.select2({
  //   minimumInputLength: -1,
  //   tokenSeparators: [','],
  //   multiple: true,
  //   tags: true,
  // });
}

CustomerSegmentation.prototype.animateFilterButton = function() {
  this.$filterButton.removeClass('only-row');
  this.$filterButtonText.addClass('add_filter_text');
}

CustomerSegmentation.prototype.removeFilter = function() {
  var _this = this;
// OPTIMIZE
  return function() {
    var $this = $(this);
    var metric = $this.find(this.metric).data('metric');

    $this.closest('[data-name="filter_row"]').remove();


    if(_this.filtersPresent()) {
      _this.removeFilterButtonAnimation();

      var index = _this.currentlyAppliedFilters.indexOf(metric);
      _this.currentlyAppliedFilters.splice(index, 1);

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

// Rebuild params logic
// OPTIMIZE
CustomerSegmentation.prototype.rebuildSelectedFilters = function() {
  var appliedFilters = $('[data-name="applied_filters"]').data('value'),
      _this = this;

  $.each(appliedFilters, function() {
    $('[data-metric="' + this['metric'] + '"]').click();

    _this.$currentFilter.find(_this.operator).val(this['operator']);
    _this.$currentFilter.find(_this.operator).selectmenu('refresh').trigger('selectmenuchange');

    if(this['operator'] == "between") {
      _this.$currentFilter.find('[data-name="input"]').first().val(this['value'][0]);
      _this.$currentFilter.find('[data-name="input"]').last().val(this['value'][1]);
    } else if(this['operator'] == "equals" || this['operator'] == "blank") {
      _this.$currentFilter.find('[data-name="input"]').val(this['value']);
      _this.$currentFilter.find('[data-name="input"]').selectmenu('refresh');
    } else if (this['operator'] == "includes" || this['operator'] == "includes_all" || this['operator'] == "includes_all") {
      _this.$currentFilter.find('[data-name="input"]').val(this['value']);
    } else {
      _this.$currentFilter.find('[data-name="input"]').val(this['value']);
    }

  })
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
    $filterArea:        $('[data-name="filters_area"]'),
    removeFilterButton: '[data-name="remove_filter"]',
    metric:             '[data-name="metric"]',
    operator:           '[data-name="operator"]',
    values:             '[data-name="values"]',
    selectedMetric:     '[data-name="metric_selected"]'
  },
    customer_segmentation = new CustomerSegmentation(options);

  customer_segmentation.initialize();
})
