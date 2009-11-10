$(document).ready(function() {
  module("PopConnect");
  
  test('Global popConnect object must exist', function() {
    ok(popConnect != undefined, 'Global popConnect object should exist');
  });
  
  test('Rails serializer should serialize objects correctly', function() {
    var obj = {something: 'yes', somethingElse: {something: 'yes'}};
    equals(popConnect.railsSerializer.serialize(obj), 'something=yes&somethingElse%5Bsomething%5D=yes', 'Rails serializer should serialize nested objects correctly');
    obj.somethingElse = ['yes', 'no'];
    equals(popConnect.railsSerializer.serialize(obj), 'something=yes&somethingElse%5B0%5D=yes&somethingElse%5B1%5D=no', 'Rails serializer should serialize nested objects correctly');
  });
  
});