class AceEditorConfig {
  constructor(config) {
    config = config || {}

    this.mode = `ace/mode/${config.language}`;
    this.tabSize = config.tab_width || 2;
    this.useSoftTabs = config.soft_tabs || true;
  }
}

export default AceEditorConfig;
