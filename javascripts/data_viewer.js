/*jslint indent: 2, onevar: false, browser: true, onevar: false, white: false  */
/*global $, cyoc */

if(popConnect === undefined) {
  var popConnect = {};
}

popConnect.DataViewer = function(element, options) {
  // Private member variables
  var data = {                    // This is where the response to the JSON request will go
    count: 0,
    numerator: 0,
    denominator: 0,
    numerator_fields: [],
    denominator_fields: [],       // These fields should match up letter-for-letter with the actual field names
    gender: {                     // All are human-readable (since they're strings it doesn't matter, and is easier to keep track of)
      'Male': [0, 0],             // Each item should be a two element array...[currently selected, high-water mark]
      'Female': [0, 0]            // Since only males are selected, 0 females are currently selected (out of 5901)
    },
    age: {
      '18-34': [0, 0],
      '35-49': [0, 0],
      '50-64': [0, 0],
      '65-75': [0, 0],
      '76+': [0, 0]
    },
    medications: {
      'Aspirin': [0, 0]
    },
    therapies: {
      'Smoking Cessation': [0, 0]
    },
    blood_pressures: {
      '110/75': [0, 0],
      '120/80': [0, 0],
      '130/80': [0, 0],
      '140/90': [0, 0],
      '160/100': [0, 0],
      '180/110+': [0, 0]
    },
    smoking: {
      'Non-smoker': [0, 0],
      'Ex-smoker': [0, 0],
      'Smoker': [0, 0]
    },
    diabetes: {
      'Yes': [0, 0],
      'No': [0, 0]
    },
    hypertension: {
      'Yes': [0, 0],
      'No': [0, 0]
    }
  };

  var rootElement = $(element);             // Root DOM element for UI
  var dataUrl = options.dataUrl || '/data'; // Where to get data from...not restful, whatever
  var that = this;                          // Traditional javascript nonsense
  var busyness = 0;                         // Current number of jobs. Controls when loading indicator is shown. Don't change directly, use busy/notBusy
  var reportId = options.reportId;          // Report ID, in case we need to send it in the data
  var onComplete = options.complete;        // Callback for when data is loaded
  var onError = options.error;              // Callback for when data doesn't load
  var disabledColor = options.disabledColor || '#999'; // What color is disabled text?
  var enabledColor = options.enabledColor || 'black';  // What color is enabled text?

  // It's sort of arbitrary to split dataDefinition out this way, but I think
  // the individual unit to consider is each section.
  var dataDefinition = options.dataDefinition || {
    types: {
      demographics: {
        label: 'Demographics',
        types: {
          gender: {label: 'Gender', sort: ['Male', 'Female']},
          age: {label: 'Age', sort: ['18-34', '35-49', '50-64', '65-75', '76+']}
        },
        sort: ['gender', 'age']
      },
      treatments: {
        label: 'Treatments',
        types: {
          medications: {label: 'Medications', sort: ['Aspirin']},
          therapies: {label: 'Therapies', sort: ['Smoking Cessation']}
        },
        sort: ['medications', 'therapies']
      },
      risk_factors: {
        label: 'Risk Factors',
        types: {
          blood_pressures: {label: 'Blood Pressure', sort: ['110/75', '120/80', '130/80', '140/90', '160/100', '180/110+']},
          smoking: {label: 'Smoking', sort: ['Non-smoker', 'Ex-smoker', 'Smoker']}
        },
        sort: ['blood_pressures', 'smoking']
      },
      disease_conditions: {
        label: 'Disease & Conditions',
        types: {
          diabetes: {label: 'Diabetes', sort: ['Yes', 'No']},
          hypertension: {label: 'Hypertension', sort: ['Yes', 'No']}
        },
        sort: ['diabetes', 'hypertension']
      }
    },
    sort: ['demographics', 'risk_factors', 'disease_conditions', 'treatments']
  };

  var irregularLabels = {
    diabetes: {'Yes': 'Diabetes', 'No': 'Without Diabetes'},
    hypertension: {'Yes': 'Hypertension', 'No': 'Without Hypertension'},
  }

  // Public functions



  // ........ are there any ??? ..........

  // Priviledged functions
  // Can access both public and private variables and methods

  // This probably shouldn't be used...but I'm adding it just in case
  this.getData = function() {
    return data;
  }

  // Reload DOM elements from data
  this.refresh = function() {
    // Assumes the markup is already there and domNode properties have been set correctly
    // ie don't call this if the DOM element is missing! Call buildInitialDom...

    if(data.title) {
      dataDefinition.reportTitle.text(data.title).removeClass('disabled');
    } else {
      dataDefinition.reportTitle.text('Click to name report').addClass('disabled');
    }

    // Assume the dom nodes already exist and have been set
    var percentage = 0;   // Giant percentage number

    // Let's run the calculations on the data...
    if(data.denominator > 0) {
      percentage = Math.round(data.numerator / data.denominator * 100); // Dividing by 0 apparently doesn't work!! Who knew!?
      dataDefinition.denominatorValueDomNode.removeClass('disabled').text(data.denominator);
    } else {
      dataDefinition.denominatorValueDomNode.addClass('disabled').text(data.denominator);
    }

    if(data.numerator > 0) {
      dataDefinition.numeratorValueDomNode.removeClass('disabled').text(data.numerator);
    } else {
      dataDefinition.numeratorValueDomNode.addClass('disabled').text(data.numerator);
    }

    if(percentage === 0) {
      dataDefinition.masterPercentageDomNode.addClass('disabled').text('0%');
    } else {
      dataDefinition.masterPercentageDomNode.removeClass('disabled').text(percentage + '%');
    }

    dataDefinition.numeratorFieldsDomNode.empty();
    var hasNumerator = false; // There must be a better way to do that
    var key;
    for(key in data.numerator_fields) {
      if(data.numerator_fields.hasOwnProperty(key)) {
        hasNumerator = true;
        $(data.numerator_fields[key]).each(function(i, value) {
          if(irregularLabels[key]) {
            dataDefinition.numeratorFieldsDomNode.append($('<span>').text(irregularLabels[key][value]));
          } else {
            dataDefinition.numeratorFieldsDomNode.append($('<span>').text(value));
          }
        });
      }
    }

    if(!hasNumerator) {
      dataDefinition.numeratorFieldsDomNode.text('Drag items here for the denominator').addClass('disabled');
    } else {
      dataDefinition.numeratorFieldsDomNode.removeClass('disabled');
    }

    dataDefinition.denominatorFieldsDomNode.empty();
    var hasDenominator = false; // There must be a better way to do that
    var key;
    for(key in data.denominator_fields) {
      if(data.denominator_fields.hasOwnProperty(key)) {
        hasDenominator = true;
        $(data.denominator_fields[key]).each(function(i, value) {
          if(irregularLabels[key]) {
            dataDefinition.denominatorFieldsDomNode.append($('<span>').text(irregularLabels[key][value]));
          } else {
            dataDefinition.denominatorFieldsDomNode.append($('<span>').text(value));
          }
        });
      }
    }

    if(!hasDenominator) {
      dataDefinition.denominatorFieldsDomNode.text('Drag items here for the denominator').addClass('disabled');
    } else {
      dataDefinition.denominatorFieldsDomNode.removeClass('disabled');
    }

    var highestPopulationCount = 0;

    $(dataDefinition.sort).each(function(i, currentSection) {
      $(dataDefinition.types[currentSection].sort).each(function(i, subsection) {
        $(dataDefinition.types[currentSection].types[subsection].sort).each(function(i, value) {
          if(data[subsection][value][1] > highestPopulationCount) {
            highestPopulationCount = data[subsection][value][1];
          }
        });
      });
    });

    $(dataDefinition.sort).each(function(i, currentSection) {
      // dataDefinition.types[currentSection] is the section...
      $(dataDefinition.types[currentSection].sort).each(function(j, currentType) {
        // currentTypeDefinition is the sub-section
        var currentTypeDefinition = dataDefinition.types[currentSection].types[currentType];

        $(currentTypeDefinition.domNode).find('.value').each(function(index, value) {
          var labelText = $(value).find('.label').text();
          if(data[currentType][labelText]) {
            var setAt = data[currentType][labelText][0];
            var highWaterMark = data[currentType][labelText][1];

            // TODO: Brian...some sort of UI magic
            var thisPercentage = Math.round(setAt / data.count * 100);
            $(value).find('.percentage').text(thisPercentage);
            $(value).find('.number').text(setAt);
            $(value).find('.bar').append( $('<span>').addClass('total').css('width', Math.round(highWaterMark / highestPopulationCount *100 )+'%') );
            $(value).find('.bar').append( $('<span>').addClass('selected').css('width', Math.round(setAt / highestPopulationCount *100 )+'%') );

          } else {
            // Something bad happened, a label didn't match up with the text...
            console.error("Couldn't find data for: " + labelText);
          }
        });
      });
    });
  };


  // Build the initial DOM containers given the dataDefinition
  // Set the domNode references too!
  this.buildInitialDom = function() {
    $(element).addClass('data_viewer');
    dataDefinition.masterPercentageDomNode = $('<div>').addClass('master_percentage');
    dataDefinition.numeratorValueDomNode = $('<span>');
    dataDefinition.denominatorValueDomNode = $('<span>');
    dataDefinition.numeratorFieldsDomNode = $('<div>');
    dataDefinition.denominatorFieldsDomNode = $('<div>');

    $([dataDefinition.numeratorFieldsDomNode, dataDefinition.denominatorFieldsDomNode]).each(function() {

      var type = this;

      $(this).droppable({
        drop: function(evt, ui) {
          ui.helper.remove(); // Remove the helper clone
          var sectionName = ui.draggable.parent().parent()[0].className.split(' ')[1]; // Sketchy...
          var subsectionName = ui.draggable.parent()[0].className.split(' ')[1]; // Sketchy...
          var value = ui.draggable.find('.label').text();

          var fields_objs = data.denominator_fields;
          if(type == dataDefinition.numeratorFieldsDomNode) {
            fields_objs = data.numerator_fields
          }

          if(fields_objs[subsectionName] && $.inArray(value, fields_objs[subsectionName]) !== -1) {
          } else {
            if(!fields_objs[subsectionName]) {
              fields_objs[subsectionName] = []
            }
            fields_objs[subsectionName].push(value);
            reload(); // This should disable the UI...
          }
        }

      });

    });

    dataDefinition.reportTitle = $('<h2>').addClass('reportTitle');
    var topFrame = $('<div>').addClass('top_frame');
    topFrame.append(dataDefinition.reportTitle);
    topFrame.append(dataDefinition.masterPercentageDomNode);
    var statsContainer = $('<div>');
    statsContainer.append($('<div>').addClass('numerator').append(
      dataDefinition.numeratorValueDomNode).append(
      dataDefinition.numeratorFieldsDomNode));
    statsContainer.append($('<div>').addClass('denominator').append(
      dataDefinition.denominatorValueDomNode).append(
      dataDefinition.denominatorFieldsDomNode));

    topFrame.append(statsContainer);

    var bottomFrame = $('<div>').addClass('bottom_frame');
    $(dataDefinition.sort).each(function(sectionIndex, sectionName) {
      var sectionDiv = $('<div>').addClass('section').addClass(sectionName);
      dataDefinition.types[sectionName].domNode = sectionDiv;
      $(sectionDiv).append($('<h3>').text(dataDefinition.types[sectionName].label));

      $(dataDefinition.types[sectionName].sort).each(function(subsectionIndex, subsectionName) {
        var subsectionDiv = $('<div>').addClass('subsection').addClass(subsectionName);
        dataDefinition.types[sectionName].types[subsectionName].domNode = subsectionDiv;
        $(subsectionDiv).append($('<h4>').append(
          $('<span>').text(dataDefinition.types[sectionName].types[subsectionName].label).addClass('label')).append(
          $('<span>').text('%').addClass('percentage')).append(
          $('<span>').text('#').addClass('number')
        ));

        $(dataDefinition.types[sectionName].types[subsectionName].sort).each(function(labelIndex, valueLabel) {
          var value = $('<div>').addClass('value');
          value.append($('<div>').addClass('label').text(valueLabel));
          value.append($('<div>').addClass('percentage'));
          value.append($('<div>').addClass('number'));
          value.append($('<div>').addClass('bar')); // Not sure if anything else goes here
          value.draggable({
            revert: true,
            helper: 'clone',
            opacity: 0.80
          });
          subsectionDiv.append(value);
        });

        dataDefinition.types[sectionName].types[subsectionName].domNode = subsectionDiv;
        sectionDiv.append(subsectionDiv);
      });

      dataDefinition.types[sectionName].domNode = sectionDiv;
      bottomFrame.append(sectionDiv);
    });

    $(element).append(topFrame);
    $(element).append(bottomFrame);
  };

  // Reload data given selected fields
  this.reload = function() {
    busy();

    $.ajax({
      method: 'GET',
      url: dataUrl,
      dataType: 'json',
      data: buildRequestData(),
      success: function(responseData) {
        data = responseData;
        that.refresh();
        notBusy();
        if(onComplete) {
          onComplete();
        }
      },
      error: function(xhr, resp, msg) {
        showError(resp || msg); // resp is nil if the thing completely fails
        notBusy();
        if(onError) {
          onError();
        }
      }
    })
  };

  // Private functions
  function _init() {
    that.buildInitialDom();
    that.reload();
  };

  // jQuery and rails parameters don't really get along, so let's build the object manually to
  // give Rob a nice params hash to work with.

  // The other option is to post it, which might be necessary if the query string becomes long...
  function buildRequestData() {
    var query_object = {
      numerator: data.numerator_fields,
      denominator: data.denominator_fields
    }
    return popConnect.railsSerializer.serialize(query_object);
  };

  function showError(msg) {
    // TODO: Something...
    console.log(msg);
  }

  // Call when you're doing some sort of work that will take awhile
  function busy() {
    busyness++;

    if(busyness > 1) { // Only show the loading indicator if it's not already showing
      // TODO: Show some sort of loading indicator
      // Probably want to disable the interaction here too...
    }
  };

  // Call when you're done doing work that will take awhile
  function notBusy() {
    busyness--;

    if(busyness < 1) { // Only hide the loading indicator if all work is finished
      // TODO: Remove loading indicator (if present...although it always should be)
      // Enable interaction
    }
  };

  _init();
}