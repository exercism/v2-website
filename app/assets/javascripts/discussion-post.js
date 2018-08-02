function DiscussionPost(id, content) {
  this.id = id;
  this.editorInitialized = false;
  this.node = $('#discussion-post-' + id);

  this.bindEvents();
}

DiscussionPost.prototype.bindEvents = function() {
  this.node.find('.js-edit-discussion-post').on('click', this.startEditing.bind(this));
  this.node.find('.js-show-discussion-post').on('click', this.stopEditing.bind(this));
}

DiscussionPost.prototype.startEditing = function(e) {
  e.preventDefault();

  this.node.addClass('editing');

  if (!this.editorInitialized) {
    this.node.find('textarea').markdown({
      iconlibrary: 'fa',
      hiddenButtons: 'cmdHeading cmdImage cmdPreview'
    })

    this.editorInitialized = true;
  }

  this.bindEvents();
};

DiscussionPost.prototype.stopEditing = function(e) {
  e.preventDefault();

  this.node.removeClass('editing');

  this.bindEvents();
};
