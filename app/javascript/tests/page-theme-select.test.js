import PageThemeSelect from '../src/page_theme_select';

test ('it sets the body class to prism-dark when dark theme is selected', () => {
  document.body.innerHTML = `
    <body>
      <select>
        <option value="dark"></option>
        <option value="light"></option>
      </select>
    </body>
  `;

  new PageThemeSelect($('select'));
  $('select').val('dark').trigger('change');

  expect($('body').attr('class')).toEqual('prism-dark');
});

test ('removes the body class prism-dark when light theme is selected', () => {
  document.body.innerHTML = `
    <body class="prism-dark">
      <select>
        <option value="dark"></option>
        <option value="light"></option>
      </select>
    </body>
  `;

  new PageThemeSelect($('select'));
  $('select').val('light').trigger('change');

  expect($('body').attr('class')).toEqual('');
});

test ('it swaps theme stylesheets', () => {
  document.body.innerHTML = `
    <link rel="stylesheet" data-theme="dark" disabled="disabled">
    <link rel="stylesheet" data-theme="light">
    <body>
      <select>
        <option value="dark"></option>
        <option value="light"></option>
      </select>
    </body>
  `;

  new PageThemeSelect($('select'));
  $('select').val('dark').trigger('change');

  expect($('link[data-theme=light]').attr('disabled')).toEqual('disabled')
  expect($('link[data-theme=dark]').attr('disabled')).toEqual(undefined)
});
