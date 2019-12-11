class AceEditorSettings {
  constructor(settings) {
    settings = settings || {}

    this.mode = `ace/mode/${settings.language}`;
    this.tabSize = settings.tab_width || 2;
    this.useSoftTabs = settings.soft_tabs || true;
  }
}

export default AceEditorSettings;
