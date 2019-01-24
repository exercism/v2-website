// Type is hyphenated node
function EditableText(type, id, content) {
  this.id = id;
  this.editorInitialized = false;
  this.node = $('#' + type + '-' + id); // e.g. #discussion-post-10

  this.bindEvents();
}

EditableText.prototype.bindEvents = function() {
  this.node.find('.js-edit-editable-text').on('click', this.startEditing.bind(this));
  this.node.find('.js-show-editable-text').on('click', this.stopEditing.bind(this));
}

EditableText.prototype.startEditing = function(e) {
  e.preventDefault();

  this.node.addClass('editing');

  if (!this.editorInitialized) {
    this.node.find('textarea').markdown({
      iconlibrary: 'fa',
      hiddenButtons: 'cmdHeading cmdImage cmdPreview',
      resize: 'vertical'
    })

    this.editorInitialized = true;
  }

  this.bindEvents();
};

EditableText.prototype.stopEditing = function(e) {
  e.preventDefault();

  this.node.removeClass('editing');

  this.bindEvents();
};
