/*jslint indent: 2, onevar: false, browser: true, onevar: false, white: false  */
/*global $, cyoc */

if(popConnect === undefined) {
  var popConnect = {};
}

popConnect.ReportNavigator = function(element, options) {
  // Private member variables
  var data = options.data || {};
  var rootElement = $(element);             // Root DOM element for UI
  var dataUrl = options.dataUrl || '/data'; // Where to get data from...not restful, whatever
  var that = this;                          // Traditional javascript nonsense
  var busyness = 0;                         // Current number of jobs. Controls when loading indicator is shown. Don't change directly, use busy/notBusy
  var reportId = options.reportId;          // Report ID, in case we need to send it in the data
  var onComplete = options.complete;        // Callback for when data is loaded
  var onError = options.error;              // Callback for when data doesn't load
  var dataViewer = options.dataViewer;
  
  var domReferences = {};

  // Public functions


  // ........ are there any ??? ..........

  // Priviledged functions
  // Can access both public and private variables and methods

  // This probably shouldn't be used...but I'm adding it just in case
  this.getData = function() {
    return data;
  };
  
  this.refresh = function() {
    domReferences.reportsContainer.empty();
    
    domReferences.populationCount.text( data.populationCount);
    domReferences.populationName.text(data.populationName);
    
    $(data.reports).each(function(i, report) {
      var reportDom = $('<li>').addClass('report').append(
        $('<span>').addClass('report-name').text(report.name)).append(
        $('<span>').addClass('report-percentage').text(report.percentage + '%')).click(function() {
          if(!reportDom.hasClass('selected')) {
            domReferences.reportsContainer.children().removeClass('selected');
            reportDom.addClass('selected');
            if(dataViewer) {
              dataViewer.selectReport({reportId: report.dataUrl}); 
            }
          }
      });
      domReferences.reportsContainer.append(reportDom);
    });
  };

  // Reload via Ajax
  this.reload = function() {
    busy();

    $.ajax({
      method: 'GET',
      url: dataUrl,
      dataType: 'json',
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


  // Build the initial DOM containers
  // Set the domNode references too!
  this.buildInitialDom = function() {
    domReferences.navContent = $('<div>');
    domReferences.busyIndicator = $('<div>').append($('<img>').attr('src', 'images/ajax-loader.gif').attr('alt', 'Loading')).append('<span>').text('Just a moment...').hide();
    
    var populationStatsContainer = $('<div>').attr('id', 'info');
    domReferences.populationCount = $('<h1>').text('0');
    domReferences.populationName = $('<span>').text('No population');
    populationStatsContainer.append(domReferences.populationCount).append(domReferences.populationName);
    
    domReferences.reportsContainer = $('<ul>').attr('id', 'reports');
    
    domReferences.navContent.append(populationStatsContainer).append(domReferences.reportsContainer);
    
    rootElement.append(domReferences.navContent).append(domReferences.busyIndicator);
  };

  // Private functions
  function _init() {
    that.buildInitialDom();
    that.reload();
  };

  // The other option is to post it, which might be necessary if the query string becomes long...
  function buildRequestData() {

  };

  function showError(msg) {
    // TODO: Something...
    console.log(msg);
  }

  // Call when you're doing some sort of work that will take awhile
  function busy() {
    busyness++;

    if(busyness > 0) { // Only show the loading indicator if it's not already showing
      domReferences.navContent.hide();
      domReferences.busyIndicator.show();
    }
  };

  // Call when you're done doing work that will take awhile
  function notBusy() {
    busyness--;

    if(busyness < 1) { // Only hide the loading indicator if all work is finished
      domReferences.navContent.show();
      domReferences.busyIndicator.hide();
    }
  };

  _init();
}