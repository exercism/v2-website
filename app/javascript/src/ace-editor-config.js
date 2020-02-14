class AceEditorConfig {
  constructor(config) {
    config = config || {}

    this.mode = `ace/mode/${config.language}`;
    this.tabSize = config.indent_size || 2;
    this.useSoftTabs = config.indent_style == 'space';
  }
}

export default AceEditorConfig;
