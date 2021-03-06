fixture = null
casper.start 'http://localhost:8080/test-data/reset', ->
    @test.assertHttpStatus 200, 'test data is reset'
    fixture = JSON.parse(@fetchText('pre'))

casper.then ->
    @test.info 'when the show page is opened'
    @open "http://localhost:8080/album#/show/#{fixture[0].id}"

casper.then ->
    @test.assertUrlMatch /#\/show\/\d+$/, 'show view is loaded'
    @waitForSelector '[data-ng-bind="item.artist"]:not(:empty)', ->
        @test.info 'when the delete button is clicked'
        @click 'button.btn-danger'
    , ->
        @test.fail 'data should have loaded into show page'

casper.then ->
    @test.info 'return to the list view'
    @test.assertUrlMatch /#\/list$/, 'the list view is loaded'
    @waitForSelector 'tbody tr:nth-child(4)', ->
        titles = @getColumn(2)
        @test.assertEquals titles.length, 4, 'there are now fewer items in the list'
        @test.assert fixture[0].title not in titles, 'the item has been deleted'
    , ->
        @test.fail 'data should have loaded into list page'

casper.run ->
    @test.done()