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
    
    domReferences.populationCount.text( addCommas(data.populationCount) );
    domReferences.populationName.text(data.populationName+' Population');
    
    $(data.reports).each(function(i, report) {
      report.domNode = buildReportDom(report);
      domReferences.reportsContainer.append(report.domNode);
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
    
    domReferences.newReport = $('<div>').append($('<span>').text('New report')).addClass('new-report').click(function() {
      domReferences.reportsContainer.children().removeClass('selected');
      if(dataViewer) {
        dataViewer.newReport();
      }
    });
    
    domReferences.navContent.append(populationStatsContainer).append(domReferences.reportsContainer).append(domReferences.newReport);
    
    rootElement.append(domReferences.navContent).append(domReferences.busyIndicator);
  };
  
  this.updateReport = function(reportData) {
    domReferences.reportsContainer.children().removeClass('selected');
    if(reportData.id) {
      var found = false;
      $(data.reports).each(function(i, report) {
        if(report.id == reportData.id) {
          report.title = reportData.title;
          report.denominator = reportData.denominator;
          report.numerator = reportData.numerator;
          
          report.domNode.find('.report-name').text(report.title);
          var percentage = 0;
          if(reportData.denominator > 0) {
            percentage = reportData.numerator / reportData.denominator * 100;
          }
          if(percentage < 0.5 && percentage > 0) {
            report.domNode.find('.report-percentage').text('<1%');
          } else {
            report.domNode.find('.report-percentage').text(Math.round(percentage) + '%');
          }
          found = true;
          report.domNode.addClass('selected');
        }
      });
      if(!found) {
        report = {
          title: reportData.title,
          id: reportData.id
        }
        var percentage = 0;
        if(reportData.denominator > 0) {
          percentage = reportData.numerator / reportData.denominator * 100;
        }
        report.domNode = buildReportDom(report);
        report.domNode.addClass('selected');
        domReferences.reportsContainer.append(report.domNode);
        if(data.reports)
          data.reports.push(report);
      }
    } 
  }

  // Private functions
  function _init(options) {
    if(options.dataViewer) {
      options.dataViewer.onComplete = that.updateReport;      
    }
    
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
  
  function buildReportDom(report) {
    var percentage = 0;
    if(report.denominator > 0) {
      percentage = report.numerator / report.denominator * 100;
    }
    
    if(percentage < 0.5 && percentage > 0) {
      var text = '<1%';
    } else {
      var text = Math.round(percentage) + '%';
    }
    
    var reportDom = $('<li>').addClass('report').append(
      $('<span>').addClass('report-name').text(report.title)).append(
      $('<span>').addClass('report-percentage').text(text)).click(function() {
        if(!report.domNode.hasClass('selected')) {
          domReferences.reportsContainer.children().removeClass('selected');
          reportId = report.id;
          report.domNode.addClass('selected');
          if(dataViewer) {
            dataViewer.selectReport(report.id);
          }
        }
    });
    if(reportId == report.id)
      reportDom.addClass('selected');
    return reportDom;
  }

  _init(options);
}