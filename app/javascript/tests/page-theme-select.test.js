import PageThemeSelect from '../src/page_theme_select';

test ('it sets the body class to prism-dark when dark theme is selected', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="dark"></option>
        <button value="light"></option>
      </form>
    </body>
  `;

  const select = new PageThemeSelect($('form'));
  $('button[value=dark]').click();

  expect($('body').attr('class')).toEqual('prism-dark');
});

test ('it highlights the selected button', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="dark"></option>
        <button value="light"></option>
      </form>
    </body>
  `;

  const select = new PageThemeSelect($('form'));
  $('button[value=dark]').click();

  expect($('button[value=dark]').attr('selected')).toEqual('selected');
  expect($('button[value=light]').attr('selected')).toEqual(undefined);
});

test ('removes the body class prism-dark when light theme is selected', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="dark"></option>
        <button value="light"></option>
      </form>
    </body>
  `;

  const select = new PageThemeSelect($('form'));
  $('button[value=light]').click();

  expect($('body').attr('class')).toEqual('');
});

test ('it swaps theme stylesheets', () => {
  document.body.innerHTML = `
    <link rel="stylesheet" data-theme="dark" disabled="disabled">
    <link rel="stylesheet" data-theme="light">
    <body>
      <form onsubmit="return false;">
        <button value="dark"></option>
        <button value="light"></option>
      </form>
    </body>
  `;

  const select = new PageThemeSelect($('form'));
  $('button[value=dark]').click();

  expect($('link[data-theme=light]').attr('disabled')).toEqual('disabled')
  expect($('link[data-theme=dark]').attr('disabled')).toEqual(undefined)
});
