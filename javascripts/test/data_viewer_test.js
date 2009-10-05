$(document).ready(function() {
  module("PopConnect.DataViewer");

  test("constructor and init", function() {
    stop();
    var dataViewer = new popConnect.DataViewer('#data_viewer', {
      dataUrl: 'data/json_response.js',
      complete: function() {
        start();
        equals(0, dataViewer.getData().numerator, "test data numerator should be 0");
        equals(4100, dataViewer.getData().denominator, "test data denominator should be 4100");
      },
      error: function() {
        start();
        ok(false, "Something broke!");
      }
    });
  });
});