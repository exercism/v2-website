$(function() {
  $('#code-editor').each(function() {
    const editor = ace.edit(this);
    const language = $(this).data('language')

    editor.setTheme('ace/theme/monokai');
    editor.session.setMode(`ace/mode/${language}`);
  });
});
