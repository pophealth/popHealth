/*jslint indent: 2, onevar: false, browser: true, onevar: false, white: false  */
/*global $, cyoc */

if(popConnect === undefined) {
  var popConnect = {};
}

popConnect.DataViewer = function(element, options) {
  // Private member variables
  var data = {                    // This is where the response to the JSON request will go
    id: options.reportId,
		numerator_sql: "",
    numerator_fields: [],
    denominator_fields: []       // These fields should match up letter-for-letter with the actual field names
  };

  var rootElement = $(element);             // Root DOM element for UI
  var dataUrl = options.dataUrl || '/data'; // Where to get data from...not restful, whatever
  var that = this;                          // Traditional javascript nonsense
  var busyness = 0;                         // Current number of jobs. Controls when loading indicator is shown. Don't change directly, use busy/notBusy
  this.onComplete = options.complete;        // Callback for when data is loaded
  this.onError = options.error;              // Callback for when data doesn't load
  if(options.exportLink)
    this.exportLink = options.exportLink;


  // It's sort of arbitrary to split dataDefinition out this way, but I think
  // the individual unit to consider is each section.
  var dataDefinition = options.dataDefinition || {
    types: {
      demographics: {
        label: 'Demographics',
        types: {
          gender: {label: 'Gender', sort: ['Male', 'Female']},
          age: {label: 'Age', sort: ['<18', '18-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80+']}
        },
        sort: ['gender', 'age']
      },
	  risk_factors: {
        label: 'Risk Factors',
        types: {
          blood_pressures: {label: 'Blood Pressure', sort: ['110/70', '120/80', '140/90', '160/100', '180/110+']},
          smoking: {label: 'Smoking', sort: ['Current Smoker', 'Non-Smoker']},
          colorectal_cancer_screening: {label: 'Colon Cancer Screening', sort: ['Yes', 'No']},
          mammography: {label: 'Mammography 24 Months', sort: ['Yes', 'No']}
        },
        sort: ['blood_pressures', 'smoking', 'colorectal_cancer_screening', 'mammography']
      },
      treatments: {
        label: 'Treatments',
        types: {
          medications: {label: 'Medications', sort: ['Aspirin']},
          therapies: {label: 'Therapies', sort: ['Smoking Cessation']}
        },
        sort: ['medications', 'therapies']
      },
      disease_conditions: {
        label: 'Disease & Conditions',
        types: {
          diabetes: {label: 'Diabetes', sort: ['Yes', 'No']},
          hypertension: {label: 'Hypertension', sort: ['Yes', 'No']},
          ischemic_vascular_disease: {label: 'Ischemic Vascular Disease', sort:['Yes', 'No']},
          lipoid_disorder: {label: 'Lipoid Disorder', sort:['Yes', 'No']}
        },
        sort: ['diabetes', 'hypertension', 'ischemic_vascular_disease', 'lipoid_disorder']
      }, 
      lab_results: {
        label: 'Lab Results',
        types: {
          ldl_cholesterol: {label: 'LDL Cholesterol (mg/dL)', sort: ['100', '100-120', '130-160', '160-180', '180+']},
          hb_a1c: {label: 'Hemoglobin A1c (%)', sort: ['<7', '7-8', '8-9', '9+']}
        },
        sort: ['ldl_cholesterol', 'hb_a1c']
      },
      immunizations: {
          label: 'Immunizations',
          types: {
          influenza_vaccine: {label: 'Influenza', sort: ['Yes', 'No']}
          },
          sort: ['influenza_vaccine']
      }
    },
    sort: ['demographics', 'lab_results', 'disease_conditions', 'risk_factors', 'treatments', 'immunizations']
  };

  var irregularLabels = {
    diabetes: {'Yes': 'Diabetes', 'No': 'Without Diabetes'},
    hypertension: {'Yes': 'Hypertension', 'No': 'Without Hypertension'},
    medications: {'Aspirin': 'Aspirin Therapy'},
    ischemic_vascular_disease: {'Yes': 'Vascular Disease', 'No': 'Without Vascular Disease'},
    lipoid_disorder: {'Yes': 'Lipoid disorder', 'No': 'No Lipoid disorder'},
    colorectal_cancer_screening: {'Yes': 'Colon Cancer Screen', 'No': 'Without Colon Cancer Screen'},
    mammography: {'Yes': 'Mammography Screen', 'No': 'Without Mammography Screen'},
    influenza_vaccine: {'Yes': 'Influenza Vaccine', 'No': 'Without Influenza Vaccine'},
    ldl_cholesterol: {'100': 'LDL <100 mg/dL', '100-120': 'LDL 100-120 mg/dL', '130-160': 'LDL 130-160 mg/dL', '160-180': 'LDL 160-180 mg/dL', '180+': 'LDL 180+ mg/dL'},
	hb_a1c: {'<7':'Hb A1c < 7%', '7-8':'Hb A1c 7%-8%', '8-9':'Hb A1c 8%-9%', '9+': 'Hb A1c > 9%'}
  };

  // Public functions



  // ........ are there any ??? ..........

  // Priviledged functions
  // Can access both public and private variables and methods

  // This probably shouldn't be used...but I'm adding it just in case
  this.getData = function() {
    return data;
  };
  
  this.selectReport = function(id) {
    busy();
    that.reload({id: id}, 'GET');
  };
  
  this.newReport = function() {
    busy();
    data = {
      numerator_fields: [],
      denominator_fields: []       // These fields should match up letter-for-letter with the actual field names
    };
    that.reload(buildTailoredData(), 'POST');
  };

  // Reload DOM elements from data
  this.refresh = function() {
    // Assumes the markup is already there and domNode properties have been set correctly
    // ie don't call this if the DOM element is missing! Call buildInitialDom...

		if(data.id)
		{
			 dataDefinition.numeratorSqlDomNode.attr("href", "/patients/list?report_id=" +  escape(data.id))
		}

    if(data.title) {
      dataDefinition.reportTitle.text(data.title).removeClass('disabled');
      dataDefinition.changedReportTitle.val(data.title);
    } else {
      dataDefinition.reportTitle.text('click to name report').addClass('disabled');
      dataDefinition.changedReportTitle.val('Type report name');
    }

    // Assume the dom nodes already exist and have been set
    var percentage = 0;   // Giant percentage number

    // Let's run the calculations on the data...
    if(data.denominator > 0) {
      percentage = data.numerator / data.denominator * 100; // Dividing by 0 apparently doesn't work!! Who knew!?
      dataDefinition.denominatorValueDomNode.removeClass('disabled').text(data.denominator);
    } else {
      dataDefinition.denominatorValueDomNode.addClass('disabled').text(data.denominator);
    }

    if(data.numerator > 0) {
      dataDefinition.numeratorValueDomNode.removeClass('disabled').text(data.numerator);
    } else {
      dataDefinition.numeratorValueDomNode.addClass('disabled').text(data.numerator);
    }
    if(percentage == 0) {
      dataDefinition.masterPercentageDomNode.addClass('disabled').text('0').append( $('<span>').text('%') );
    } else if (percentage < 0.5) {
      dataDefinition.masterPercentageDomNode.addClass('disabled').text('<1').append( $('<span>').text('%') );
    } else {
      dataDefinition.masterPercentageDomNode.removeClass('disabled').text(Math.round(percentage) + '%');
    }

    dataDefinition.numeratorFieldsDomNode.empty();
    var hasNumerator = false; // There must be a better way to do that
    var key;
    for(key in data.numerator_fields) {
      if(data.numerator_fields.hasOwnProperty(key)) {
        hasNumerator = true;
        $(data.numerator_fields[key]).each(function(i, value) {
          var span = $('<span>');
          if(irregularLabels[key]) {
            dataDefinition.numeratorFieldsDomNode.append(span.text(irregularLabels[key][value]));
          } else {
            dataDefinition.numeratorFieldsDomNode.append(span.text(value));
          }
          var cds = key.toString();
          var cdv = value.toString();
          span.addClass('draggable-value');
          span.draggable({
            revert: true,
            helper: 'clone',
            opacity: 0.80,
            start: function() {
              that.currentlyDraggedSubsection = cds;
              that.currentlyDraggedValue = cdv;
            }
          });
        });
      }
    }

    if(!hasNumerator) {
      dataDefinition.numeratorFieldsDomNode.text('Drag items here for the numerator').addClass('disabled');
    } else {
      dataDefinition.numeratorFieldsDomNode.removeClass('disabled');
    }

    dataDefinition.denominatorFieldsDomNode.empty();
    var hasDenominator = false; // There must be a better way to do that
    for(key in data.denominator_fields) {
      if(data.denominator_fields.hasOwnProperty(key)) {
        hasDenominator = true;
        $(data.denominator_fields[key]).each(function(i, value) {
          var span = $('<span>');
          if(irregularLabels[key]) {
            dataDefinition.denominatorFieldsDomNode.append(span.text(irregularLabels[key][value]));
          } else {
            dataDefinition.denominatorFieldsDomNode.append(span.text(value));
          }
          var cds = key.toString();
          var cdv = value.toString();
          span.addClass('draggable-value')
          span.draggable({
            revert: true,
            helper: 'clone',
						appendTo: "#main",
            opacity: 0.80,
            start: function() {
              that.currentlyDraggedSubsection = cds;
              that.currentlyDraggedValue = cdv;
            }
          });
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

        $(currentTypeDefinition.domNode).find('.row').each(function(index, value) {
          var labelText = $(value).find('.label').text();
          if(data[currentType][labelText]) {
            var setAt = data[currentType][labelText][0];
            var highWaterMark = data[currentType][labelText][1];
            var inNumerator = data.numerator_fields[currentType] && $.inArray(labelText, data.numerator_fields[currentType]) > -1;
            var inDenominator = data.denominator_fields[currentType] && $.inArray(labelText, data.denominator_fields[currentType]) > -1;
            if(inDenominator) {
              $(value).removeClass('in-numerator').addClass('in-denominator');
            } 
            if(inNumerator) {
              $(value).addClass('in-numerator').removeClass('in-denominator');
            }
            if(inNumerator || inDenominator) {
              $(value).addClass('nodrag').addClass('selected').removeClass('draggable-value');
              var old = $(value);
              value = $(value).clone();
              $(old).replaceWith(value);
              // I don't know why .unbind doesn't work, but it doesn't
            } else {
              $(value).removeClass('selected').removeClass('in-denominator').removeClass('in-numerator');
              $(value).removeClass('nodrag');
              $(value).addClass('draggable-value');
              $(value).draggable({
                revert: true,
                helper: 'clone',
								appendTo: '#main',
                opacity: 0.80,
                start: function(evt, ui) {
                  that.currentlyDraggedSubsection = currentType;
                  that.currentlyDraggedValue = $(value).find('.label').text();
                }
              });
            }
            var thisPercentage = setAt / data.count * 100;
            if(thisPercentage < 0.5) {
              $(value).find('.percentage').text('<1');
            } else {
              $(value).find('.percentage').text(Math.round(thisPercentage));
            }
            
            $(value).find('.number').text(setAt);
            $(value).find('.bar').empty().append( $('<span>').addClass('total').css('width', Math.round(highWaterMark / highestPopulationCount *100 )+'%') );
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
    $(element).addClass('report view');
    dataDefinition.masterPercentageDomNode = $('<h1>');
    dataDefinition.numeratorValueDomNode = $('<h2>');
    dataDefinition.denominatorValueDomNode = $('<h2>');
    dataDefinition.numeratorFieldsDomNode = $('<div>');
    dataDefinition.denominatorFieldsDomNode = $('<div>');
    dataDefinition.numeratorSqlDomNode = $('#list-url');


    
    dataDefinition.reportTitle = $('<h2>').addClass('title').click(function() {
      dataDefinition.reportTitle.toggle();
      dataDefinition.reportTitleEdit.toggle();
      dataDefinition.changedReportTitle.focus();
      dataDefinition.changedReportTitle.select();
    });
    
    dataDefinition.reportTitleEdit = $('<span>').addClass('name-edit');
    
    var cancel = $('<a>').attr('href', '#').text('Cancel').click(function() {
      dataDefinition.reportTitle.toggle();
      dataDefinition.reportTitleEdit.toggle();
      if(data.title) {
        dataDefinition.changedReportTitle.val(data.title);
      } else {
        dataDefinition.changedReportTitle.val('Type report name');
      }
    });
    
    var ok = $('<a>').attr('href', '#').text('Save').click(function() {
      busy();
      dataDefinition.reportTitle.toggle();
      dataDefinition.reportTitleEdit.toggle();
      data.title = dataDefinition.changedReportTitle.val();
      that.reload(buildTailoredData(), 'POST');
    });
    dataDefinition.changedReportTitle = $('<input>').attr('type', 'text').addClass('reportTitle');
    
    dataDefinition.reportTitleEdit.append(dataDefinition.changedReportTitle).append(ok).append(cancel).hide();
    
    var topFrame = $('<div>').addClass('overview');
    topFrame.append(dataDefinition.reportTitle);
    topFrame.append(dataDefinition.reportTitleEdit);
    var statsContainer = $('<div>').addClass('stats');
    var quotientContainer = $('<div>').addClass('quotient');
    
    dataDefinition.numeratorNode = $('<div>').addClass('numerator').append(
      dataDefinition.numeratorValueDomNode).append(
      dataDefinition.numeratorFieldsDomNode);
      
    dataDefinition.denominatorNode = $('<div>').addClass('denominator').append(
      dataDefinition.denominatorValueDomNode).append(
      dataDefinition.denominatorFieldsDomNode);
      
    quotientContainer.append(dataDefinition.numeratorNode);
    quotientContainer.append(dataDefinition.denominatorNode);
    statsContainer.append( quotientContainer );
      
    statsContainer.append( $('<div>').addClass('master-percentage').append(dataDefinition.masterPercentageDomNode) );
    topFrame.append(statsContainer);

    var bottomFrame = $('<div>').addClass('data');
    var ul = $('<ul>').addClass('stack');
    bottomFrame.append(ul);
    var count = 0;
    var li = null;
    $(dataDefinition.sort).each(function(sectionIndex, sectionName) {
	  if(count % 2 == 0)
	  {
	    li = $('<li>');
		ul.append(li);
	  }
	  count++;
      var sectionDiv = $('<div>').addClass('section').addClass(sectionName);
      dataDefinition.types[sectionName].domNode = sectionDiv;
      $(sectionDiv).append($('<h3>').text(dataDefinition.types[sectionName].label));

      $(dataDefinition.types[sectionName].sort).each(function(subsectionIndex, subsectionName) {
        var subsectionDiv = $('<div>').addClass('section').addClass(subsectionName);
        dataDefinition.types[sectionName].types[subsectionName].domNode = subsectionDiv;
        $(subsectionDiv).append($('<h4>').append(
          $('<span>').text(dataDefinition.types[sectionName].types[subsectionName].label).addClass('label')).append(
          $('<span>').text('%').addClass('percentage')).append(
          $('<span>').text('#').addClass('number')
        ));

        $(dataDefinition.types[sectionName].types[subsectionName].sort).each(function(labelIndex, valueLabel) {
          var value = $('<div>').addClass('row');
          value.append($('<div>').addClass('label').text(valueLabel));
          value.append($('<div>').addClass('percentage'));
          value.append($('<div>').addClass('number'));
          value.append($('<div>').addClass('bar')); // Not sure if anything else goes here
          subsectionDiv.append(value);
        });

        dataDefinition.types[sectionName].types[subsectionName].domNode = subsectionDiv;
        sectionDiv.append(subsectionDiv);
      });

      dataDefinition.types[sectionName].domNode = sectionDiv;
      li.append(sectionDiv);
    });
    
    $([dataDefinition.numeratorNode, dataDefinition.denominatorNode]).each(function(i, type) {
      $(this).droppable({
        greedy: true,
        tolerance: 'pointer',
        activate: function(event,ui){
          $(this).toggleClass('dropshelf');
          $(this).animate({}, 700);
        },
        deactivate: function(event,ui){
          $(this).toggleClass('dropshelf');
          $(this).removeClass('over');
          $(this).animate({}, 400);
        },
        over: function(event,ui){
          $(this).toggleClass('over');
        },
        out: function(event, ui) {
          $(this).toggleClass('over');
        },
        drop: function(evt, ui) {
          ui.helper.remove(); // Remove the clone
          var fields_objs = data.denominator_fields;
          var other_objs = data.numerator_fields;
          if(type == dataDefinition.numeratorNode) {
            fields_objs = data.numerator_fields;
            other_objs = data.denominator_fields;
          }

          // Add that field to the selected list
          if(fields_objs[that.currentlyDraggedSubsection] && $.inArray(that.currentlyDraggedValue, fields_objs[that.currentlyDraggedSubsection]) > -1) {
            return;
          } else {
            if(!fields_objs[that.currentlyDraggedSubsection]) {
              fields_objs[that.currentlyDraggedSubsection] = [];
            }
            fields_objs[that.currentlyDraggedSubsection].push(that.currentlyDraggedValue);

            busy();
            // And, if it's there, remove it from the other list
            if(other_objs[that.currentlyDraggedSubsection]) {
              var inArr = $.inArray(that.currentlyDraggedValue, other_objs[that.currentlyDraggedSubsection]);
              if(inArr > -1) {
                other_objs[that.currentlyDraggedSubsection].splice(inArr, 1);
              }
            }
          
            that.reload(buildTailoredData(), 'POST'); // This should disable the UI...
          }
        }        
      });      
    });
    

    $(element).append(topFrame);
    $(element).append(bottomFrame);
  };

  // Reload data given selected fields
  this.reload = function(requestData, requestMethod) {
    $(that.exportLink).hide();    
    $.ajax({
      type: requestMethod,
      url: dataUrl,
      dataType: 'json',
      data: requestData,
      success: function(responseData) {
        data = responseData;
        if(data.id) {
          $(that.exportLink).show().attr('href', '/pophealth/export?id=' + data.id);
        } else {
          $(that.exportLink).hide().attr('href', '#');
        }
        that.refresh();
        notBusy();
        if(that.onComplete) {
          that.onComplete(responseData);
        }
      },
      error: function(xhr, resp, msg) {
        showError(resp || msg); // resp is nil if the thing completely fails
        notBusy();
        if(that.onError) {
          that.onError(xhr, resp, msg);
        }
      }
    });
  };

  // Private functions
  function _init(options) {
    busy();
    that.buildInitialDom();
    
    $('body').droppable({
       drop: function(evt, ui) {
         var reload = false;
         var inArr;
         if(data.numerator_fields[that.currentlyDraggedSubsection]) {
           inArr = $.inArray(that.currentlyDraggedValue, data.numerator_fields[that.currentlyDraggedSubsection]);
           if(inArr > -1) {
             reload = true;
             data.numerator_fields[that.currentlyDraggedSubsection].splice(inArr, 1);
           }
         }
         if(data.denominator_fields[that.currentlyDraggedSubsection]) {
           inArr = $.inArray(that.currentlyDraggedValue, data.denominator_fields[that.currentlyDraggedSubsection]);
           if(inArr > -1) {
             reload = true;
             data.denominator_fields[that.currentlyDraggedSubsection].splice(inArr, 1);
           }
         }
         if(reload) {
           busy();
           that.reload(buildTailoredData(), 'POST'); // This should disable the UI...
         }
       }
    });
    var requestData;
    var method;
    if(data.id) {
      requestData = {id: data.id};
      method = "GET";
    } else {
      requestData = buildTailoredData();
      method = "POST";
    }
    
    that.reload(requestData, method);
  };

  // The other option is to post it, which might be necessary if the query string becomes long...
  function buildTailoredData() {
    var query_object = {
      numerator: data.numerator_fields,
      denominator: data.denominator_fields
    };
    
    if(data.title) {
      query_object.title = data.title;
    }
    
    if(data.id) {
      query_object.id = data.id;
    }
    
    if(popConnect.session && popConnect.session.authToken) {
      query_object.authenticity_token = popConnect.session.authToken;
    }

    return popConnect.railsSerializer.serialize(query_object);
  };

  function showError(msg) {
    // TODO: Something...
    if(window.console != undefined && console.log != undefined)
    	console.log(msg);
  }

  // Call when you're doing some sort of work that will take awhile
  function busy() {
    busyness++;

    if(busyness > 0) { // Only show the loading indicator if it's not already showing
      rootElement.block({ message: '<img src="images/ajax-loader.gif" alt="loading" /><h2>Just a moment...</h2>',overlayCSS: { backgroundColor: '#ccc' }, css: {padding: '25px'}  });
    }
  };

  // Call when you're done doing work that will take awhile
  function notBusy() {
    busyness--;

    if(busyness < 1) { // Only hide the loading indicator if all work is finished
      $(rootElement).unblock();
    }
  };

  _init(options);
};