describe("jHueTableExtender plugin", function () {

  beforeEach(function () {
    if (jasmine.fromNode == undefined){
      jasmine.getFixtures().fixturesPath = 'static/jasmine/';
    }
    loadFixtures('jHueTableExtenderFixture.html');
    $(".resultTable").dataTable({
      "bPaginate":false,
      "bLengthChange":false,
      "bInfo":false
    });
    $(".resultTable").jHueTableExtender({
      fixedHeader:true,
      firstColumnTooltip:true
    });
  });

  it("should create the navigator element", function () {
    expect($("#jHueTableExtenderNavigator")).toExist();
  });

});