import Collapse from '../src/collapse';

test('clicking the trigger collapses the div when it is open', () => {
  document.body.innerHTML = `
    <body>
      <div class="open">
        <a href="#" class="js-collapse-trigger" />
      </div>
    </body>
  `;

  const div = $('div');
  const select = new Collapse(div);
  $('.js-collapse-trigger').click();

  expect(div.attr('class')).toEqual('closed');
});

test('clicking the trigger opens the div when it is collapsed', () => {
  document.body.innerHTML = `
    <body>
      <div class="closed">
        <a href="#" class="js-collapse-trigger" />
      </div>
    </body>
  `;

  const div = $('div');
  const select = new Collapse(div);
  $('.js-collapse-trigger').click();

  expect(div.attr('class')).toEqual('open');
});

test('elements are collapsed by default', () => {
  document.body.innerHTML = `
    <body>
      <div>
        <a href="#" class="js-collapse-trigger" />
      </div>
    </body>
  `;

  const div = $('div');
  const select = new Collapse(div);

  expect(div.attr('class')).toEqual('closed');
});
