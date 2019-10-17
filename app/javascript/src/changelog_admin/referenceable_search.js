function ReferenceableSearch(selector, url) {
  this.start = function () {
    $(selector).selectize({
      maxItems: 1,
      valueField: 'id',
      labelField: 'title',
      searchField: 'title',
      sortField: [{ field: 'title', direction: 'asc'}, { field: '$score' }],
      render: {
        option: function(item, escape) {
          return '<div class="option">' + item.title + '</div>'
        }
      },
      load: function(query, callback) {
        this.clearOptions();

        if (!query.length) return callback();

        $.ajax({
          url: url,
          data: { query: query },
          type: 'GET',
          error: function() { callback(); },
          success: function(res) { callback(res); }
        });
      }
    });
  }
}

window.ReferenceableSearch = ReferenceableSearch;
