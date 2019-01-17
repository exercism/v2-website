function BlogComment(id, content) {
  this.id = id;
  this.editorInitialized = false;
  this.node = $('#blog-comment-' + id);

  this.bindEvents();
}

BlogComment.prototype.bindEvents = function() {
  this.node.find('.js-edit-blog-comment').on('click', this.startEditing.bind(this));
  this.node.find('.js-show-blog-comment').on('click', this.stopEditing.bind(this));
}

BlogComment.prototype.startEditing = function(e) {
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

BlogComment.prototype.stopEditing = function(e) {
  e.preventDefault();

  this.node.removeClass('editing');

  this.bindEvents();
};

